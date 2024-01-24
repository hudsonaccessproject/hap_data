<script>
  import { activePageTracker } from '../store.js';

  function refreshPage() {
    location.reload();
  }

  function setPage(page) {
    activePageTracker.set(page);
  }

</script>
    
  <header>
    <div class="header-content">
      <div class="col large-col">
        <div class="title" on:click={refreshPage} on:keydown={refreshPage}>
          <span title="Covering sites where you can access the Hudson River Estuary South of the Mario Cuomo Bridge, Hudson tributaries, and the waters of the NY-NJ Harbor area.">Hudson Access Project</span> 
          <span title="This is a work in progress. Please help make this website as useful as it can be: send any corrections or site information to hudsonaccessproject@gmail.com." class="beta">beta</span>
        </div>
      </div>
      <div class="hamburger-selector">
        <input type="checkbox" id="hamburger-checkbox">
        <!-- <label for="hamburger-checkbox">
          <span class="hamburger"></span>
        </label> -->
        <label for="hamburger-checkbox">
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
          <span class="hamburger-line"></span>
        </label>
        <div class="hamburger-menu">
          <div class="col {$activePageTracker === 'safety' ? 'active' : ''}">
            <div class="column-content other-pages" on:click={() => setPage('safety')} on:keydown={() => setPage('safety')}>
              Water Safety
            </div>
          </div>
          <div class="col {$activePageTracker === 'quality' ? 'active' : ''}" >
            <div class="column-content other-pages" on:click={() => setPage('quality')} on:keydown={() => setPage('quality')}>
              Water Quality
            </div>
          </div>
          <div class="col {$activePageTracker === 'about' ? 'active' : ''}" >
            <div class="column-content other-pages" on:click={() => setPage('about')} on:keydown={() => setPage('about')}>
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
    font-size: 26px;
    font-weight: 700;
    cursor: pointer;
    margin-left: 5px;
    margin-right: 5px;
  }

  .column-content {
    text-align: center;
    color: #5D5D5D;
    font-size: 22px;
    font-weight: 400;
    cursor: pointer;
    margin-left: 1px;
    margin-right: 1px;
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

  @media (max-width: 1200px) {
    .column-content {
      font-size: 20px;
    }

    .title{
      font-size: 24px;
    }
  }

  @media (max-width: 1000px) {
    .column-content {
      font-size: 18px;
    }

    .title{
      font-size: 22px;
    }
  }

  @media (max-width: 900px) {
    .column-content {
      font-size: 15px;
    }

    .title{
      font-size: 20px;
    }
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

    .hamburger-line {
      display: block;
      width: 25px;
      height: 3px;
      background-color: #707070;
      transition: background-color 0.3s ease;
      cursor: pointer;
      margin-bottom: 5px;
    }
  }

</style>