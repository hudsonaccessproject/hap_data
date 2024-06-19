<script>
    import CollapsibleSection from './CollapsibleSection.svelte'
</script>

<!-- <div> -->
    <CollapsibleSection isVisible={true} headerText={'Introduction'} >
        <p class="t4 ws"><strong>The Hudson Access Project</strong> was created to help you discover and explore the local waterways. Get to 
            know them, and learn how to do so safely.
        </p>
        <p class="t4 ws">
            Understand that air and water temperature can vary widely and cold water temperatures on a hot spring day can surprise novice 
            boaters at minimum, and pose mortal danger to those who fall in at worst. Also learn about the power of the wind; consult tide 
            and current tables and navigation charts; learn the rules of the water-ways and learn which fish species need protection by 
            consulting fishing regulations before you head out. Dress appropriately and bring plenty of food, water, and sun protection. 
            Don’t forget a life vest or other personal floatation devices; and when boating, travel with experienced boaters, and travel 
            in groups. 
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Water vs. Air Temperature'} >
        <div class="t4 ws" >
            <p class="t3">Water and air temperatures can vary considerably; especially in spring. </p>
            <img src="https://raw.githubusercontent.com/skhaji/test_data/main/water_safety/AIRvsTemp_website.jpg" alt="" class="safety-img">
        </div>
        <p class="t4 ws">Water temperatures below 60° can be dangerous to those who fall in or are submerged for any 
            amount of time, especially for those without personal floatation devices. Pay attention to water temperatures 
            and wear a PFD regardless of your swimming abilities when water temperatures are low and boating.
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Boating safety and regulations'} >
        <p class="t4 ws">Permits are required for kayaks and Canoes in New York City Parks: Find forms and boat safety regulation information at <a href="https://www.nycgovparks.org/pagefiles/127/Kayak-Canoe-Boat-Launch-Permit__5ade12c252c6c.pdf" target="_blank">this link</a>. Submitted by mail or in person.
        </p>
        <p class="t4 ws"><a href="https://parks.ny.gov/boating/registrations.aspx" target="_blank">Register a motor boat in NY</a>.
        </p>
        <p class="t4 ws"><a href="https://www.takemefishing.org/new-jersey/boating/boat-registration/" target="_blank">Register a motor boat in NJ</a>.
        </p>
        <p class="t4 ws">See the resources below for local safety guides for human powered boating. 
        </p>
        <p class="t4 ws"> <a href="https://www.graemebirchall.com/kayakers-guide" target="_blank">Kayaking guide: </a>This comprehensive resource covers 
            everything from commercial boat traffic, tidal information to boat wrecks in the area. Graeme Birchall of the Downtown Boathouse updates this annually. 
        </p>
        <p class="t4 ws"><a href="https://www.thesafeharbor.us/" target="_blank">Float plans and safety regulation</a>
        </p>
        <p class="t4 ws"><a href="https://nycwatertrail.org/harbor-safety-trip-planning/" target="_blank">Harbor Safety & Trip Planning, NYC Water Trail</a>
        </p>
        <p class="t4 ws"><a href="https://hudsonrivergreenwaywatertrail.org/info-safety" target="_blank">Hudson River Greenway Watertrail Safety Guide </a>
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Tides, currents, and weather'} >
        <p class="t4 ws"> <a href="https://tidesandcurrents.noaa.gov/tide_predictions.html?gid=1407" target="_blank">National Oceanic and Atmospheric Administration (NOAA) </a>
            tide and weather gauges in your location for site-specific tide and current charts, and <a href="https://tidesandcurrents.noaa.gov/map/index.html" target="_blank">map</a>.
        </p>
        <p class="t4 ws"> 
            <a href="https://hudson.dl.stevens-tech.edu/maritimeforecast/maincontrol.shtml" target="_blank">Stevens Institute, Tides and Currents</a>
        </p>
        <p class="t4 ws"> 
            <a href="www.thesafeharbor.us/chapters.html" target="_blank">Tips for boating safely</a>  on busy waterways.
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Fishing Regulations and advisories'} >
        <p class="t4 ws">Fishing permits and parking passes are required for some Gateway National Recreation Areas: </p>
        <p class="t4 ws2"> 
            <a href="https://www.nps.gov/gate/2024-permits.htm" target="_blank">National Park Service</a>
        </p>
        <p class="t4 ws2"> 
            <a href="https://nycwatertrail.org/harbor-safety-trip-planning/" target="_blank">NYC Water Trail</a>
        </p>
        <p class="t4 ws"> 
            <a href="https://www.dec.ny.gov/outdoor/7894.html" target="_blank">NY State fishing regulations</a>
        </p>
        <p class="t4 ws"> 
            <a href="https://www.dec.ny.gov/permits/54950.html" target="_blank">NY Recreational Marine Fishing Registry</a>
        </p>
        <p class="t4 ws"> 
            <a href="https://dep.nj.gov/saltwaterregistry/" target="_blank">NJ Recreational Marine Fishing Registry</a>
        </p>
        <p class="t4 ws"> 
            <a href="https://www.health.ny.gov/environmental/outdoors/fish/health_advisories/regional/new_york_city.htm#Upper" target="_blank">NY fish consumption advisories: Upper Bay, Rivers, and Kills</a>
        </p>
        <p class="t4 ws"> 
            <a href="https://dep.nj.gov/dsr/fish-advisories-studies/" target="_blank">NJ fish consumption advisories</a>
        </p>
    </CollapsibleSection>
<!-- </div> -->

<style>

    .safety-img {
		position: relative;
		width: 95%;
		padding-left: 2.5%;	
        padding-bottom: 10px;
	}
</style>