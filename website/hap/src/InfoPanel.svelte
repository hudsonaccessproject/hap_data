<script>
    import { count, arePanelsVisible } from "./store.js";
    import L from "leaflet";
    import Carousel from "svelte-carousel";
    
    export let active_point;
    let map;
    count.subscribe(value => {
        map = value;
    });


    // define array for images if they exist
    let images = [];
    let carousel;

    let closeSVG = `
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="18" y1="6" x2="6" y2="18"></line>
        <line x1="6" y1="6" x2="18" y2="18"></line>
    </svg>
    `;

    //Use these for activitiy feature ucons
	// let acts = [
	// 	{value:"FISH", name:"Fishing", source:"https://raw.githubusercontent.com/skhaji/test_data/main/activities/Activities_in_circles/fishing.svg" ,
	// 	desc:"You can fish here."},
	// 	{value:"SWIM",name:"Swimming" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/activities/Activities_in_circles/swimming.svg" ,
	// 	desc:"You can swim here."},
	// 	{value:"HPBL",name:"Human-powered boating" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/activities/Activities_in_circles/hp_boating.svg" ,
	// 	desc:"You can kayak here."},
	// 	{value:"MPBL",name:"Motor boating" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/activities/Activities_in_circles/mp_boating.svg" ,
	// 	desc:"You can motor boat here."}
	// ]

     let acts = [
		{
		value: "FISH",
		name: "Fishing",
		  source: "/hudsonaccessproject/assets/icons/activities/fishing.svg",
		desc: "You can fish here."
		},
		{
		value: "SWIM",
		name: "Swimming",
		  source: "/hudsonaccessproject/assets/icons/activities/swimming.svg",
		desc: "You can swim here."
		},
		{
		value: "HPBL",
		name: "Human-powered boating",
		  source: "/hudsonaccessproject/assets/icons/activities/hp_boating.svg",
		desc: "You can kayak here."
		},
		{
		value: "MPBL",
		name: "Motor boating",
		  source: "/hudsonaccessproject/assets/icons/activities/mp_boating.svg",
		desc: "You can motor boat here."
		}
	];

    //Use these for creating site feature buttons and info panel icons
	let site_feature_icons = [
		{value:"boat_launch_YN", name:"Boat launch", source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/boat_launch_cricle.svg" ,
		desc:"There is a boat launch"},
		{value:"restrooms",name:"Restrooms" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/restrooms_circle.svg" ,
		desc:"There are restrooms."},
		{value:"public_transit",name:"Publi transit" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/transit_circle.svg" ,
		desc:"Site is accessible by public transit"},
		{value:"parking",name:"Parking" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/parking_circle.svg" ,
		desc:"There is parking"},
		{value:"food", name:"Food", source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/food_circle.svg" ,
		desc:"There is food here."},
		{value:"drinking_water",name:"Drinking water" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/drinking_water_circle.svg" ,
		desc:"There is drinking water here."},
		{value:"picnic_area",name:"Picnic area" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/food_circle.svg" ,
		desc:"You can picnic here."},
		{value:"hiking",name:"Hiking" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/activities/Activities_in_circles/hiking_walking.svg" ,
		desc:"You can hike here."},
		// {value:"pets_allowed",name:"Pets allowed" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/pets_allowed.svg" ,
		// desc:"Pets are allowed here."},
		{value:"program",name:"Programming" , source:"https://raw.githubusercontent.com/skhaji/test_data/main/amenities/guided_tour_circle.svg" ,
		desc:"There is programming here."},
	]

    // create array to hold site activiteis for the site
    let site_acts = [];
    // create array to hold site features for the site
    let site_features = [];

    if (active_point) {
        active_point = active_point[0].properties;
        let actCodes = active_point.act_codes.split(',').map(code => code.trim());

        if (active_point.site_name_photo_01) {
            images.push({url: `https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/photos/${active_point.site_name_photo_01}`, description: 'image1'});
        }
        if (active_point.site_name_photo_02) {
            images.push({url: `https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/photos/${active_point.site_name_photo_02}`, description: 'image2'});
        }
        if (active_point.site_name_photo_03) {
            images.push({url: `https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/photos/${active_point.site_name_photo_03}`, description: 'image3'});
        }

        acts.forEach(function (act) {
            // icheck if act.value is in actCodes, if it is, add it to site_acts
            if (actCodes.includes(act.value)) {
                site_acts.push(act);
            }
        });

        site_feature_icons.forEach(function (feature_icon) {
            // check if the property of the same name as the feature icon is true
            if (active_point[feature_icon.value] == "Y") {
                site_features.push(feature_icon);
            }
        });
    }

    function closeDiv() {
        active_point = null; // this is a hack to remove previous polygon
        map.eachLayer(layer => {
            if (layer instanceof L.Layer && layer.feature && layer.feature.geometry && layer.feature.geometry.type === 'MultiPolygon') {
                map.removeLayer(layer);
            }
        });
        arePanelsVisible.set(true);
    }

</script>

{#if active_point}
    <div class = "info-panel">
        <div class="park-header">
            <span class="close" on:click={closeDiv}  on:keydown={closeDiv}>{@html closeSVG}</span>
            <p class="park-name">{active_point.site_name}</p>
            {#if active_point.program_name}
                <p class="park-subname">{active_point.program_name}</p>
            {/if}
            <div class="act-container">
                {#each site_acts as site_act}
                        <img class="act-icon" alt={site_act.value} src= {site_act.source}/>
                {/each}
            </div>
        </div>
        <div class="park-details">
            {#if active_point.address}
                <p><span>Address:</span> {active_point.address}</p>
            {/if}
            {#if active_point.site_description}
            <p><span>Site description:</span> {active_point.site_description}</p>
            {/if}
            {#if active_point.site_name_photo_01}
                <div class="carousel-container">
                    <Carousel
                        bind:this={carousel}
                        let:loaded
                    >
                        {#each images as src, imageIndex (src)}
                        <div class="img-container">
                            {#if loaded.includes(imageIndex)}
                            <img src={src.url} alt={src.description} class="site_photo" />
                            {/if}
                        </div>
                        {/each}
                    </Carousel>
                </div>
            {/if}
            {#if active_point.hours_info}
                <p><span>Hours:</span> {active_point.hours_info}</p>
            {/if}
            {#if active_point.accessibility_description}
                <p><span>Accessibility description:</span> {active_point.accessibility_description}</p>
            {/if}
            {#if active_point.public_transit_description}
                <p><span>Public transit options:</span> {active_point.public_transit_description}</p>
            {/if}
            {#if active_point.parking_description}
                <p><span>Parking description:</span> {active_point.parking_description}</p>
            {/if}
            {#if active_point.url_public}
            <p>
                <span>Website:</span>
                {#if active_point.url_public.startsWith('http://') || active_point.url_public.startsWith('https://')}
                    <a href="{active_point.url_public}" target="_blank">link</a>
                {:else}
                    <a href="https://{active_point.url_public}" target="_blank">link</a>
                {/if}
            </p>
            {/if}
            {#if active_point.safety}
            <p><span>Safety considerations:</span> {active_point.safety}</p>
            {/if}
            {#if active_point.program_name}
            <p><span>Program name:</span> {active_point.program_name}</p>
            {/if}
            {#if active_point.program_description}
            <p><span>Program description:</span> {active_point.program_description}</p>
            {/if}
            {#if active_point.program_url}
                <p>
                    <span>Programming website:</span>
                    {#if active_point.program_url.startsWith('http://') || active_point.program_url.startsWith('https://')}
                        <a href="{active_point.program_url}" target="_blank">link</a>
                    {:else}
                        <a href="https://{active_point.program_url}" target="_blank">link</a>
                    {/if}
                </p>
            {/if}
            <!-- <p><span>Site amenities:</span></p>
            <div class="amenity-icons">
                {#each site_features as site_feature}
                        <img class="amenity-icon" alt={site_feature.value} src= {site_feature.source}  title={site_feature.desc}/>
                {/each}
            </div> -->
            <div class="amenities-container">
                <span class="d">Site amenities:</span>
                <div class="amenity-icons">
                {#each site_features as site_feature}
                    <img class="amenity-icon" alt={site_feature.value} src={site_feature.source} title={site_feature.desc}/>
                {/each}
                </div>
            </div>
        </div>    
    </div>
{:else}
    <!-- <div>No active data</div> -->
{/if}

<style>
.park-header {
    background-color: #FFAA22;
    color: #000;
    padding: 15px 10px 15px 15px;
    /* border-bottom: 5px solid #FFAA22;
    border-top: 5px solid #FFAA22; */
}

.park-details {
    padding: 0px 15px 15px 15px;
}

.park-details p {
    padding-top: 10px;
    margin: 0px;
}

.park-name {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 0px;
    /* padding-bottom: 15px; */
}

.park-subname {
    font-size: 18px;
    font-weight: 400;
    margin-bottom: 1px;
    margin-top: 0px;
}

p span {
    font-weight: 600;
}

.d {
    font-weight: 600;
}

.act-container {
    padding-top: 5px;
}

.act-icon {
    width: 30px;
    height: 30px;
    margin-left: 5px;
}
.amenities-container {
    display: flex;
    align-items: center;
    padding-top: 15px;
  }

.amenity-icons {
    display: flex;
    flex-wrap: wrap;
}

.amenity-icon {
    width: 20px;
    height: 20px;
    margin-left: 5px;
}

.close {
    float: right;
    font-size: 20px;
    font-weight: 600;
    margin-right: 5px;
    margin-top: -5px;
    margin-bottom: 0px;
    cursor: pointer;
    color: #222;
}

.site_photo {
    position: relative;
    width: 100%;
}

.carousel-container {
    padding-top: 15px;
}


</style>