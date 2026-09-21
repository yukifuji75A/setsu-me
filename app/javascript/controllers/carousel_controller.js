import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "dots"]
  static values = { count: Number }

  connect() {
    this.renderDots()
    this.observer = new IntersectionObserver(
      (entries) => this.onIntersect(entries),
      { root: this.element, threshold: 0.6 }
    )
    this.cardTargets.forEach(card => this.observer.observe(card))
  }

  disconnect() {
    this.observer?.disconnect()
  }

  renderDots() {
    this.dotsTarget.innerHTML = this.cardTargets
      .map((_, index) => `<span class="w-[5px] h-[5px] rounded-full ${index === 0 ? "bg-white" : "bg-dark-muted/40"}" data-index="${index}"></span>`)
      .join("")
  }

  onIntersect(entries) {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return

      const index = this.cardTargets.indexOf(entry.target)
      this.dotsTarget.querySelectorAll("span").forEach((dot, dotIndex) => {
        dot.classList.toggle("bg-white", dotIndex === index)
        dot.classList.toggle("bg-dark-muted/40", dotIndex !== index)
      })
    })
  }
}
