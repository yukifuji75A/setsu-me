import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  switch(event) {
    const selected = event.currentTarget.dataset.tabName
    console.log('switch called, selected:', selected)

    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.tabName === selected
      tab.classList.toggle("border-b-2", isActive)
      tab.classList.toggle("border-black", isActive)
      tab.classList.toggle("text-gray-400", !isActive)
    })

    this.panelTargets.forEach(panel => {
      console.log('panel tabName:', panel.dataset.tabName, 'selected:', selected)
      panel.classList.toggle("hidden", panel.dataset.tabName !== selected)
      console.log('panel hidden:', panel.classList.contains("hidden"))
    })
  }
}
