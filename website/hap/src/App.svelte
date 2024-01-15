<script>

	import LeafletMap from './Map.svelte'
	import GeoPoint from './GeoPoint.svelte';
	import Polygon from './Polygon.svelte';
	import ActPoint from './ActPoint.svelte';
	import SafetyPoint from './SafetyPoint.svelte';
	import {onMount, afterUpdate} from 'svelte'
	import Header from './components/Header.svelte';	
	import Hoverup from './Hoverup.svelte';
	import Title from './Title.svelte';
	// import {afterUpdate} from 'svelte';
	import PlaceList from './PlaceList.svelte';
	// import { geoJSON } from 'leaflet';
	import CollapsibleSection from './CollapsibleSection.svelte'
	import InfoPanel from './InfoPanel.svelte';
	import WaterSafety from './WaterSafety.svelte';
	import WaterQuality from './WaterQuality.svelte';
	import About from './About.svelte';
	import HomeButton from './Home.svelte'
	import WaterQualityLegend from './WaterQualityLegend.svelte';
	import WaterSafetyLegend from './WaterSafetyLegend.svelte';
	import { count, activePageTracker} from "./store.js";

	let point_data;
	let act_data;
	let poly_data;
	let temp_data;
	let all_poly_data;
	let all_point_data;
	let act_point_data;
	let temp_point_data;
	let active_data;
	let active_point;

	// const point_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_site_points_20231204.geojson";
	// const act_point_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_act_points_20230921.geojson";
	// const polygon_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_site_polys_20230921.geojson";
	const point_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_site_points_20240115.geojson";
	const act_point_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_act_points_20240115.geojson";
	const polygon_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_site_polys_20240115.geojson";
	const temp_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/hap_noaa_stations.geojson";
	// const point_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/staging/hap_site_points_20240115.geojson";
	// const act_point_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/staging/hap_activity_points_20240115.geojson";
	// const polygon_url = "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/data/staging/hap_site_polys_20240114.geojson";


	let safetyTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/clpvm5jgq00yi01qmb4p5ffbj/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
    let qualityTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/clhyzicsw009n01pjc6t5adeb/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
	// //let aboutTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/cli2a1j4w04qg01qn1cfaaqta/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
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
		case 'access':
			// changeBasemap($activeTileURL);
			// console.log("access case");
			break;
		case 'safety':
			removePoints();
			removePolygons();
			changeBasemap(safetyTileURL);
			break;
		case 'quality':
			removePoints();
			removePolygons
			changeBasemap(qualityTileURL);
			break;
		case 'about':
			removePoints();
			removePolygons();
			changeBasemap(regTileURL);
			break;
		default:
			// console.log("default");
			//changeBasemap(regTileURL);
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

	});


	//Filter Function. Filter goes to GeoJSON.svelte
	//Declare Empty filter. All Filters are together
	let filters = {
		act_filters:[],
		feature_filters:[],
		prog_filters:[],
		text_filter:"",
		active:[],
		previous:[]
	};

	//Use these for creating buttons and hover pop up
	let acts = [
    {
      value: "FISH",
      name: "Fishing",
      source: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/fishing.svg",
      activesource: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/fishing_F77B00.svg",
      desc: "You can fish here."
    },
    {
      value: "SWIM",
      name: "Swimming",
      source: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/swimming.svg",
      activesource: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/swimming_F77B00.svg",
      desc: "You can swim here."
    },
    {
      value: "HPBL",
      name: "Human-powered boating",
      source: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/hp_boating.svg",
      activesource: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/hp_boating_F77B00.svg",
      desc: "You can kayak here."
    },
    {
      value: "MPBL",
      name: "Motor boating",
      source: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/mp_boating.svg",
      activesource: "https://raw.githubusercontent.com/hudsonaccessproject/hap_data/main/icons/activities/mp_boating_F77B00.svg",
      desc: "You can motor boat here."
    }
  ];

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
</svelte:head>


<!-- Render the page -- header, map and the sidebar -->
{#if all_point_data && all_poly_data} 

	<!-- <Header  {activePage} {changePage}/> -->
	<Header />

	{#if $activePageTracker === 'about'}
		<About />
	{/if}

	{#if $activePageTracker === 'quality'}
		<WaterQualityLegend />
	{/if}
	{#if $activePageTracker === 'safety'}
		<WaterSafetyLegend />
	{/if}

	<!-- Initiate Map Here-->
	<div class="map-pane">
		<LeafletMap >
			<HomeButton on:homebutton={handleExtent}/>
			{#if $activePageTracker === 'access'}
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
		</LeafletMap>
	</div>

	<div class="left-panel panel">
		<div class="find">
			{#if $activePageTracker === 'access'}
			<span class="t1 side-title">Find a place to access the water</span>
			{/if}
			{#if $activePageTracker === 'safety'}
			<span class="t1 side-title">How to stay safe on the water</span>
			{/if}
			{#if $activePageTracker === 'quality'}
			<span class="t1 side-title">Learn about water quality</span>
			{/if}
			{#if $activePageTracker === 'about'}
			<span class="t1 side-title">About the Hudson Access Project</span>
			{/if}
		</div>
		<!-- {#if $activePageTracker === 'access'} -->
		{#if $activePageTracker === 'access'}
			<div>
				<div class="activity-filter">
					<div class="r">
						<!-- <span class="t2" id="target-eco" on:click={(e) => showHover(e)}>Target Ecosystem Characteristics</span><br> -->
						<span class="t2 act-filter-header">Activity Filters</span><br>
						<span class="t3 icon-instructions">Select an icon to search by activity</span>
					</div>
					<!-- ACT BUTTONS-->
					<div class="act-filters r">
						{#each acts as act}
						<label
							class="act-buttons"
							class:active="{act.isActive}"
						>
							<img
							alt={act.value}
							style="width:40px"
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
		{#if $activePageTracker === 'safety'}
			<WaterSafety />
		{/if}
		{#if $activePageTracker === 'quality'}
			<WaterQuality />
		{/if}
		<!-- PROGRAMMING INPUT-->
		<!-- <CollapsibleSection headerText={'Look for sites with programming by type'} >
			<div class="prog-filters r">
				<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "boat_launch"> 
				<label class="t3" for="boat_launch">Instruction or classes</label><br>
				<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "restrooms">
				<label class="t3" for="restrooms">Guided trips or tours</label><br>
				<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "boat_launch"> 
				<label class="t3" for="boat_launch">Environmental education opportunities</label><br>
				<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "restrooms">
				<label class="t3" for="restrooms">Equipment rentals</label><br>
				<input type="checkbox" on:click={e=>{clickHandleSiteFeatures(e)}} value = "boat_launch"> 
				<label class="t3" for="boat_launch">Equipment for free use</label>
			</div>
		</CollapsibleSection> -->
		<!-- Search Input Box-->
		<!-- {#if $activePageTracker === 'access'} -->
		{#if $activePageTracker === 'access'}
			<div class="places-list">
				<div class="searcher r">
					<input id="searcher" placeholder="Search for a site by name" type="text" bind:value={filters.text_filter}>
				</div>
				<!-- <CollapsibleSection > -->
					<div class = "info-panel panel">
						{#key active_point}
							<InfoPanel {active_point} />
						{/key}
					</div>
				<!-- </CollapsibleSection> -->
				<!-- Accordion List -->
				{#key filters}
					<PlaceList on:message={handlePlaceMessage} geojson={all_point_data} {filters}/>
				{/key}
			</div>
		{/if}

	

		
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
		width: 70vw;
		height: calc(100% - 75px);
		padding: 0px;
	}

	.panel {
		background: white;
		/* top: 5px; */
		z-index: 1;
		right: 0px;
	}

	.left-panel {
		position: absolute;
		display: flex;
		flex-direction: column;
		border-left: solid 2px rgb(225, 225, 225);
		width: 30vw;
		box-sizing: border-box;
		height:100vh;
		overflow: scroll;
	} 

	/* Media query for very wide */
	/* @media (min-width: 1550px) {
		.map-pane {
			width: 60vw;
		}
		.left-panel {
			width: 40vw;
		}
	} */

	/* Hide scrollbar for Chrome, Safari and Opera */
	.left-panel::-webkit-scrollbar {
		display: none;
	}

	/* Hide scrollbar for IE, Edge and Firefox */
	.left-panel {
		-ms-overflow-style: none;  /* IE and Edge */
		scrollbar-width: none;  /* Firefox */
	}



	/* #amenity {
		padding-bottom: 10px;
	} */

	/* Media query for mobile devices */
	@media (max-width: 767px) {

		.left-panel {
			position: relative;
			top: 45px;
			display: flex;
			flex-direction: column;
			border-bottom: solid 2px rgb(225, 225, 225);
			border-left: none;
			width: 100%;
			/* min-height: 23%; */
			height: auto;
		}

		.map-pane {
			width: 100vw;
			top: 25%;
			height: 75%;
		}

		.leaflet-top.leaflet-left {
			bottom: 0px!important;
			left: 0px!important;
		}

		/* .water-quality-iframe {
			width: 100vw!important;
			top: 50%!important;
			height: 50%!important;
		} */

		.find {
			display: none!important;
		}

		.icon-instructions {
			display: none!important;
		}

		/* activity filter display */
		.activity-filter {
			display: flex;
			border-bottom: 1.5px solid rgb(225, 225, 225);
			padding: 15px;
		}

		/* .r {
			margin-top: 0px;
			margin-bottom: 0px;
			padding-bottom: 0px;
			padding-left: 13px;
		} */
		.act-filters {
			border-bottom: none;
			/* padding-top: 10px; */
		}

		/* .places-list .active-search {
			height: 80px;
		}

		.places-list {
			height: 40px;
		} */

	}

	.find {
		min-height: 63px;
		text-align: center;
		display: flex;
		padding-left: 15px;
    	align-items: center;
		border-bottom: solid 1.5px rgb(225, 225, 225);
	}

	.last {
		margin-bottom: 10px;
	}

	/* .water-quality-iframe {
		position: absolute;
		top: 65px;
		left: 0px;
		width: 70vw;
		height: calc(100% - 65px);
		z-index: 10001;
		overflow: hidden; 
	}

	.frame {
		background-color: white;
		position: relative;
		width: 100%;
		height: 100%;
	} */

	.side-title {
		color: var(--orange2);
		font-size: 22px;
		font-weight: 700;
	}
	@media (max-width: 1200px) {
		.side-title{
		font-size: 20px;
		}
	}

	@media (max-width: 1000px) {
		.side-title{
			font-size: 18px;
		}
		.t2 {
			font-size: 18px;
		}
		.t3 {
			font-size: 14px;
		}
	}

	@media (max-width: 900px) {
		.side-title{
		font-size: 15px;
		}
	}
</style>