// app/javascript/controllers/password_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password"]

  toggle() {
    const passwordField = this.passwordTarget
    const type = passwordField.type === 'password' ? 'text' : 'password'
    passwordField.type = type

    // Aici poți adăuga schimbarea iconiței dacă folosești una
    this.element.querySelector('.toggle-password').classList.toggle('fa-eye-slash');
  }
}
