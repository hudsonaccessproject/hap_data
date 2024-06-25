<script>
    import * as L from 'leaflet';
    import { count, mapDataSiteIds, activePageTracker, arePanelsVisible } from './store.js';
    import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();

    let map;
    count.subscribe(value => {
        map = value;
    });
    let d = 0;

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

    export let act_geojson;
    // export let activePage;

    let mapDataSiteIdsValue = [];

    mapDataSiteIds.subscribe(value => {
        mapDataSiteIdsValue = value;
    });

    let layer; // Declare the layer variable

    // Create the layer using L.geoJSON
    layer = L.geoJSON(act_geojson, {
        pointToLayer: createCircles,
        onEachFeature: onEachFeature,
        // style: style,
    }).addTo(map);

    // Define the setLayerVisibility function
    function setLayerVisibility(zoom) {
        if (zoom >= 14 && zoom <= 18 && ($activePageTracker === 'access' || $activePageTracker === 'quality' || $activePageTracker === 'about')) {
        // if (zoom >= 13 && zoom <= 18 && activePage === 'access') {
            map.addLayer(layer);
        } else {
            map.removeLayer(layer);
        }
    }

    // Define the applyLayerVisibility function
    function applyLayerVisibility() {
        const currentZoom = map.getZoom();
        setLayerVisibility(currentZoom);
    }

    // Call the applyLayerVisibility function immediately after the layer is created
    applyLayerVisibility();

    // Attach zoom event listener
    map.on('zoomend', () => {
        applyLayerVisibility();
    });

    // Updated createCircles function to use mapDataSiteIdsValue
    function createCircles(feature, latlng) {
        const actCode = feature.properties.activity;
        const matchingAct = acts.find(act => act.value === actCode);

        if (matchingAct) {
            // Check if the feature's site_id is in mapDataSiteIdsValue
            const isInMapData = mapDataSiteIdsValue.includes(feature.properties.site_id);

            return L.marker(latlng, {
                icon: L.icon({
                    iconUrl: isInMapData ? matchingAct.activesource : matchingAct.source,
                    iconSize: [18, 18], // Adjust the size as needed
                    iconAnchor: [3, 3], // Anchor point for the icon
                })
            });
        }
    }



    function style(feature) {

        if (matchingAct) {
            return {
                icon: L.icon({
                    iconUrl: matchingAct.source,
                    iconSize: [5, 5], // Adjust the size as needed
                    iconAnchor: [1, 1], // Anchor point for the icon
                }),
            };
        }
    }

    function onEachFeature(feature, layer) {

        const actCode = feature.properties.activity;
        const matchingAct = acts.find(act => act.value === actCode);

        if (matchingAct) {
            var popupContent = `
                <span class="popup-content">
                    ${feature.properties.activity_site_name}
                </span>`;
            layer.bindPopup(popupContent);
            layer.on({
                click: activePoint,
                mouseover: e => { layer.openPopup() },
                mouseout: e => { layer.closePopup() }
            });
        }
    };

    

     //Zoom to active point and write id to store.
     function activePoint(e) {
        map.flyTo(e.latlng, 15);

        // Get the site ID of the clicked point
        var clickedSiteId = e.target.feature.properties.site_id;
        console.log(clickedSiteId);
        arePanelsVisible.set(false);


        // Filter the active point based on site ID
        var clickedPoint = act_geojson.filter(function (d) {
            return d.properties.site_id == clickedSiteId;
        });

        console.log(clickedPoint);

        dispatch('message', {
            active: clickedPoint
        });
    }


</script>