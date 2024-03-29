<script>
    // based on suggestions from:
    // Inclusive Components by Heydon Pickering https://inclusive-components.design/collapsible-sections/
    export let headerText;

    // create prop to track whether or not the section is visible
    export let isVisible = true;
    let expanded = isVisible;
    let isDesktop = window.innerWidth >= 768; 

    // Function to update expanded and isVisible based on screen width
    function updateVisibility() {
      isDesktop = window.innerWidth >= 768; // Adjust the breakpoint as needed
      expanded = isDesktop && isVisible;
    }

    // Initial call to set the initial values based on the screen width
    updateVisibility();

    // Event listener to update values on window resize
    window.addEventListener('resize', updateVisibility);
</script>

<div class="collapsible">
    <h3>
      <button aria-expanded={expanded} on:click={() => expanded = !expanded}>
        {#if headerText}
            <!-- {headerText} -->
            <span class="header-text {expanded ? 'expanded' : ''}" >{headerText}</span>
          {/if}
        {#if expanded}
          <!-- "X" SVG for close -->
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        {:else}
          <!-- "+" SVG for open -->
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
        {/if}
      <!-- </button>
        <button aria-expanded={expanded} on:click={() => expanded = !expanded}>
          {#if headerText} -->
            <!-- {headerText} -->
            <!-- <span class="header-text {expanded ? 'expanded' : ''}" >{headerText}</span>
          {/if}
          <svg viewBox="0 0 20 20" fill="none" >
          <path class="vert" d="M10 1V19" stroke="black" stroke-width="2"/>
          <path d="M1 10L19 10" stroke="black" stroke-width="2"/>
          </svg>
        </button> -->
    </h3>
    
    <div class='contents' hidden={!expanded}>
        <slot></slot>
    </div>
</div>

<style>
  .collapsible {
    border-bottom: 1.5px solid var(--gray-light, #e1e1e1);
  }
	
	h3 {
		margin: 0;
	}

/* Styles for non-expanded state */
  /* .collapsible h3 .header-text {
    color: black;
  } */

.collapsible h3 .header-text.expanded {
  /* Styles for expanded state */
  color: #3884CB;
}
	
  button {
    background-color: var(--background, #fff);
    color: var(--gray-darkest, #999);
    display: flex;
		justify-content: space-between;
    width: 100%;
		border: none;
		margin: 0;
		padding: 0.5em 0.5em;
    font-family: "ff-tisa-sans-web-pro", sans-serif;
    /* font-size: 9pt;
    color: #999; */
    font-size: 16pt;
    font-weight: 600;
    color: #666;
    padding: 15px;
  }

  @media (max-width: 1000px) {
    button {
      font-size: 18px;
    }
  }

  /* Media query for mobile devices */
	@media (max-width: 767px) {
    button {
      padding-top: 0.3em;
      padding-bottom: 0.3em;
    }
  }


  button[aria-expanded="true"] {
    border-bottom: 1.5px solid var(--gray-light, #e1e1e1);
  }

    /* button[aria-expanded="true"] .vert {
        display: none;
    } */

    /* button:focus svg{
        outline: 2px solid;
    } */
/* 
    button [aria-expanded="true"] rect {
        fill: currentColor;
    } */

    /* svg {
        height: 0.7em;
				width: 0.7em;
    } */

    /* .contents {
      padding-top: 5px;
      padding-bottom: 5px;
    } */
</style>