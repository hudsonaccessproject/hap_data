<script>
    // based on suggestions from:
    // Inclusive Components by Heydon Pickering https://inclusive-components.design/collapsible-sections/
    export let headerText;

    // create prop to track whether or not the section is visible
    export let isVisible = true;
    let expanded = isVisible;
</script>

<div class="collapsible">
    <h3>
        <button aria-expanded={expanded} on:click={() => expanded = !expanded}>
          {#if headerText}
            <!-- {headerText} -->
            <span class="header-text {expanded ? 'expanded' : ''}" >{headerText}</span>
          {/if}
<svg viewBox="0 0 20 20" fill="none" >
<path class="vert" d="M10 1V19" stroke="black" stroke-width="2"/>
<path d="M1 10L19 10" stroke="black" stroke-width="2"/>
</svg>
        </button>
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
    font-size: 14pt;
    font-weight: 600;
    color: #666;
    padding: 15px;
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

    button[aria-expanded="true"] .vert {
        display: none;
    }

    button:focus svg{
        outline: 2px solid;
    }
/* 
    button [aria-expanded="true"] rect {
        fill: currentColor;
    } */

    svg {
        height: 0.7em;
				width: 0.7em;
    }

    /* .contents {
      padding-top: 5px;
      padding-bottom: 5px;
    } */
</style>