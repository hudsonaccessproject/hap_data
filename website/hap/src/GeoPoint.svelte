<script>
    import * as L from 'leaflet';
    import { count, mapDataSiteIds, activePageTracker, arePanelsVisible } from "./store.js";

    import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();
   

    export let geojson;
    export let filters;
    // export let activePage;

    //countValue is map object stored in the store.js
    let map;
    count.subscribe(value => {
        map = value;
    });

    $: {
        mapDataSiteIds.set(map_data
            .filter(feature => feature.properties.remain === "active")
            .map(feature => feature.properties.site_id)
        );
    }


    function setLayerVisibility(zoom) {
        if (zoom <= 13 && ($activePageTracker === 'access' || $activePageTracker === 'about'  || $activePageTracker === 'quality')) {
        // if (zoom <= 12 && activePage === 'access') {
            // Show the layer when zoom is within the specified range
            map.addLayer(layer); // Add the layer to the map
        } else {
            // Hide the layer when zoom is outside the specified range
            map.removeLayer(layer); // Remove the layer from the map
        }
    }

    map.on('zoomend', () => {
        const currentZoom = map.getZoom();
        setLayerVisibility(currentZoom);
    });

    function onEachFeature(feature, layer) {

        // Custom HTML for clickable area
        // const customHtml = `
        // <div class="custom-marker" style="width: 50px; height: 50px; cursor: pointer;">
        //     <span class="marker-content">${feature.properties.site_name}</span>
        // </div>`;
        
        var popupContent = `
        <span class="popup-content">
            ${feature.properties.site_name}
        </span>`;
        layer.bindPopup(popupContent);
        layer.on({
            // html: customHtml,
            click:activePoint,
            mouseover: e => {layer.openPopup()},
            mouseout: e => {layer.closePopup()}

        })
    };

    export function dataFilter(feature) {
        // Booleans that tracks whether or not the feature should be displayed based on activity filters and feature filters
        let act_remain;
        let feature_remain;
        let text_remain = true;

          //POLLUTION Filters - this is how we show the sites near ms4 or cso on water quality page

        // // Show the feature gray if there are no filters
        // const allPollutionFilters = filters.pollution_filters.every(pollution_filters => feature.properties[pollution_filters] === "1");
        // if (allPollutionFilters) {
        //     feature.properties.remain = "active";
        // } else {
        //     feature.properties.remain = "inactive";
        // }

        //ACTIVITY FEATURE Filters
        if (filters.act_filters.length === 0){
            // Show the feature gray if there are no filters
            feature.properties.act_remain = "active";
            act_remain=false;
        }else{
            // Only show the feature if the feature's activity code is included in one
            // of the existing activity filters
            let actCodes = feature.properties.activity_codes.split(',').map(code => code.trim());

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

        // Add programming filter HERE
        if ( filters.text_filter.length > 0) {
            // if (feature.properties.site_name.toUpperCase().includes( filters.text_filter.toUpperCase() ) ){
            /// checks for site name and program name
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
        /// for the water quality page, we want to hide the SWIM and HPBL sites that are near ms4 or cso
        let actCodes = feature.properties.activity_codes.split(',').map(code => code.trim());
        const noSwimHPBL = !filters.act_filters.some(el => actCodes.includes(el));
        if ($activePageTracker === 'quality' && noSwimHPBL) {
            feature.properties.remain = "hidden";
        }else {
                feature.properties.remain = feature.properties.remain;
            }
        return(feature)

    }


    //Create new filtered data -> Dispatch this to place-holder
    export let map_data = geojson.filter( dataFilter );

    //Zoom to active point and write id to store.
    function activePoint(e){
        map.flyTo(e.latlng, 15)
        arePanelsVisible.set(false);
        let clicked_point = geojson.filter( function(d){
            return d.properties.site_id == e.target.feature.properties.site_id
        }) 
        dispatch('message', {
            active: clicked_point
        }); 
    }

    // create a vector circle centered on each point feature's latitude and longitude
    function createCircles (feature, latlng) {
        return L.circleMarker(latlng)
    }

    // color based on filters
    function getColorByFilter(d) {
        return d == "active" ? '#F77B00' :
                d == "inactive" ? '#5D5D5D' :
                    d == "hidden" ? 'transparent' :
                        '#b2b2b2'
    }


    function style(feature) {
        return {
        fillColor: getColorByFilter(feature.properties.remain),
        // color:getColorByFilter(feature.properties.remain),
        color: 'transparent',
        // color: 'red',
        opacity: 1,
        radius: 3,
        weight: 2,
        fillOpacity: 1
        }
    }

    const layer = L.geoJSON(map_data,{
        pointToLayer: createCircles,
        onEachFeature: onEachFeature,
        style:style
    }).addTo(map);

 </script>
