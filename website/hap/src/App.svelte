<script>

	import LeafletMap from './Map.svelte'
	import GeoPoint from './GeoPoint.svelte';
	import Polygon from './Polygon.svelte';
	import ActPoint from './ActPoint.svelte';
	import SafetyPoint from './SafetyPoint.svelte';
	import {onMount, afterUpdate} from 'svelte'
	import Header from './components/Header.svelte';	
	// import Hoverup from './Hoverup.svelte';
	import Title from './Title.svelte';
	import PlaceList from './PlaceList.svelte';
	import CollapsibleSection from './CollapsibleSection.svelte'
	import InfoPanel from './InfoPanel.svelte';
	import WaterSafety from './WaterSafety.svelte';
	import WaterQuality from './WaterQuality.svelte';
	import About from './About.svelte';
	import HomeButton from './Home.svelte'
	import WaterQualityLegend from './WaterQualityLegend.svelte';
	import WaterSafetyLegend from './WaterSafetyLegend.svelte';
	// import { count, activePageTracker} from "./store.js";
	import { count, activePageTracker, arePanelsVisible } from "./store.js";

	let title = "The Hudson Access Project is collecting information about all the places where the public can get into and onto the water in the Hudson & Harbor Estuary and its tributaries for swimming, boating, and fishing; with a focus on activities that bring people into direct contact with the water."

	// let showTooltip = false;
	let point_data;
	let act_data;
	let poly_data;
	let temp_data;
	let waterTemp;
	let tidesData;
    let nextHighTide;
	let all_poly_data;
	let all_point_data;
	let act_point_data;
	let temp_point_data;
	let active_data;
	let active_point;
	let stage;
	let showTooltip = false;
	// defines whether there is a address bar at the bottom
	// let safeAreaBottom; 

	const emptyFilters = {
		act_filters: [],
		feature_filters: [],
		prog_filters: [],
		text_filter: "",
		pollution_filters: [],
		active: [],
		previous: []
	};

	const point_url = "/hudsonaccessproject/assets/hap_site_points_20240623.geojson";
	const act_point_url = "/hudsonaccessproject/assets/hap_act_points_20240619.geojson";
	const polygon_url = "/hudsonaccessproject/assets/hap_site_poly_20240619.geojson";
	const temp_url = "/hudsonaccessproject/assets/hap_noaa_stations.geojson";

	// const point_url = "/assets/hap_site_points_20240623.geojson"; 
	// const act_point_url = "/assets/hap_act_points_20240619.geojson";
	// const polygon_url = "/assets/hap_site_poly_20240619.geojson";
	// const temp_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_noaa_stations.geojson";
	const water_temp_url = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?date=latest&station=8518750&product=water_temperature&time_zone=lst_ldt&units=english&format=json";
	const tides_today_url = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?date=today&station=8518750&product=predictions&datum=MLLW&time_zone=lst_ldt&interval=hilo&units=english&application=DataAPI_Sample&format=json";


	let safetyTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/clpvm5jgq00yi01qmb4p5ffbj/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
    let qualityTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/cltem7qhl003901qu59ef3zow/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
	let regTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/cli2a1j4w04qg01qn1cfaaqta/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'

	//countValue is map object stored in the store.js
    let map;
    count.subscribe(value => {map = value});

	function changeBasemap(newTileURL) {
		map.eachLayer(function (layer) {
			if (layer instanceof L.TileLayer) {
			layer.setUrl(newTileURL);
			}
		});
	}

	function removePoints() {
		map.eachLayer(layer => {
			if (layer instanceof L.Layer && layer.feature && layer.feature.geometry && layer.feature.geometry.type === 'Point') {
			map.removeLayer(layer);
			}
		});
	}

	function removePolygons() {
		map.eachLayer(layer => {
			if (layer instanceof L.Layer && layer.feature && layer.feature.geometry && (layer.feature.geometry.type === 'MultiPolygon' || layer.feature.geometry.type === 'Polygon')) {
			map.removeLayer(layer);
			}
		});
	}

	$: {
		switch($activePageTracker) {
			// using stage to identify when the map is not in its initial state.  otherwise, the access 
			// case messes up the initial loading of the map
			case 'access':
				console.log(stage);
				if (stage == 'updated') {
					removePoints();
					removePolygons();
					filters = { ...emptyFilters };
					changeBasemap(regTileURL);
				}
				break;
			case 'safety':
				stage = 'updated';
				removePoints();
				removePolygons();
				changeBasemap(safetyTileURL);
				break;
			case 'quality':
				stage = 'updated';
				removePoints();
				removePolygons();
				filterPollution();
				changeBasemap(qualityTileURL);
				break;
			case 'about':
				stage = 'updated';
				removePoints();
				removePolygons();
				filters = { ...emptyFilters };
				changeBasemap(regTileURL);
				break;
			default:
		}
	}

	
	onMount(async () => {

		// const body = document.body;
		// safeAreaBottom = window.innerHeight - document.documentElement.clientHeight;
		// body.style.paddingBottom = safeAreaBottom + 'px';

		const res = await fetch( point_url );
		point_data = await res.json();

		all_point_data = [...point_data.features]

		const res3 = await fetch( act_point_url );
		act_data = await res3.json();

		act_point_data = [...act_data.features]

		const res2 = await fetch( polygon_url );
		poly_data = await res2.json();

		all_poly_data = [ ...poly_data.features]

		const res4 = await fetch( temp_url );
		temp_data = await res4.json();

		temp_point_data = [...temp_data.features]

		// water temp data from noaa
		const wt_response = await fetch(water_temp_url);
		const wt_data = await wt_response.json();
		waterTemp = wt_data.data[0].v;
		// next high tide from NOAA
		const tides_response = await fetch(tides_today_url);
		const tidesData = await await tides_response.json();
		const tides = tidesData.predictions;
		nextHighTide = getNextHighTide(tides);

	});


	//Filter Function. Filter goes to GeoJSON.svelte
	//Declare Empty filter. All Filters are together
	let filters = emptyFilters;

	// Use these for creating buttons and hover pop up
	// let acts = [
	// 	{
	// 	value: "FISH",
	// 	name: "Fishing",
	// 	source: "/assets/icons/activities/fishing.svg",
	// 	activesource: "/assets/icons/activities/fishing_F77B00.svg",
	// 	desc: "You can fish here."
	// 	},
	// 	{
	// 	value: "SWIM",
	// 	name: "Swimming",
	// 	source: "/assets/icons/activities/swimming.svg",
	// 	activesource: "/assets/icons/activities/swimming_F77B00.svg",
	// 	desc: "You can swim here."
	// 	},
	// 	{
	// 	value: "HPBL",
	// 	name: "Human-powered boating",
	// 	source: "/assets/icons/activities/hp_boating.svg",
	// 	activesource: "/assets/icons/activities/hp_boating_F77B00.svg",
	// 	desc: "You can kayak here."
	// 	},
	// 	{
	// 	value: "MPBL",
	// 	name: "Motor boating",
	// 	source: "/assets/icons/activities/mp_boating.svg",
	// 	activesource: "/assets/icons/activities/mp_boating_F77B00.svg",
	// 	desc: "You can motor boat here."
	// 	},
	// 	{
	// 	value: "CSEE",
	// 	name: "Community engagement",
	// 	source: "/assets/icons/activities/csee.svg",
	// 	activesource: "/assets/icons/activities/csee_F77B00.svg",
	// 	desc: "Sites with community engagement and community science opportunities."
	// 	}
	// ];

    let acts = [
		{
		value: "FISH",
		name: "Fishing",
		  source: "/hudsonaccessproject/assets/icons/activities/fishing.svg",
		  activesource: "/hudsonaccessproject/assets/icons/activities/fishing_F77B00.svg",
		desc: "You can fish here."
		},
		{
		value: "SWIM",
		name: "Swimming",
		  source: "/hudsonaccessproject/assets/icons/activities/swimming.svg",
		  activesource: "/hudsonaccessproject/assets/icons/activities/swimming_F77B00.svg",
		desc: "You can swim here."
		},
		{
		value: "HPBL",
		name: "Human-powered boating",
		  source: "/hudsonaccessproject/assets/icons/activities/hp_boating.svg",
		  activesource: "/hudsonaccessproject/assets/icons/activities/hp_boating_F77B00.svg",
		desc: "You can kayak here."
		},
		{
		value: "MPBL",
		name: "Motor boating",
		  source: "/hudsonaccessproject/assets/icons/activities/mp_boating.svg",
		  activesource: "/hudsonaccessproject/assets/icons/activities/mp_boating_F77B00.svg",
		desc: "You can motor boat here."
		},
		{
		value: "CSEE",
		name: "Community engagement",
		source: "/hudsonaccessproject/assets/icons/activities/csee.svg",
		activesource: "/hudsonaccessproject/assets/icons/activities/csee_F77B00.svg",
		desc: "Sites with community engagement and community science opportunities."
		}
	];

	function getNextHighTide(tides) {
		const currentTime = new Date();
		for (const tide of tides) {
			if (new Date(tide.t) > currentTime && tide.type === 'H') {
				const time = new Date(tide.t);
				const hours24 = time.getHours();
				const hours = time.getHours() % 12 || 12;  // Convert to 12-hour format (12 for midnight)
				const minutes = time.getMinutes().toString().padStart(2, '0');  // Pad minutes with 0
				const amPm = hours24 >= 12 ? 'PM' : 'AM';
				return `${hours}:${minutes} ${amPm}`;
			}
		}
		// If no high tide after current time, return null
		return null;
	}

	// write a function to toggle the isActive property of the act object with value = 'FISH'
	function filterPollution() {
		filters.act_filters = ['SWIM', 'HPBL', 'MPBL', 'CSEE', 'FISH'];
		// I am using the existing featre filters and treating the cso and ms4 columns as features.  If the site va
		filters.feature_filters = ['near_cso'];
	}

	// Handle Site Feature Filters
	function clickHandleSiteFeatures(e){

		if ( filters.feature_filters.includes(e.target.value) ){
			filters.feature_filters = filters.feature_filters.filter( f => f !== e.target.value)
		}else{
			filters.feature_filters = [ ...filters.feature_filters, e.target.value];
		}
	}


	function handlePlaceMessage(e){
		let active_id = String(e.detail.active[0].properties.site_id )
		active_data = all_poly_data.filter( function(f){
			return String(f.properties.site_id) === active_id;
		 })	
		active_point = all_point_data.filter( function(f){
			return String(f.properties.site_id) === active_id;
		 })
	}

	function handleMessage(e){
		let active_id = String(e.detail.active[0].properties.site_id )
		active_data = all_poly_data.filter( function(f){
			return String(f.properties.site_id) === active_id;
		 })	
		 active_point = all_point_data.filter( function(f){
			return String(f.properties.site_id) === active_id;
		 })
	}

	function handleExtent(e){
		active_data = null;
		active_point = null;
	}

	let title_hover = {
		x: null,
		y: null,
		name: null
	};

	function enter(e, name) {
		e.preventDefault();
		title_hover.x = e.clientX;
		title_hover.y = e.clientY;
		title_hover.name = name;
	}

	function leave(e) {
		title_hover.name = null;
	}

	function clickHandleACT(e) {
		const value = e.target.value;

		// If the value is already in filters.act_filters, remove it.
		if (filters.act_filters.includes(value)) {
		filters.act_filters = filters.act_filters.filter(f => f !== value);
		} else {
		// Otherwise, add it to filters.act_filters.
		filters.act_filters = [...filters.act_filters, value];
		}

		// Toggle the isActive property of each act object based on the click
		acts = acts.map(act => {
		if (act.value === value) {
			return { ...act, isActive: !act.isActive };
		}
		return act;
		});
	}

	function modifyIconSource(act) {
		if (act.isActive) {
		return act.activesource;
		} else {
		return act.source;
		}
	}


	//Hide Hover at Start-Up
	// afterUpdate( () => {
	// 	let eco = [...document.getElementsByClassName('hoverup')][0];
	// 	if( eco ) eco.hidden = true;
	// })
	
</script>

<svelte:head>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet-easybutton@2/src/easy-button.css">
	<script src="https://cdn.jsdelivr.net/npm/leaflet-easybutton@2/src/easy-button.js"></script>
	<title>{title}</title>
</svelte:head>


<!-- Render the page -- header, map and the sidebar -->
{#if all_point_data && all_poly_data} 

	<Header />

	<!-- Initiate Map Here-->
	<div class="map-pane">
		<div class="left-panel panel">
			{#if $activePageTracker === 'access'}
					{#key active_point}
						<InfoPanel {active_point} />
					{/key}
			{/if}
			{#if $activePageTracker === 'access' && $arePanelsVisible}
					<div class="activity-filter">
						<div class="act-filters-label">
							<span class="t2 act-filter-header">Activity Filters</span><br>
							<span class="t3 icon-instructions">Select an icon to search by activity</span>
						</div>
						<div class="act-filters">
							{#each acts as act}
							<label
								class="act-buttons"
								class:active="{act.isActive}"
								title="{act.desc}"  
							>
								<img
								alt={act.value}
								src={modifyIconSource(act)}
								/>
								<input
								class="act-input"
								type="checkbox"
								on:click={clickHandleACT}
								value={act.value}
								id={act.value}
								/>
							</label>
							{/each}
						</div>
					</div>
				<div id="amenity">
					<CollapsibleSection isVisible={false} headerText={'Search by site amenity'} >
						<div class="feature-filters r">
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "public_transit"> 
							<label class="t3" for="public_transit"> Accessible by public transit</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "bike_path_accessible">
							<label class="t3" for="bike_path_accessible"> Bike path accessible</label><br>
							<input type="checkbox" class="last" on:click={e=>{clickHandleSiteFeatures(e)}} value = "boat_cleaning_requirements"> 
							<label class="t3" for="boat_cleaning_requirements"> Boat cleaning requirements</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "boat_launch_yn"> 
							<label class="t3" for="boat_launch_yn"> Boat launch</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "drinking_water">
							<label class="t3" for="drinking_water"> Drinkable / running water</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "equipment_rental"> 
							<label class="t3" for="equipment_rental"> Equipment rental</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "food"> 
							<label class="t3" for="food"> Food on site</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "parking">
							<label class="t3" for="parking"> Parking</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "program_yn">
							<label class="t3" for="program_yn"> Programming</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "restrooms">
							<label class="t3" for="restrooms"> Restrooms</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "walking_trails"> 
							<label class="t3" for="walking_trails"> Walking trails</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "wheelchair_access_restrooms"> 
							<label class="t3" for="wheelchair_access_restrooms"> Wheelchair accessible restrooms</label><br>
						</div>
					</CollapsibleSection>
				</div>
			{/if}
			{#if $activePageTracker === 'access' && $arePanelsVisible}
				<div class="searcher">
					<input id="searcher" placeholder="Search by site name" type="text" bind:value={filters.text_filter}>
				</div>
				<div class="places-list">
					{#key filters}
						<PlaceList on:message={handlePlaceMessage} geojson={all_point_data} {filters}/>
					{/key}
				</div>
			{/if}	
			{#if $activePageTracker === 'safety'}
				<WaterSafety />
			{/if}
			{#if $activePageTracker === 'quality'}
				<WaterQuality />
			{/if}	
			{#if $activePageTracker === 'about'}
				<About />
			{/if}	
		</div>
		<div class="map-only-pane">
			<LeafletMap >
				<HomeButton on:homebutton={handleExtent}/>
				{#if waterTemp!==undefined}
				{#if showTooltip}
					<div class="tooltip">
						<span class="caution">CAUTION!</span><br>
						<span class="bold">The water can be much colder than the air!<br>Unexpected immersion in cold water can be dangerous. Be careful in spring and early summer; always wear a flotation 
							device when boating and check temperatures before swimming.
						</span><br>
						<span>Temperature and Tide information  are updated continuously from a <a href="https://tidesandcurrents.noaa.gov/tide_predictions.html?gid=1407#listing" target="_blank">NOAA water monitoring station</a> in 
							lower Manhattan at the Battery. Learn more and access stations in other 
							locations on the Water Safety page. </span>
					</div> 
				{/if}
					<div class="water-temp" on:mouseover="{() => showTooltip = true}" on:focus="{() => showTooltip = true}" on:mouseout="{() => showTooltip = false}" on:blur="{() => showTooltip = false}" on:focus="{() => showTooltip = true}">
						<span>Water Temperature: {waterTemp}°F</span><br>
						<span>Next High Tide: { nextHighTide ? nextHighTide : 'is tomorrow'}</span>
					</div>
				{/if}
				{#if $activePageTracker === 'access' || $activePageTracker === 'quality' || $activePageTracker === 'about'}
					{#key active_data}
					<Polygon active_data={active_data}/>
					{/key}
					{#key filters}
					<GeoPoint geojson={all_point_data}  {filters} on:message={handlePlaceMessage} />
					{/key}
					{#key filters}
					<ActPoint act_geojson={act_point_data}  on:message={handleMessage}  />
					{/key}
				{/if}
				{#if $activePageTracker === 'safety'}
					<SafetyPoint geojson={temp_point_data} />
				{/if}
				{#if $activePageTracker === 'quality'}
					<WaterQualityLegend />
				{/if}
				{#if $activePageTracker === 'safety'}
					<WaterSafetyLegend />
				{/if}
			</LeafletMap>
		</div>
	</div>

	<!-- <Hoverup {acts} /> -->

	<Title {title_hover}/>

	{:else}
	<div>Loading...</div>
{/if}

<style>
	.map-pane {
		position: absolute;
		top: 65px;
		left: 0px;
		z-index: 0;
		width: 100vw;
		height: calc(100dvh - 65px);
		padding: 0px;
		display: flex;
  		/* flex-direction: row; */
	}

	.map-only-pane {
		width: 70vw;
		order: 1;
		position: relative;
		/* position: absolute;
		left: 0px;
		z-index: 0;
		height: 100%;
		padding: 0px; */
	}

	.map-only-pane .water-temp {
		position: absolute;
		bottom: 28px;
		right: 11px;
		z-index: 10001;
		color: #000;
		font-size: 18px;
		border: 1px solid #000;
		background-color: var(--orange3);
		padding: 3px 5px;
		border-radius: 5px;
		cursor: pointer;
	}

	.map-only-pane .tooltip {
		position: absolute;
		bottom: 100px;
		right: 11px;
		/* transform: translateX(-50%); */
		background-color: #fff;
		padding: 10px;
		line-height: 1.4em;
		border-radius: 5px;
		/* font-size: 0.8em; */
		/* display: none; */
		width: 320px;
		border:1px solid #000;
		z-index: 10005;
	}

	.caution {
		color: var(--orange2);
		font-size: 1.2em;
		font-weight: 700;
		/* line-height: 1.4em; */
	}


	.left-panel {
		width: 30vw;
		display: flex;
		flex-direction: column;
		border-left: solid 2px rgb(225, 225, 225);
		box-sizing: border-box;
		height:calc(100dvh - 62px);
		z-index: 10001;
		order: 2;
	} 

	.activity-filter {
		border-bottom: 1.5px solid rgba(225, 225, 225);
		margin-bottom: 0px;
		padding: 15px 15px 10px 15px;
		line-height: 1.2em;
	}

	.act-filters {
		padding-top: 10px;
	}

	/* #amenity {
		display: block;
		overflow: unset;
	} */


	/* Media query for mobile devices */
	@media (max-width: 767px) {

		.map-pane {
			flex-direction: column;
			width: 100vw;
			top: 75px;
			height: calc(100dvh - 75px);
			/* top: 0px;
			height: 100vh; */
			order: unset; 
		}
		.map-only-pane {
			width: 100vw;
			height: -webkit-fill-available;
			order: 2;
			border-top: solid 2px rgb(225, 225, 225);
			/* margin-top: 10px; */
		}

		.map-only-pane .water-temp {
			bottom: 41px;
			font-size: 14px;
		}

		.left-panel {
			width: 100%;
			height: auto;
			order: 1;
			border: none;
			max-height: 50dvh;
			/* max-height: calc(50vh - 75px); */
			/* min-height: 110px; */
			flex-grow: 1;
			/* overflow: hidden; */
			/* padding-bottom: 10px;
			overflow: hidden; */
		}

		.icon-instructions {
			display: none!important;
		}

		/* activity filter display */
		.activity-filter {
			display: flex;
			border-bottom: 1.5px solid rgb(225, 225, 225);
			padding: 0px 11px 0px 11px;
			justify-content: space-between; /* Align children at ends */

		}

		.act-filters-label {
			flex: 0 0 auto; /* Prevent automatic sizing */
    		text-align: left; /* Align text left */
			margin-top: 9px;
		}

		.act-filters {
			border-bottom: none;
			float: right;
			margin-right: 11px;
			padding-top: 6px;
			margin-bottom: 3px;
		}

		#amenity {
			min-height: 35px;
			display: flex;
			flex-direction: column;
			overflow-y: scroll;
			flex-grow: 1.5;
			border-bottom: 1.5px solid var(--gray-light, #e1e1e1);;
		} 

		.places-list {
			max-height: 200px;
		}

	}

	.panel {
		background: white;
		z-index: 1;
		right: 0px;
	}

	/* Hide scrollbar for Chrome, Safari and Opera */
	.left-panel::-webkit-scrollbar {
		display: none;
	}

	/* Hide scrollbar for IE, Edge and Firefox */
	.left-panel {
		-ms-overflow-style: none;  /* IE and Edge */
		scrollbar-width: none;  /* Firefox */
	}

	/* .find {
		min-height: 63px;
		text-align: center;
		display: flex;
		padding-left: 15px;
    	align-items: center;
		border-bottom: solid 1.5px rgb(225, 225, 225);
	} */

	.last {
		margin-bottom: 10px;
	}

	.places-list {
		display: flex;
		flex-direction: column;
		overflow-y: scroll;
		flex-grow: 1;
	} 

	/* Hide scrollbar for Chrome, Safari and Opera */
	.places-list::-webkit-scrollbar {
		display: none;
	}

	/* Hide scrollbar for IE, Edge and Firefox */
	.places-list {
		-ms-overflow-style: none;  /* IE and Edge */
		scrollbar-width: none;  /* Firefox */
	}

	/* Hide scrollbar for Chrome, Safari and Opera */
	#amenity::-webkit-scrollbar {
		display: none;
	}

	/* Hide scrollbar for IE, Edge and Firefox */
	#amenity {
		-ms-overflow-style: none;  /* IE and Edge */
		scrollbar-width: none;  /* Firefox */
	}

</style>