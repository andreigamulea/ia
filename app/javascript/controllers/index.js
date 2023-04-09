import { Application } from "stimulus";
import { importmap } from "@hotwired/stimulus-importmap-autoloader";
import DebounceController from "./debounce_controller";

const application = Application.start();
const context = import.meta.globEager("./*_controller.js");
application.load(importmap(context, (moduleName) => moduleName.replace(/\.js$/, "")));

application.register("debounce", DebounceController);
