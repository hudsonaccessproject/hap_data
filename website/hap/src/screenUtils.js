let isMobile = false;

function checkScreenWidth() {
  isMobile = window.innerWidth <= 767; // Adjust the breakpoint as needed
  console.log(isMobile);
}

export { isMobile, checkScreenWidth };