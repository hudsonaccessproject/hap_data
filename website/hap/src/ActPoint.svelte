<script>
    import * as L from 'leaflet';
    import { count, mapDataSiteIds, activePageTracker } from './store.js';
    import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();

    let map;
    count.subscribe(value => {
        map = value;
    });
    let d = 0;

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
        if (zoom >= 13 && zoom <= 18 && $activePageTracker === 'access') {
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
                    iconSize: [6, 6], // Adjust the size as needed
                    iconAnchor: [1, 1], // Anchor point for the icon
                }),
            };
        }
        // return {
        // fillColor: "#ffaa22",
        // color: "ffaa22",
        // opacity: 0,
        // radius: 12,
        // // radius: getRadiusByFilter(feature.properties.remain),
        // weight: 2,
        // fillOpacity: 0
        // }
    }

    function onEachFeature(feature, layer) {

        const actCode = feature.properties.activity;
        const matchingAct = acts.find(act => act.value === actCode);

        if (matchingAct) {
            var popupContent = `
                <span class="Retired-popup-text">
                    ${feature.properties.site_name}
                </span>`;
            layer.bindPopup(popupContent);
            layer.on({
                click: activePoint,
                mouseover: e => { layer.openPopup() },
                mouseout: e => { layer.closePopup() }
            });
        }

        // var popupContent = `
        //     <span class="Retired-popup-text">
        //         ${feature.properties.site_name}
        //     </span>`;
        //     layer.bindPopup(popupContent);
        //     layer.on({
        //         click:activePoint,
        //         mouseover: e => {layer.openPopup()},
        //         mouseout: e => {layer.closePopup()}

        // })
    };

    

     //Zoom to active point and write id to store.
     function activePoint(e) {
        map.flyTo(e.latlng, 15);

        // Get the site ID of the clicked point
        var clickedSiteId = e.target.feature.properties.site_id;

        // Iterate over each layer and update the style if it is in the clciked site
        // layer.eachLayer(function (layer) {
        //     if (layer.feature.properties.site_id === clickedSiteId) {
        //     layer.setStyle({ fillOpacity: 0.7 }); // Change the opacity for matching points
        //     } else {
        //     layer.setStyle({ fillOpacity: 0 }); // Change the opacity for non-matching points
        //     }
        // });

        // Filter the active point based on site ID
        var clickedPoint = act_geojson.filter(function (d) {
            return d.properties.site_id == clickedSiteId;
        });

        dispatch('message', {
            active: clickedPoint
        });
    }


    // const layer = L.geoJSON(act_geojson,{
    //     pointToLayer: createCircles,
    //     onEachFeature: onEachFeature,
    //     style:style,
    //     minZoom: 13,
    //     maxZoom: 18
    // }).addTo(map);


</script>