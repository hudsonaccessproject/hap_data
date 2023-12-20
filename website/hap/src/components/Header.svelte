<script>
  import { activePageTracker, activeTileURL } from '../store.js';
  export let activePage;
  export let changePage;

  function refreshPage() {
    location.reload();
  }

  // function setPage(page, tileurl) {
  //   activePageTracker.set(page);
  //   activeTileURL.set(tileurl);
  // }

  // let safetyTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/clhyzicsw009n01pjc6t5adeb/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
  let safetyTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/clpvm5jgq00yi01qmb4p5ffbj/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
  let qualityTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/clhyzicsw009n01pjc6t5adeb/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
	let aboutTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/cli2a1j4w04qg01qn1cfaaqta/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'
	//let regTileURL = 'https://api.mapbox.com/styles/v1/prattsavi/cli2a1j4w04qg01qn1cfaaqta/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJhdHRzYXZpIiwiYSI6ImNsOGVzYjZ3djAycGYzdm9vam40MG40cXcifQ.YHBszyZW7pMQShx0GZISbw'


</script>
    
  <header>
    <div class="header-content">
      <div class="col large-col">
        <div class="title" on:click={refreshPage} on:keydown={refreshPage}>
          <span title="Covering sites where you can access the Hudson River Estuary South of the Mario Cuomo Bridge, Hudson tributaries, and the waters of the NY-NJ Harbor area.">Hudson Access Project</span> 
          <span title="This is a work in progress. Please help make this website as useful as it can be: send any corrections or site information to hudsonaccessproject@gmail.com." class="beta">beta</span>
        </div>
      </div>
      <!-- <div class="hamburger-selector">
        <input type="checkbox" id="hamburger-checkbox">
        <label for="hamburger-checkbox">
          <span class="hamburger"></span>
        </label>
        <div class="hamburger-menu">
          <div class="col" >
            <div class="column-content other-pages" on:click={() => setPage('safety', safetyTileURL)} on:keydown={() => setPage('safety', safetyTileURL)}>
              Water Safety
            </div>
          </div>
          <div class="col" >
            <div class="column-content other-pages" on:click={() => setPage('quality', qualityTileURL)} on:keydown={() => setPage('quality', qualityTileURL)}>
              Water Quality
            </div>
          </div>
          <div class="col" >
            <div class="column-content other-pages" on:click={() => setPage('about', aboutTileURL)} on:keydown={() => setPage('about', aboutTileURL)}>
              About
            </div>
          </div>
        </div>
      </div> -->
      <div class="hamburger-selector">
        <input type="checkbox" id="hamburger-checkbox">
        <label for="hamburger-checkbox">
          <span class="hamburger"></span>
        </label>
        <div class="hamburger-menu">
          <div class="col" class:active={activePage === 'safety'}>
            <div class="column-content other-pages" on:click={() => changePage(true, false, false, false, safetyTileURL)} on:keydown={() => changePage(true, false, false, false, safetyTileURL)}>
              Water Safety
            </div>
          </div>
          <div class="col" class:active={activePage === 'quality'}>
            <div class="column-content other-pages" on:click={() => changePage(false, false, true, false, qualityTileURL)} on:keydown={() => changePage(false, false, true, false, qualityTileURL)}>
              Water Quality
            </div>
          </div>
          <div class="col" class:active={activePage === 'about'}>
            <div class="column-content other-pages" on:click={() => changePage(false, false, false, true, aboutTileURL)} on:keydown={() => changePage(false, false, false, true, aboutTileURL)}>
              About
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>    

<style>

  .header-content {
    display: flex;
    justify-content: space-between;
    flex-wrap: nowrap;
    height: 65px;
  }

  .col {
    flex-basis: 33.3%;
    border: solid 1.5px rgb(225, 225, 225);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .large-col {
    flex-basis: 40%;
  }

  .title {
    /* color: #3884CB; */
    color: #707070;
    font-size: 20px;
    font-weight: 700;
    cursor: pointer;
  }

  .column-content {
    text-align: center;
    color: #5D5D5D;
    font-size: 20px;
    font-weight: 400;
  }

  /* active styles for column-content */
  .active {
    background-color: var(--orange3);
  }
  div.active .column-content {
    color: white;
    font-weight: 600!important;
  }
   /* hover styles for headers other than the title */
   .other-pages:hover {
    font-weight: 600;
  }

  .beta {
    font-size: 1em;
    color: #FFAA22;
    font-style: italic;
  }

  .hamburger-selector {
    flex-basis: 60%;
  }

  .hamburger-selector input[type="checkbox"] {
    display: none;
  }
  .hamburger-menu {
    display: flex;
    justify-content: space-between;
    flex-wrap: nowrap;
    height: 65px;
  }

  .column-content {
    /* make hand when hover */  
    cursor: pointer;
  } 


  /* Media query for mobile devices */
  @media (max-width: 767px) {
    .header-content {
      height: 45px;
    }
    
    .large-col {
      flex-basis: 90%;
    }

    .hamburger-selector {
      flex-basis: 10%;
      display: flex;
      align-items: end;
      justify-content: center;
      border: solid 1.5px rgb(225, 225, 225);
    }

    .hamburger-selector .hamburger {
      display: block;
      width: 25px;
      height: 3px;
      background-color: #707070;
      transition: background-color 0.3s ease;
      cursor: pointer;
    }

    .hamburger-selector .hamburger::before,
    .hamburger-selector .hamburger::after {
      content: "";
      display: block;
      width: 100%;
      height: 3px;
      background-color: #707070;
      transition: background-color 0.3s ease;
    }

    .hamburger-selector .hamburger::before {
      margin-bottom: 5px;
    }

    .hamburger-selector .hamburger::after {
      margin-top: 5px;
    }

    .hamburger-selector input[type="checkbox"] {
      display: none;
    }

    .hamburger-menu {
      display: none;
      position: absolute;
      top: 100%;
      left: 0;
      width: 100%;
      background-color: #fff;
      padding: 10px;
      box-sizing: border-box;
      height: auto;
    }

    .hamburger-selector input[type="checkbox"]:checked ~ .hamburger-menu {
      display: block;
    }

    .hamburger-menu .col {
      flex-basis: calc(100% / 3);
      margin-bottom: 10px;
    }
  }
</style>

