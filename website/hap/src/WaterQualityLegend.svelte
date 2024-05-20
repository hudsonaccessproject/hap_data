
<script>
    let isVisible = true;
    let expanded = false;
</script>
<!-- map legend div with title and several rows with a styled circle or suqare and a label -->
<div class="legend">
    <h3 class="legend-title">Boat Launches and Swimming Beaches</h3>
    <div class="legend-row sub">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: #000000;"></div>
        </div>
        <div class="legend-label header">Human powered boat launches or swim beach</div>
    </div>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: #FFAA22;"></div>
        </div>
        <div class="legend-label">within half mile of an outfall</div>
    </div>
    <!-- <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-circle" style="background-color: #FFD474;"></div>
        </div>
        <div class="legend-label">within half mile of MS4</div>
    </div>
    <div class="legend-row sub">
        <div class="legend-symbol">
            <div class="legend-square" style="background-color: #91D57D;"></div>
        </div>
        <div class="legend-label header">Swimming Beaches</div>
    </div>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-square" style="background-color: #FFD474;"></div>
        </div>
        <div class="legend-label">within half mile of MS4</div>
    </div> -->
    <h3 class="legend-subtitle">Pollution Sources: Outfalls</h3>
    <!-- <div class="legend-row sub">
        <div class="legend-label header">Pollution Sources: Outfalls</div>
    </div> -->
    <div class="legend-row sub">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: #C4C3C3; border: 1px solid #C4C3C3;"></div>
        </div>
        <div class="legend-label header">Combined Sewer Outflows (CSOs)</div>
    </div>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: transparent; border: 1.5px solid #FFAA22;"></div>
        </div>
        <div class="legend-label">within half mile of a boat launch or swimming beach</div>
    </div>
    <!-- <div class="legend-row sub">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: #C4C3C3; border: 1px solid #C4C3C3;"></div>
        </div>
        <div class="legend-label header">Municipal Separate Storm Sewer Systems (MS4)</div>
    </div>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: transparent; border: 1px solid #FFAA22;"></div>
        </div>
        <div class="legend-label">within half mile of a boat launch or swimming beach</div>
    </div> -->
    <!-- <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-small-circle" style="background-color: #FFAA22; border: 1px solid #FFAA22;"></div>
        </div>
        <div class="legend-label">within half mile of swimming beaches</div>
    </div> -->
    <div class="legend-collapsible">
        <h3>
            <button aria-expanded={expanded} on:click={() => expanded = !expanded} class="button-container">
                <span class="learn-text header {expanded ? 'expanded' : ''}" >Learn more</span>
                <span class="expand-icon {expanded ? 'expanded' : ''}">{expanded ? 'x' : '+'}</span>
            </button>
        </h3>
        
        <div class='contents' hidden={!expanded}>
            <p><span class="header">CSOs and storm related pollution:</span> 
                Combined Sewer Overflows serve about 60% of New York City. Under dry weather conditions CSOs convey sewage to 
                treatment plants but with as little one twentieth of an inch of rain, CSOs can be overwhelmed and stormwater and 
                sewage are diverted to overflow outflows and discharged into area waterbodies. According to Riverkeeper, more 
                than 27 billion gallons of raw sewage and polluted stormwater runoff from CSOs enter the waters of the Harbor 
                and Estuary every year.  
            </p>
            <!-- <p><span class="header">MS4s:</span> Municipal Separate Storm Sewer Systems carry stormwater runoff directly to local waterbodies 
                and serve approximately 30–40% of New York 
                City. (<a href="https://www.nyc.gov/site/dep/water/municipal-separate-storm-sewer-system.page#:~:text=A%20municipal%20separate%20storm%20sewer,surface%20waters%20of%20the%20State." target="_blank">NYC DEP</a>) As 
                stormwater flows over streets and other impervious surfaces, it sweeps up pollutants such as oils, chemicals, pathogens, 
                and sediments. In separate sewer areas, this pollution is carried by stormwater and discharged directly into local waterways.  
            </p> -->
        </div>
    </div>
</div>

<style>
    .legend {
        position: absolute;
        top: 10px;
        left: 55px;
        z-index: 1000;
        background-color: #fff;
        padding: 10px;
        border-radius: 5px;
        border: solid 2px rgb(204, 204, 204);
        /* box-shadow: 0 1px 1px rgba(0, 0, 0, 0.65); */
        font-size: 12px;
        line-height: 18px;
        max-width: 310px;
        max-height: calc(100vh - 115px);
        overflow-y: scroll;
        color: #707070;
    }
    /* Media query for mobile devices */
    @media (max-width: 767px) {
        .legend {
            top: auto;
            margin-top: 5px;
        }
    }

    /* Hide scrollbar for Chrome, Safari and Opera */
	.legend::-webkit-scrollbar {
		display: none;
	}

	/* Hide scrollbar for IE, Edge and Firefox */
	.legend {
		-ms-overflow-style: none;  /* IE and Edge */
		scrollbar-width: none;  /* Firefox */
	}

    .legend-title {
        color: #707070;
        margin: 0 0 5px 0;
        font-size: 16px;
        font-weight: 700;
        line-height: 1.25;
    }

    .legend-subtitle {
        color: #707070;
        margin: 5px 0 5px 0;
        font-size: 16px;
        font-weight: 700;
        line-height: 1.25;
    }

    .legend-row {
        display: flex;
        align-items: center;
        margin-bottom: 2px;
    }

    .legend-symbol {
        width: 17px;
        height: 17px;
        margin-right: 5px;
    }

    /* .legend-circle {
        width: 90%;
        height: 90%;
        border-radius: 50%;
    } */

    .legend-small-circle {
        width: 50%;
        height: 50%;
        border-radius: 50%;
        margin-top: 3px;
        margin-left: 3px;
    }

    /* .legend-square {
        width: 100%;
        height: 100%;
    } */

    .legend-label {
        margin: 0;
    }

    .header {
        font-weight: 700;
    }

    .sub {
        margin-top: 6px;
    }

    .button-container {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        }

        .learn-text {
        margin-right: 5px; /* Adjust as needed */
        }

    .expand-icon {
        margin-left: 10px;
    }

    .learn-text {
        color: #707070;
    }
    .expand-icon {
        color: #707070;
    }
    
</style>