<script lang="typescript" >

    import L from "leaflet";
    import { count, arePanelsVisible } from "./store.js";
    import { afterUpdate } from 'svelte';
    import { createEventDispatcher } from 'svelte';
    import { onMount } from "svelte";
    // import { isMobile } from "./screenUtils.js";

    const dispatch = createEventDispatcher();
    export let filters;
    export let geojson;
    let isMobile;

    let holderClass = "";
    // let plusInnerHTML = "V";

    let closeSVG = `
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--blue)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <line x1="18" y1="6" x2="6" y2="18"></line>
    <line x1="6" y1="6" x2="18" y2="18"></line>
    </svg>
    `;

    let openSVG = `
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <line x1="12" y1="5" x2="12" y2="19"></line>
    <line x1="5" y1="12" x2="19" y2="12"></line>
    </svg>
    `;

    let hideSVG = `
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--blue)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <line x1="5" y1="12" x2="19" y2="12"></line>
    </svg>
    `;

    let plusInnerHTML = openSVG;

    function expander() {
        let holder = document.getElementById('holder');
        holder.classList.toggle('hidden');
        plusInnerHTML = holder.classList.contains('hidden') ? openSVG : hideSVG;
    }

    function checkScreenWidth() {
		isMobile = window.innerWidth <= 767; // Adjust the breakpoint as needed
	}

    onMount(() => {
        checkScreenWidth();
    	window.addEventListener("resize", checkScreenWidth);
        plusInnerHTML = holderClass === "hidden" ? openSVG : hideSVG;
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
            let actCodes = feature.properties.activity_codes.split(',').map(code => code.trim());
            // console.log(actCodes);
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
            arePanelsVisible.set(false);
            return d.properties.site_id == e.target.id
        }) 
        dispatch('message', {
                active: clicked_list
            });
        map.flyTo( L.geoJson(clicked_list).getBounds().getCenter() , 15, {
            animate: true,
            duration: 1
        }); 
    }

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
{#if map_data.length > 0}  
<button on:click={expander}> 
    <div class="site-button">  
        {#if map_data.length > 0}                  
            <span class="t2 search">Search Results</span>
            <span id="collapse-nav-button">{@html plusInnerHTML}</span>
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
    {:else}
        <!-- <span class="t3">There are no sites matching with the search criteria</span> -->
    {/if}
</div>
{/if}

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
        padding-right: 5px;
    }

    .search {
        margin-left: 9px;
        color: var(--blue);
    }

    @media (max-width: 767px) {
        .site-button {
            padding-right: 0px;
        }

    }

</style>