
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["input"];

  debounce(event) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.inputTarget.dispatchEvent(new Event("debouncedinput", { bubbles: true }));
    }, this.data.get("debounce") || 300);
  }
}
