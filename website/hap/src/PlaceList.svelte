<script lang="typescript" >

    import L from "leaflet";
    import { count } from "./store.js";
    import { afterUpdate } from 'svelte';
    import { createEventDispatcher } from 'svelte';
    import { onMount } from "svelte";
    // import { isMobile } from "./screenUtils.js";

    const dispatch = createEventDispatcher();
    export let filters;
    export let geojson;
    let isMobile;

    let holderClass = "";
    let plusInnerHTML = "V";

    function expander() {
        let holder = document.getElementById('holder');
        holder.classList.toggle('hidden');
        plusInnerHTML = holder.classList.contains('hidden') ? "+" : "x";
    }

    function checkScreenWidth() {
		isMobile = window.innerWidth <= 767; // Adjust the breakpoint as needed
	}

    onMount(() => {
        checkScreenWidth();
    	window.addEventListener("resize", checkScreenWidth);

        holderClass = isMobile ? "hidden" : "";
        plusInnerHTML = holderClass === "hidden" ? "+" : "x";
    });

    //countValue is map object stored in the store.js
    let map;
    count.subscribe(value => {map = value});

    //Prepare data to be filtered by geojson object
    function dataFilter(feature) {
        //ACTIVITY FEATURE Filters
        // Boolean that tracks whether or not the feature should be displayed based on activity filters
        let act_remain;
        if (filters.act_filters.length === 0){
            // Show the feature gray if there are no filters
            feature.properties.act_remain = "active";
            act_remain=false;
        }else{
            // Only show the feature if the feature's activity code is included in one
            // of the existing activity filters
            let actCodes = feature.properties.act_codes.split(',').map(code => code.trim());
            console.log(actCodes);
            const isActive = filters.act_filters.some(el => actCodes.includes(el));

            if (isActive) {
                feature.properties.act_remain = "active";
                act_remain = true;
            } else {
                feature.properties.act_remain = "inactive";
                act_remain = false;
            }

        }

         //Site FEATURE Filters
         // Boolean that tracks whether or not the feature should be displayed based on activity filters
        let feature_remain;

        // Show the feature gray if there are no filters
        if( filters.feature_filters.length === 0){
            feature.properties.feature_remain = "active";
            feature_remain = false;
        }else{
            const allFeatureFilters = filters.feature_filters.every(feature_filter => feature.properties[feature_filter] === "Y");

            if (allFeatureFilters) {
                feature.properties.feature_remain = "active";
                feature_remain=true;
            } else {
                feature.properties.feature_remain = "inactive";
                feature_remain=false;
            }
        }

        let text_remain = true;
        if ( filters.text_filter.length > 0) {
            // if (feature.properties.site_name.toUpperCase().includes( filters.text_filter.toUpperCase() ) || feature.properties.program_name.toUpperCase().includes( filters.text_filter.toUpperCase() )){
            // if (feature.properties.program_name.toUpperCase().includes( filters.text_filter.toUpperCase() )){
            // if (feature.properties.site_name.toUpperCase().includes( filters.text_filter.toUpperCase() )){
                if (
                    feature.properties.site_name.toUpperCase().includes(filters.text_filter.toUpperCase()) ||
                    (feature.properties.program_name && feature.properties.program_name.toUpperCase().includes(filters.text_filter.toUpperCase()))
                ) {
                feature.properties.text_remain = "active";
                text_remain = true;
            } else {
                feature.properties.text_remain = "inactive";
                text_remain = false;
            }
            if (feature.properties.act_remain == "active" && feature.properties.feature_remain == "active" && feature.properties.text_remain == "active") {
                feature.properties.remain = "active";
            }else {
                feature.properties.remain = "inactive";
            }
        }// this makes the points black when there are no filters
        else if (filters.act_filters.length === 0 && filters.feature_filters.length === 0 && filters.text_filter.length === 0) {
            feature.properties.remain = "inactive";
        }
        else {
            text_remain = false;
            if (feature.properties.act_remain == "active" && feature.properties.feature_remain == "active") {
                feature.properties.remain = "active";
            }else {
                feature.properties.remain = "inactive";
            }
        }
        return(feature)
    }

    //Filter list of parks based on filters
    let map_data = geojson.filter( dataFilter );
        map_data = map_data.filter( function(feature){
        /// displays the name of any park that meets all above criteria
        if (feature.properties.remain === "active" ){
            return true;
        } else {
            return false;
        }
        })

    // Sort the filtered map_data array based on the site_name property
    map_data.sort((a, b) => {
        const siteNameA = a.properties.site_name.toUpperCase();
        const siteNameB = b.properties.site_name.toUpperCase();

        if (siteNameA < siteNameB) {
            return -1;
        }
        if (siteNameA > siteNameB) {
            return 1;
        }
        return 0;
    });

    //When an item from the list is clicked.
    //1. Set view, 2. update and dispatch clicked polygon
    function clickHandle(e){
        let clicked_list = geojson.filter( function(d){
            return d.properties.site_id == e.target.id
        }) 
        dispatch('message', {
                active: clicked_list
            });
        map.flyTo( L.geoJson(clicked_list).getBounds().getCenter() , 15, {
            animate: true,
            duration: 1
        }); // Zoom to point
    }


    // function expander(){
    //     let holder = document.getElementById('holder');
    //     holder.hidden = !holder.hidden;

    //     let plus = document.getElementById('collapse-nav-button');
    //     if (plus.innerHTML == "+"){
    //         plus.innerHTML = "&#8722;"
    //     }else{
    //         plus.innerHTML = "+"
    //     }       
    // }

    // scroll to after loading.
    afterUpdate(() => {

        let this_cont;
        let prev_cont;

        let placelists = [...document.getElementsByClassName( 'place-list' )];
        placelists.forEach( function(place){
            if (place.id === filters.active){
                this_cont = place;
            }

            if (place.id === filters.previous){
                prev_cont = place;
            }
        })

		let place_cont = document.getElementById('holder');

		if (this_cont && place_cont ){ //If both already are created

            if(prev_cont){
                place_cont.scroll({
                top:prev_cont.offsetTop,
                behavior:'auto'
                    })
            }

			place_cont.scroll({
				top:this_cont.offsetTop,
				behavior:'smooth'
			})
        }
    });

</script>

<!-- svelte-ignore missing-declaration -->
<button on:click={expander}> 
    <div class="site-button">  
        {#if map_data.length > 0}                  
            <span class="t2 search">Search Results</span>
            <span id="collapse-nav-button">{plusInnerHTML}</span>
        {/if}
    </div>
</button>
<div id="holder" class={holderClass}>
    
    {#if map_data.length > 0}
        <!-- Accessibility: on:keydown is for users that rely on keyboard navigation -->
        {#each map_data as d }
            <div class="place-list t3 {d.properties.site_id}" id={d.properties.site_id} on:click={e=>{clickHandle(e)}} on:keydown={e=>{clickHandle(e)}}>
                {d.properties.site_name}
            </div>
        {/each}
    <!-- {:else}
        <span class="t3">There are no sites matching with the search criteria</span> -->
    {/if}
</div>

<style>

    #collapse-nav-button:before {
        font-weight: bold;
    }

    .hidden {
        display: none;
    }

    .site-button {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .search {
        margin-left: 9px;
    }

</style>