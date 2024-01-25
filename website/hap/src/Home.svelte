<script>
    import { count } from "./store.js";
    import L from "leaflet";

    import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();

    let map;
    count.subscribe(value => {
        map = value;
    });

    let home = L.easyButton( '<i class="fa fa-expand" aria-hidden="true"></i>' , function(btn, map){
        // map.fitBounds([
        //     [40.000, -74.8006],
        //     [41.5876, -72.881]
        // ]);
         // this is a hack to remove previous polygon
        map.eachLayer(layer => {
            if (layer instanceof L.Layer && layer.feature && layer.feature.geometry && layer.feature.geometry.type === 'MultiPolygon') {
                map.removeLayer(layer);
            }
        });
        map.flyTo([40.73, -74.05], 10);
    },'Reset map');
    
    home.button.onclick = function(){
        dispatch('homebutton', {
			text: 'Hello!'
		});
    }
    
    home.addTo(map);

</script>


