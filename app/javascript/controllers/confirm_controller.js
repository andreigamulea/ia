
// app/javascript/controllers/confirm_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Controlerul Confirm este conectat"); // Confirmă că Stimulus a inițializat controlerul
  }

  confirm(event) {
    console.log("Metoda confirm a fost apelată"); // Afișează un mesaj în consolă când metoda este apelată
    if (!window.confirm("Esti sigur ca vrei sa stergi inregistrarea?")) {
      event.preventDefault(); // Împiedică acțiunea implicită (de exemplu, trimiterea formularului) dacă utilizatorul nu confirmă
    }
  }
}
