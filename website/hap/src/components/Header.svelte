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
          <span class="beta">beta</span>
        </div>
      </div>
      
      <i class="fas fa-info-circle mobile-about-button" on:click={() => setPage('about')} on:keydown={() => setPage('about')}></i>
      
      <div class="other-pages">
        <div class="hamburger-menu">
          <div class="col {$activePageTracker === 'access' ? 'active' : ''}">
            <div class="column-content other-pages" on:click={() => setPage('access')} on:keydown={() => setPage('access')}>
              Water Access
            </div>
          </div>
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
          <div class="col about {$activePageTracker === 'about' ? 'active' : ''}" >
            <div class="column-content other-pages" on:click={() => setPage('about')} on:keydown={() => setPage('about')}>
              About
            </div>
          </div>
        </div>
      </div>

    </div>
    <div class="find">
      {#if $activePageTracker === 'access'}
      <span class="t1 side-title">Find a place to access the water</span>
      {/if}
      {#if $activePageTracker === 'safety'}
      <span class="t1 side-title">How to stay safe on the water</span>
      {/if}
      {#if $activePageTracker === 'quality'}
      <span class="t1 side-title">Learn about water quality</span>
      {/if}
      {#if $activePageTracker === 'about'}
      <span class="t1 side-title">About the Hudson Access Project</span>
      {/if}
    </div>
  </header>    

<style>

  header {
    height: 65px;
    white-space: nowrap;
    margin: 0px;
    z-index: 3;
    position: absolute;
    width: 100vw;
    border-bottom: solid 1.5px rgb(225, 225, 225);
    display: flex;
  }

  .find {
    width: calc(30vw - 2px);
    display: flex;
    align-items: center;
  }

  .header-content {
    width: calc(70vw + 1.5px);
    display: flex;
    justify-content: space-between;
    flex-wrap: nowrap;
    height: 65px;
  }

  .col {
    flex-basis: 33.3%;
    border-right: solid 2px rgb(225, 225, 225);
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

  .side-title {
		color: var(--orange2);
		font-size: 22px;
		font-weight: 700;
    padding-left: 15px;
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
    color: var(--orange2);
    font-style: italic;
  }

  .other-pages {
    flex-basis: 60%;
  }

  .mobile-about-button {
    display: none;
  }

  .hamburger-menu {
    display: flex;
    justify-content: space-between;
    flex-wrap: nowrap;
    height: 65px;
    z-index: 100002;
  }

  @media (max-width: 1300px) {
    .column-content {
      font-size: 20px;
      padding-left: 1px;
      padding-right: 1px;
    }

    .title{
      font-size: 24px;
    }

    .side-title{
		  font-size: 20px;
		}
  }

  @media (max-width: 1100px) {
    .column-content {
      font-size: 18px;
    }

    .title{
      font-size: 22px;
    }

    .side-title{
		  font-size: 18px;
		}
  }

  @media (max-width: 1000px) {
    .column-content {
      font-size: 16px;
    }

    .title{
      font-size: 20px;
    }

    .side-title{
		  font-size: 15px;
		}
  }

  @media (max-width: 840px) {
    .title{
      font-size: 18px;
    }

    .column-content {
        font-size: 14px;
    }
  }


  /* Media query for mobile devices */
  @media (max-width: 767px) {
    header {
        width: 100%;
        height: 45px;

    }

    .title, .column-content{
      font-size: 20px;
    }

    .header-content {
      width: 100vw;
    }

    .find {
      display: none;
    }

    .other-pages {
      flex-basis: 0%;
    }

    .header-content {
      height: 45px;
    }
    
    .large-col {
      flex-basis: 100%;
    }

    .mobile-about-button {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 30px;
      height: 30px;
      border-radius: 50%;
      background-color: var(--orange3);
      color: white;
      cursor: pointer;
      position: absolute;
      top: 8px; 
      right: 8px;  
      z-index: 100; /* Ensure it's on top of other elements */
    }

  .col.about {
    /* Hide the desktop content on mobile */
    display: none;
  }

    .hamburger-menu {
      position: absolute;
      top: 100%;
      left: 0;
      width: 100%;
      background-color: #fff;

      box-sizing: border-box;
      height: 30px;
      border-top: solid 1.5px rgb(225, 225, 225);
      border-bottom: solid 1.5px rgb(225, 225, 225);
    }

    .hamburger-menu .col {
      flex-basis: calc(100% / 3);
    }
  }

</style>