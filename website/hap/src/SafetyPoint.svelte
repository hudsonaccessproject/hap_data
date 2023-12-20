<script>
    import { count, activePageTracker } from "./store.js";


    export let geojson;
    let map

    count.subscribe(value => {
        map = value;
    });

    let layer; // Declare the layer variable

    // Create the layer using L.geoJSON
    layer = L.geoJSON(geojson, {
        pointToLayer: createCircles,
        onEachFeature: onEachFeature,
        style: style,
    }).addTo(map);

    function createCircles (feature, latlng) {
        return L.circleMarker(latlng)
    }

    function onEachFeature(feature, layer) {
        var popupContent = `
            <div class="popup-content">
                <span class="popup-header">
                    ${feature.properties.station_name}
                </span>
                <span >
                    ${feature.properties.station_type}
                </span>
                ${feature.properties.tide_url !== null ? `<span>View <a href=${feature.properties.tide_url} target="_blank">NOAA tide prediction data</a></span>` : ''}
                ${feature.properties.current_url !== null ? `<span>View <a href=${feature.properties.current_url} target="_blank">NOAA current prediction data</a></span>` : ''}
                ${feature.properties.temp_url !== null ? `<span>View <a href=${feature.properties.temp_url} target="_blank">NOAA tide and temperature data</a></span>` : ''}
            </div>
        `;
        layer.bindPopup(popupContent);

        let clicked = false; // Add a flag to track whether the popup was opened by a click

        layer.on({
            mouseover: e => {
                layer.openPopup();
                clicked = false; // Set clicked to false when the popup is opened by a mouseover
            },
            mouseout: e => {
                if (!clicked) { // Only close the popup on mouseout if it wasn't opened by a click
                    layer.closePopup();
                }
            },
            click: e => {
                layer.openPopup();
                clicked = true; // Set clicked to true when the popup is opened by a click
            }
        })
    };

     // color based on station type
     function getColorByType(d) {
        return d == "Current Prediction Station" ? '#fcee57' :
                d == "Tide Prediction Station" ? '#fca057' :
                d == "Tide & Current Prediction Station" ? '#fcee57' :
                d == "Temperature Station" ? '#1a66ff' :
                        '#1a66ff'
    }

    function style(feature) {
        return {
        fillColor: getColorByType(feature.properties.station_type),
        color:'#000000',
        opacity: 1,
        radius: 3,
        weight: .25,
        fillOpacity: 1
        }
    }

</script>