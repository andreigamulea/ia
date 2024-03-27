// app/javascript/controllers/epytv_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Codul pe care vrei să-l execuți o singură dată
    console.log("epytv.js este încărcat prin Stimulus controller.");
    console.log("de fapt scriptul din canal2 este încărcat prin Stimulus controller.");
    // Aici poți inițializa orice logică specifică din epytv.js
  }
}
