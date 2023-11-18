
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  submitTotals() {
        
      const vataTotal = parseInt(document.getElementById('total-punctaj-vata').innerText) || 0;
      const pittaTotal = parseInt(document.getElementById('total-punctaj-pitta').innerText) || 0;
      const kaphaTotal = parseInt(document.getElementById('total-punctaj-kapha').innerText) || 0;
  
      fetch(`/calculate_totals?totals=${vataTotal},${pittaTotal},${kaphaTotal}`, {
        headers: {
          'Accept': 'text/html'
        }
      }).then(response => response.text())
        .then(html => {
          let frame = document.getElementById('total-sum-display');
          frame.innerHTML = html;
        });
    }
  }