
<script>
    // let isVisible = true;
    // let expanded = false;
</script>
<!-- map legend div with title and several rows with a styled circle or suqare and a label -->
<div class="legend">
    <h3 class="legend-title">NOAA Water Monitoring Stations</h3>
    <h3 class="header">Tide & Current Prediction stations</h3>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-circle" style="background-color: #fca057;"></div>
        </div>
        <div class="legend-label">Tides</div>
    </div>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-circle" style="background-color: #fcee57;"></div>
        </div>
        <div class="legend-label">Currents</div>
    </div>
    <h3 class="header">Temperature stations</h3>
    <div class="legend-row">
        <div class="legend-symbol">
            <div class="legend-circle" style="background-color: #a66dcf;"></div>
        </div>
        <div class="legend-label">Air & Water Temperature</div>
    </div>
</div>

<style>
    /* .legend {
        position: absolute;
        top: 10px;
        left: 55px;
        z-index: 1000;
        background-color: #fff;
        padding: 10px;
        border-radius: 5px;
        border: solid 2px rgb(204, 204, 204);
        font-size: 12px;
        line-height: 18px;
        max-width: 310px;
        max-height: calc(100vh - 115px);
        overflow-y: scroll;
        color: #707070;
    } */
    @media (max-width: 767px) {
        /* .legend {
            top: auto;
            margin-top: 10px;
        } */

        .header {
            display: none;
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
        font-size: 20px;
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

    .legend-circle {
        width: 75%;
        height: 75%;
        border-radius: 50%;
        border: solid 1px #000;
    }

    /* .legend-small-circle {
        width: 50%;
        height: 50%;
        border-radius: 50%;
        margin-top: 3px;
        margin-left: 3px;
    }

    .legend-square {
        width: 100%;
        height: 100%;
    } */

    .legend-label {
        margin: 0;
    }

    .header {
        font-weight: 700;
        margin-bottom: 5px;
    }

    /* .sub {
        margin-top: 12px;
    }

    .button-container {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        }

        .learn-text {
        margin-right: 5px; /* Adjust as needed 
        }

    .expand-icon {
        margin-left: 10px;
    }

    .learn-text {
        color: #707070;
    }
    .expand-icon {
        color: #707070;
    } */
    
</style>