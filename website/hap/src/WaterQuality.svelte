<script>
    import CollapsibleSection from './CollapsibleSection.svelte'
</script>

<CollapsibleSection isVisible={true} headerText={'Rainfall, Outfalls + Pollution'} >
    <p class="t4 ws">While local water quality has improved greatly in the last few decades, it is still affected everywhere 
        by stormwater discharge. Learn more from this map about where stormwater runoff and sewer overflow pollutes the 
        water during and after rain storms. Consider waiting a day or two after a heavy rain before going out on the water. </p>
    <div class="t4 ws" >
        <p class="t2 inner-title">Impact of Rainfall on Water Pollution</p>
        <p class="t3">Presence of Pathogenic Bacteria after Rainfall</p>
        <img src="https://raw.githubusercontent.com/skhaji/test_data/main/water_safety/WaterPollution_after_rain_website.jpg" alt="" class="safety-img">
        <p class="t3">For more information about local conditions:</p>
        <p class="t4 ws">New York City: <a href="https://www.nyc.gov/site/dep/water/waterbody-advisories.page" target="_blank">NYC DEP Waterbody Advisory Page</a></p>
        <p class="t4 ws">New Jersey: <a href="https://njcso.hdrgateway.com/" target="_blank">NJ Harbor Dischargers Group page (NJHDG)</a></p>
    </div>
</CollapsibleSection>
<CollapsibleSection isVisible={false} headerText={'Water Quality Resources '} >
    <p class="t4 ws qual">Learn more about water quality in the Estuary:
    </p>
    <p class="t4 ws">NY-NJ Harbor & Estuary Program: <a href="https://www.hudsonriver.org/article/harborwidewq" target="_blank">Water Quality Monitoring Report</a></p>
    <!-- <p class="t4 ws"> <a href="http://www.hudson-river.org/harborwidewqreport-2021" target="_blank">Water Quality Report</a></p> -->
    <p class="t4 ws">NY State DEC: <a href="https://www.hudsonriver.org/state-of-the-estuary#report" target="_blank">State of the Hudson Report</a></p>
     <!-- <p class="t4 ws"> <a href="https://www.hudsonriver.org/article/charts-and-graphs" target="_blank">Interactive Water Quality Charts and Graphs</a></p>
     <p class="t4 ws"> <a href="www.nycwatertrail.org/water_quality.html" target="_blank">The NYC Water Trail Association </a>reports weekly results from its Citizens Water Quality Testing Program</p> -->
     <p class="t4 ws"> <a href=" https://www.riverkeeper.org/water-quality/testing/" target="_blank">Riverkeeper</a> conducts regular water quality testing at 74 locations between New York Harbor and Waterford, NY. 
    </p>
    <p class="t4 ws"> <a href="https://ny.water.usgs.gov/maps/hrecos/" target="_blank">The Hudson River Environmental Conditions Observing System (HRECOS). </a>HRECOS monitoring stations are 
        geographically distributed along the Hudson and Mohawk Rivers, and sensors continuously record a suite of water quality and weather parameters every 15 minutes, 
        with most stations operating year-round.
    </p>
    <p class="t4 ws"><a href="https://hudsonriverpark.org/the-park/parks-river-project/science/monitoring-our-rivers-improving-health/#rainfall" target="_blank">The Hudson River Park Trust</a> conducts continuous water quality monitoring on the west side of Manhattan.</p>
    <p class="t4 ws"> <a href="https://hrnerr.org/" target="_blank">Hudson River National Estuarine Research Reserve</a></p>
    <!-- <ul>
        <li class="t4 ws"><a href="http://www.hudson-river.org/harborwidewqreport-2021" target="_blank">Water Quality Report</a></li>
        <li class="t4 ws"><a href="https://www.hudsonriver.org/state-of-the-estuary#report" target="_blank">State of the Hudson Report</a></li>
        <li class="t4 ws"><a href="https://www.hudsonriver.org/article/charts-and-graphs" target="_blank">Interactive Water Quality Charts and Graphs</a></li>
        <li class="t4 ws"><a href="www.nycwatertrail.org/water_quality.html" target="_blank">The NYC Water Trail Association </a>reports weekly results from its Citizens Water Quality Testing Program</li>
        <li class="t4 ws"><a href=" https://www.riverkeeper.org/water-quality/testing/" target="_blank">Riverkeeper</a>does regular water testing around the Hudson and Harbor area. 
            They provide numerous helpful resources. From their site: <i>"Our routine monitoring of 74 locations between New York Harbor and Waterford began in 2008. All data is gathered 
            in partnership with CUNY Queens College and Columbia University’s Lamont-Doherty Earth Observatory."</i>
        </li>
        <li class="t4 ws"><a href="https://ny.water.usgs.gov/maps/hrecos/" target="_blank">The Hudson River Environmental Conditions Observing System (HRECOS). </a>HRECOS monitoring stations are 
            geographically distributed along the Hudson and Mohawk Rivers, and are equipped with sensors that continuously record a suite of water quality and weather parameters every 15 minutes, 
            with most stations operating year-round.
        </li>
        <li class="t4 ws"><a href="https://hrnerr.org/" target="_blank">Hudson River National Estuarine Research Reserve</a></li>
    </ul> -->
</CollapsibleSection>

<style>
    .qual {
        padding-top: 5px;
        padding-bottom: 5px;
    }

    .inner-title {
        /* padding-top: 5px;
        padding-bottom: 5px; */
        color: var(--blue);
    }

    .indent{
        padding-left: 10px;
    }

    .safety-img {
		position: relative;
		width: 95%;
		padding-left: 2.5%;	
	}
</style>