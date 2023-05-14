console.log("da");

function initializeTooltips() {
  console.log("Initializing tooltips");

   const tableRows = document.querySelectorAll("tbody tr:not(.processed)");
   
  tableRows.forEach(row => {
    row.classList.add("processed");
    const tooltip = document.createElement("span");
    tooltip.style.display = "none";
    tooltip.style.position = "absolute";
    tooltip.style.backgroundColor = "#f9f9f9";
    tooltip.style.border = "1px solid #ccc";
    tooltip.style.padding = "5px";
    tooltip.style.borderRadius = "3px";
    tooltip.style.boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.2)";
    tooltip.style.maxWidth = "400px";
    tooltip.style.whiteSpace = "normal";

    const observatiiValue = row.getAttribute('data-observatii');
    tooltip.innerText = observatiiValue;
    row.appendChild(tooltip);

    const nrCell = row.cells[0];
    nrCell.style.userSelect = "none";
    function showTooltip(e) {
      const tableRect = row.closest('table').getBoundingClientRect();
      const tooltipWidth = tooltip.getBoundingClientRect().width;
      const rightLimit = tableRect.right - tooltipWidth - 10;

      let left = e.pageX + 10;
      if (left > rightLimit) {
        left = rightLimit;
      }

      tooltip.style.left = left + "px";
      tooltip.style.top = (e.pageY + 10) + "px";
      tooltip.style.display = "block";
    }

    function hideTooltip() {
      tooltip.style.display = "none";
    }

    // Adaugă un stadiu vizibil pentru tooltip
    let tooltipVisible = false;
    
    function toggleTooltip(e) {
      // Anulăm orice selecție de text
      if (window.getSelection) {
        window.getSelection().removeAllRanges();
      } else if (document.selection) {
        document.selection.empty();
      }
      
      if (tooltipVisible) {
        hideTooltip();
        tooltipVisible = false;
      } else {
        showTooltip(e);
        tooltipVisible = true;
      }
    }

    nrCell.addEventListener("mouseenter", showTooltip);
    nrCell.addEventListener("mousemove", showTooltip);
    nrCell.addEventListener("mouseleave", hideTooltip);

    nrCell.addEventListener("touchstart", toggleTooltip, { passive: true });
    nrCell.addEventListener("touchmove", showTooltip, { passive: true });


  });
}


// Inițializează tooltip-urile atunci când se încarcă pagina
document.addEventListener("turbo:render", () => {
  console.log("turbo:render triggered");
  initializeTooltips();
});


// Inițializează tooltip-urile atunci când conținutul paginii se modifică

const observer = new MutationObserver((mutations) => {

  mutations.forEach((mutation) => {
    if (mutation.type === "childList") {
      initializeTooltips();
    }
  });
});

const config = { childList: true, subtree: true };
observer.observe(document.body, config);