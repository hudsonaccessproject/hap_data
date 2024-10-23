import { writable } from "svelte/store";

let map = {}
export const count = writable(map);
export const active = writable("");
export const mapDataSiteIds = writable([]);
export const activePageTracker = writable('access');
export const activeTileURL = writable('https://api.mapbox.com/styles/v1/prattsavi/cli2a1j4w04qg01qn1cfaaqta/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw');
//export const activeTileURL = writable('https://api.mapbox.com/styles/v1/hudsonaccess/cm0s2a1w602ip01qv1kwt2nmo/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaHVkc29uYWNjZXNzIiwiYSI6ImNsbDJqbnJ5ZjIyYWgzZHBrNTFwNmp5eHgifQ.WmHbnTbEIrqqpzFU0HF9eA');
export const arePanelsVisible = writable(true);