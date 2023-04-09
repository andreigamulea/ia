import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  input(event) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 300);
  }

  submit(event) {
    if (!event.detail.fetchResponse || !event.detail.fetchResponse.ok) {
      event.preventDefault();
    }
  }
}
