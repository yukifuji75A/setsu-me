import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  switch(event) {
    const selected = event.currentTarget.dataset.tabName

    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.tabName === selected
      tab.classList.toggle("border-b-2", isActive)
      tab.classList.toggle("border-accent-purple", isActive)
      tab.classList.toggle("text-white", isActive)
      tab.classList.toggle("text-dark-muted", !isActive)
    })

    this.panelTargets.forEach(panel => {
      panel.classList.toggle("hidden", panel.dataset.tabName !== selected)
    })
  }
}
