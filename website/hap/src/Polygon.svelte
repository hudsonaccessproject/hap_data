<script>
    import * as L from 'leaflet';
    import { count } from "./store.js";

    let map;
    count.subscribe(value => {
        map = value;
    });

    export let active_data;

    // this is a hack to remove previous polygon
    map.eachLayer(layer => {
        if (layer instanceof L.Layer && layer.feature && layer.feature.geometry && (layer.feature.geometry.type === 'MultiPolygon' || layer.feature.geometry.type === 'Polygon')) {
            map.removeLayer(layer);
        }
    });

    export let polygonLayer = L.geoJson(active_data, {
    style: function (feature) {
        return {
        color: '#F77B00',
        weight: 2,
        opacity: 1,
        fillOpacity: 0,
        fillColor: '#ffffff'
        };
    }
    });
    
    polygonLayer.addTo(map);

</script>