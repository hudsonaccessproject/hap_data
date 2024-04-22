<script>

	import LeafletMap from './Map.svelte'
	import GeoPoint from './GeoPoint.svelte';
	import Polygon from './Polygon.svelte';
	import ActPoint from './ActPoint.svelte';
	import SafetyPoint from './SafetyPoint.svelte';
	import {onMount, afterUpdate} from 'svelte'
	import Header from './components/Header2.svelte';	
	import Hoverup from './Hoverup.svelte';
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
	import { count, activePageTracker} from "./store.js";

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

	const emptyFilters = {
		act_filters: [],
		feature_filters: [],
		prog_filters: [],
		text_filter: "",
		pollution_filters: [],
		active: [],
		previous: []
	};

	// const point_url = "/hudsonaccessproject/assets/hap_site_points_20240320.geojson";
	// const act_point_url = "/hudsonaccessproject/assets/hap_act_points_20240320.geojson";
	// const polygon_url = "/hudsonaccessproject/assets/hap_site_polys_20240201.geojson";
	const point_url = "/assets/hap_site_points_20240422.geojson"; 
	const act_point_url = "/assets/hap_act_points_20240320.geojson";
	const polygon_url = "/assets/hap_site_polys_20240201.geojson";
	const temp_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_noaa_stations.geojson";
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
	let filters = emptyFilters
	// let filters = {
	// 	act_filters:[],
	// 	feature_filters:[],
	// 	prog_filters:[],
	// 	text_filter:"",
	// 	pollution_filters:[],
	// 	active:[],
	// 	previous:[]
	// };

	//Use these for creating buttons and hover pop up
	let acts = [
		{
		value: "FISH",
		name: "Fishing",
		source: "/assets/icons/activities/fishing.svg",
		activesource: "/assets/icons/activities/fishing_F77B00.svg",
		desc: "You can fish here."
		},
		{
		value: "SWIM",
		name: "Swimming",
		source: "/assets/icons/activities/swimming.svg",
		activesource: "/assets/icons/activities/swimming_F77B00.svg",
		desc: "You can swim here."
		},
		{
		value: "HPBL",
		name: "Human-powered boating",
		source: "/assets/icons/activities/hp_boating.svg",
		activesource: "/assets/icons/activities/hp_boating_F77B00.svg",
		desc: "You can kayak here."
		},
		{
		value: "MPBL",
		name: "Motor boating",
		source: "/assets/icons/activities/mp_boating.svg",
		activesource: "/assets/icons/activities/mp_boating_F77B00.svg",
		desc: "You can motor boat here."
		}
	];

    // let acts = [
	// 	{
	// 	value: "FISH",
	// 	name: "Fishing",
	// 	  source: "/hudsonaccessproject/assets/icons/activities/fishing.svg",
	// 	  activesource: "/hudsonaccessproject/assets/icons/activities/fishing_F77B00.svg",
	// 	desc: "You can fish here."
	// 	},
	// 	{
	// 	value: "SWIM",
	// 	name: "Swimming",
	// 	  source: "/hudsonaccessproject/assets/icons/activities/swimming.svg",
	// 	  activesource: "/hudsonaccessproject/assets/icons/activities/swimming_F77B00.svg",
	// 	desc: "You can swim here."
	// 	},
	// 	{
	// 	value: "HPBL",
	// 	name: "Human-powered boating",
	// 	  source: "/hudsonaccessproject/assets/icons/activities/hp_boating.svg",
	// 	  activesource: "/hudsonaccessproject/assets/icons/activities/hp_boating_F77B00.svg",
	// 	desc: "You can kayak here."
	// 	},
	// 	{
	// 	value: "MPBL",
	// 	name: "Motor boating",
	// 	  source: "/hudsonaccessproject/assets/icons/activities/mp_boating.svg",
	// 	  activesource: "/hudsonaccessproject/assets/icons/activities/mp_boating_F77B00.svg",
	// 	desc: "You can motor boat here."
	// 	}
	// ];

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
		filters.act_filters = ['SWIM', 'HPBL'];
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
		 console.log(active_point);
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
	afterUpdate( () => {
		let eco = [...document.getElementsByClassName('hoverup')][0];
		if( eco ) eco.hidden = true;
	})
	
</script>

<svelte:head>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet-easybutton@2/src/easy-button.css">
	<script src="https://cdn.jsdelivr.net/npm/leaflet-easybutton@2/src/easy-button.js"></script>
	<title>{title}</title>
</svelte:head>


<!-- Render the page -- header, map and the sidebar -->
{#if all_point_data && all_poly_data} 

	<!-- <Header  {activePage} {changePage}/> -->
	<Header />

	<!-- {#if $activePageTracker === 'about'}
		<About />
	{/if} -->

	<!-- Initiate Map Here-->
	<div class="map-pane">
		<div class="left-panel panel">
			{#if $activePageTracker === 'access'}
				<div>
					<div class="activity-filter">
						<div class="act-filters-label">
							<span class="t2 act-filter-header">Activity Filters</span><br>
							<span class="t3 icon-instructions">Select an icon to search by activity</span>
						</div>
						<!-- ACT BUTTONS-->
						<div class="act-filters">
							{#each acts as act}
							<label
								class="act-buttons"
								class:active="{act.isActive}"
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
				</div>
				<div id="amenity">
					<CollapsibleSection isVisible={false} headerText={'Search by site amenity'} >
						<div class="feature-filters r">
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "boat_launch_YN"> 
							<label class="t3" for="boat_launch_YN"> Boat launch</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "restrooms">
							<label class="t3" for="restrooms"> Restrooms</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "public_transit"> 
							<label class="t3" for="public_transit"> Accessible by public transit</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "parking">
							<label class="t3" for="parking"> Parking</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "food"> 
							<label class="t3" for="food"> Food on site</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "drinking_water">
							<label class="t3" for="drinking_water"> Drinkable / running water</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "picnic_area"> 
							<label class="t3" for="picnic_area"> Picnic Area</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "hiking">
							<label class="t3" for="hiking"> Walking / hiking trails</label><br>
							<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "pets_allowed"> 
							<label class="t3" for="pets_allowed"> Dogs / pets allowed</label><br>
							<input type="checkbox" class="last" on:click={e=>{clickHandleSiteFeatures(e)}} value = "program"> 
							<label class="t3" for="program"> Programming</label><br>
						</div>
					</CollapsibleSection>
				</div>
			{/if}
			{#if $activePageTracker === 'access'}
				<div class="searcher r">
					<input id="searcher" placeholder="Search for a site by name" type="text" bind:value={filters.text_filter}>
				</div>
				<!-- <div class = "info-panel panel">
					{#key active_point}
						<InfoPanel {active_point} />
					{/key}
				</div> -->
				<div class="places-list">
					<div class = "info-panel panel">
						{#key active_point}
							<InfoPanel {active_point} />
						{/key}
					</div>
					<!-- Accordion List -->
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
					<div class="water-temp">
					<!-- <div class="water-temp" on:mouseover="{() => showTooltip = true}" on:focus="{() => showTooltip = true}" on:mouseout="{() => showTooltip = false}" on:blur="{() => showTooltip = false}"> -->
						<span>Water Temperature: {waterTemp}°F</span><br>
						<span>Next High Tide: { nextHighTide ? nextHighTide : 'is tomorrow'}</span>
						<!-- {#if showTooltip} -->
							<!-- <div class="tooltip">
								<span class="caution">CAUTION!</span><br>
								<span>The water can be much colder than the air!</span><br><br>
								<span>Temperature and Tide information are updated continuously and are from the Battery in lower Manhattan.</span>
							</div> -->
						<!-- {/if} -->
					</div>
				{/if}
				<!-- data on the map -->
				{#if $activePageTracker === 'access' || $activePageTracker === 'quality' || $activePageTracker === 'about'}
					{#key active_data}
					<Polygon active_data={active_data}/>
					{/key}
					{#key filters}
					<GeoPoint geojson={all_point_data}  {filters} on:message={handleMessage} />
					{/key}
					{#key filters}
					<ActPoint act_geojson={act_point_data}  on:message={handleMessage}  />
					{/key}
				{/if}
				{#if $activePageTracker === 'safety'}
					<SafetyPoint geojson={temp_point_data} />
				{/if}
				<!-- Legends -->
				{#if $activePageTracker === 'quality'}
					<WaterQualityLegend />
				{/if}
				{#if $activePageTracker === 'safety'}
					<WaterSafetyLegend />
				{/if}
			</LeafletMap>
		</div>
	</div>

	<Hoverup {acts} />

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
		height: calc(100% - 75px);
		padding: 0px;
		display: flex;
  		flex-direction: row;
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

	/* .tooltip {
		position: absolute;
		bottom: 95%;
		left: 50%;
		transform: translateX(-50%);
		background-color: #fff;
		padding: 5px;
		border-radius: 3px;
		font-size: 0.8em;
		display: none;
		width: 260px;
		border:1px solid #000;
	}

	/* .caution {
		color: var(--orange3);
	}	 */ 


	.left-panel {
		width: 30vw;
		display: flex;
		flex-direction: column;
		border-left: solid 2px rgb(225, 225, 225);
		box-sizing: border-box;
		height:calc(100vh - 62px);
		/* overflow: scroll; */
		z-index: 10001;
		order: 2;
		/* overflow: hidden; */
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


	/* Media query for mobile devices */
	@media (max-width: 767px) {

		.map-pane {
			flex-direction: column;
			width: 100vw;
			top: 75px;
			order: unset; 
		}
		.map-only-pane {
			width: 100vw;
			height: -webkit-fill-available;
			order: 2;
			border-top: solid 2px rgb(225, 225, 225);
			margin-top: 10px;
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
			max-height: 60%;
			flex-grow: 1;
			padding-bottom: 10px;
			overflow: hidden;
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
    		width: 100%; /* Ensure full width */
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
		overflow-y: scroll;
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

</style>