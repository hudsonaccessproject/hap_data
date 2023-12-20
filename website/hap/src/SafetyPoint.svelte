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
        <span class="Retired-popup-text">
            ${feature.properties.name}
        </span>
        <p>Click to open <a href=${feature.properties.station_URL} target="_blank">station url</a></p>
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

    function style(feature) {
        return {
        fillColor: '#1a66ff',
        color:'#000000',
        opacity: 1,
        radius: 3,
        weight: .25,
        fillOpacity: 1
        }
    }

</script>