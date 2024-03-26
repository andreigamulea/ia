import { Controller } from "@hotwired/stimulus"
import "epytv"

export default class extends Controller {
  connect() {
    console.log("Aplicația Stimulus a încărcat epytv.js");
    // Aici poți adăuga orice logica adițională necesară
  }
}

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

