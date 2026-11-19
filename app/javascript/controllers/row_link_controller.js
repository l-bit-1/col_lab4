import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { url: String }

  go(event) {
    // let buttons, links, forms and inputs inside the row do their own thing
    if (event.target.closest("a, button, form, input, select, textarea")) return

    // allow text selection without triggering navigation
    if (window.getSelection().toString()) return

    Turbo.visit(this.urlValue)
  }

  // keyboard access: Enter or Space on the focused row opens it
  key(event) {
    if (event.target !== this.element) return
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault()
      Turbo.visit(this.urlValue)
    }
  }
}