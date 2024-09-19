<script>
  import L from "leaflet";
  import { setContext, onMount } from "svelte";
  import { count } from "./store.js";

  let isMobile;
  let isWide;
  // let center;
  // let zoom;
  function checkScreenWidth() {
		isMobile = window.innerWidth <= 767; // Adjust the breakpoint as needed
    isWide = window.innerWidth > 1550; // Adjust the breakpoint as needed
    // console.log(window.innerWidth);
	}

  var southWest = L.latLng(40.000, -74.8006),
    northEast = L.latLng(41.6007, -73.207),
    // northEast = L.latLng(41.5876, -72.881),
    bounds = L.latLngBounds(southWest, northEast);

    let center = isMobile ? [40.93, -73.97] : [40.73, -74.05]; // Set center based on isMobile value
    let zoom = isWide ? 10 : 9; // Set zoom based on isMobile value
    // console.log(center);
    // console.log(isWide);
    // console.log(isMobile);

  
  let mapContainer;
  let map = L.map(L.DomUtil.create("div"), {
    center: [40.73, -74.05],
    zoom: 10,
    // zoom: zoom,
    maxBounds: bounds,
    minZoom: 9,
    // zoomDelta: 0.5,
  });

  // add scale bar with km and miles
  // L.control.scale().addTo(map);
  count.set(map)

  setContext("leafletMapInstance", map);

  //let tileURL = 'https://api.mapbox.com/styles/v1/prattsavi/cll2iboa4011k01qgdar6c044/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
  let tileURL = 'https://api.mapbox.com/styles/v1/hudsonaccess/cm0s2a1w602ip01qv1kwt2nmo/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaHVkc29uYWNjZXNzIiwiYSI6ImNsbDJqbnJ5ZjIyYWgzZHBrNTFwNmp5eHgifQ.WmHbnTbEIrqqpzFU0HF9eA'
  
  L.tileLayer(tileURL, {
    maxZoom: 18,
    minZoom: 8,
    zoomControl:false,
    attribution:'Design by <a href="https://www.pratt.edu/research/spatial-analysis-visualization-initiative/">SAVI</a>, Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
  }).addTo(map);

  onMount(() => {
    checkScreenWidth();
    // center = isMobile ? [40.93, -73.97] : [40.93, -73.43];
    // zoom = isWide ? 10 : 9;
    mapContainer.appendChild(map.getContainer());
    map.getContainer().style.width = "100%";
    map.getContainer().style.height = "100%";
    map.invalidateSize();
    window.addEventListener("resize", checkScreenWidth);
  });

</script>

<svelte:head>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css" rel="stylesheet"/>
</svelte:head>


<style>
  .map {
    height: 100%;
    width: 100%;
  }
</style>
<div class="map" bind:this="{mapContainer}">
  <slot></slot>
</div>