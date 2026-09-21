import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  static values = { url: String }

  open() {
    this.modalTarget.classList.remove("hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }

  proceed() {
    window.Turbo.visit(this.urlValue)
  }
}
