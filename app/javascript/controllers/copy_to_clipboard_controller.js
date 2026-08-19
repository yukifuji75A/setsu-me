import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "label"]
  static values = { copiedLabel: String }

  async copy() {
    await navigator.clipboard.writeText(this.sourceTarget.value)

    const originalLabel = this.labelTarget.textContent
    this.labelTarget.textContent = this.copiedLabelValue

    setTimeout(() => {
      this.labelTarget.textContent = originalLabel
    }, 2000)
  }
}
