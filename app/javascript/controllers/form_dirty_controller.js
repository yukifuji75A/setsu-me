import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "submit", "showWhenDirty", "showWhenClean"]

  connect() {
    this.initialState = this.serialize()
    this.updateSubmitState()
  }

  check() {
    this.updateSubmitState()
  }

  updateSubmitState() {
    const dirty = this.serialize() !== this.initialState

    this.submitTargets.forEach((button) => {
      button.disabled = !dirty
    })
    this.showWhenDirtyTargets.forEach((el) => {
      el.classList.toggle("hidden", !dirty)
    })
    this.showWhenCleanTargets.forEach((el) => {
      el.classList.toggle("hidden", dirty)
    })
  }

  serialize() {
    return new URLSearchParams(new FormData(this.formTarget)).toString()
  }
}
