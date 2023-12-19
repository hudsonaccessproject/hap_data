<script>
// create dispatch to send data from for to parent (App.svelte)
import { createEventDispatcher } from 'svelte';

// creates a function that we store in dispatch
let dispatch = createEventDispatcher();

// // let activities = [];

// const filterMap {
//     dispatch('toggleLayer', FISH);
// }

</script>

<div class="filterPane">
    <!-- <input type="checkbox" value="FISH" checked=true on:change={filterMap}> fishing<br> -->
    <!-- <input type="checkbox" bind:group={activities} value="FISH" checked=true> fishing<br>
    <input type="checkbox" bind:group={activities} value="HIKE"> hiking<br>
    <input type="checkbox" bind:group={activities} value="HPBL"> human-powered boating<br>
    <input type="checkbox" bind:group={activities} value="MPBL"> motor boating<br>
    <input type="checkbox" bind:group={activities} value="STEN"> sten<br>
    <input type="checkbox" bind:group={activities} value="SWIM"> swimming<br> -->
</div>
<div class="site-filters r">	
    <button type="button" class="site-buttons" id="Working" on:click={e=>{clickHandleSite(e)}} value="Working"> 
        <div><span class="t2 site-text Fishing">Fishing</span></div>  </button>
</div>

<style>
    
</style>
