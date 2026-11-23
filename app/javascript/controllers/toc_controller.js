import { Controller } from "@hotwired/stimulus"

// 画面上部からこの割合の位置を越えた章を「現在の章」とみなす
const CURRENT_LINE_RATIO = 0.3
// 利用者が自分でスクロールを始めたとみなす操作（スクロールバーのドラッグは mousedown で拾う）
const MANUAL_SCROLL_EVENTS = ["wheel", "touchstart", "keydown", "mousedown"]

export default class extends Controller {
  static targets = ["chapter", "link"]
  static classes = ["active", "inactive"]

  connect() {
    this.onScroll = () => this.scheduleUpdate()
    window.addEventListener("scroll", this.onScroll, { passive: true })
    window.addEventListener("resize", this.onScroll, { passive: true })
    this.onManualScroll = () => this.releaseSelection()
    MANUAL_SCROLL_EVENTS.forEach((type) => window.addEventListener(type, this.onManualScroll, { passive: true }))
    this.update()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
    window.removeEventListener("resize", this.onScroll)
    MANUAL_SCROLL_EVENTS.forEach((type) => window.removeEventListener(type, this.onManualScroll))
    cancelAnimationFrame(this.frame)
  }

  // 下の方の章はクリックしても判定位置まで移動できないため、クリックした章を手でスクロールするまで強調する。
  // 移動はブラウザのページ内リンクに任せる
  select(event) {
    this.selectedIndex = this.linkTargets.indexOf(event.currentTarget)
    this.update()
  }

  releaseSelection() {
    this.selectedIndex = null
  }

  scheduleUpdate() {
    cancelAnimationFrame(this.frame)
    this.frame = requestAnimationFrame(() => this.update())
  }

  update() {
    const currentIndex = this.selectedIndex ?? this.currentChapterIndex()

    this.linkTargets.forEach((link, index) => {
      const active = index === currentIndex
      this.activeClasses.forEach((name) => link.classList.toggle(name, active))
      this.inactiveClasses.forEach((name) => link.classList.toggle(name, !active))
      if (active) {
        link.setAttribute("aria-current", "true")
      } else {
        link.removeAttribute("aria-current")
      }
    })
  }

  currentChapterIndex() {
    const line = this.currentLine()
    let currentIndex = 0
    this.chapterTargets.forEach((chapter, index) => {
      if (chapter.getBoundingClientRect().top <= line) currentIndex = index
    })
    return currentIndex
  }

  // 下の方の短い章は判定位置まで上がってこないため、ページ下部では残りのスクロール量に合わせて
  // 判定位置を画面の下端まで下げ、最下部に着くまでに全ての章が順に判定位置を越えるようにする
  currentLine() {
    const viewportHeight = window.innerHeight
    const baseLine = viewportHeight * CURRENT_LINE_RATIO
    const shiftRange = viewportHeight - baseLine
    const remainingScroll = Math.max(0, document.documentElement.scrollHeight - (window.scrollY + viewportHeight))

    return remainingScroll >= shiftRange ? baseLine : baseLine + (shiftRange - remainingScroll)
  }
}
