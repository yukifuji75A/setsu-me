import { Controller } from "@hotwired/stimulus"

// テーマ色が渡されない画面（共通情報）で使う回答済みのマスの色
const DEFAULT_ANSWERED_CELL_CLASSES = ["bg-accent-purple", "border-accent-purple"]
const UNANSWERED_CELL_CLASSES = ["border-gray-200", "text-gray-400"]

export default class extends Controller {
  static targets = ["question", "cell", "count", "bar", "warning", "submit"]
  static classes = ["answered"]

  connect() {
    this.update()
  }

  update() {
    const answered = this.questionTargets.map((question) => this.isAnswered(question))
    const answeredCount = answered.filter(Boolean).length
    const unansweredCount = answered.length - answeredCount

    this.countTargets.forEach((el) => {
      el.textContent = answeredCount
    })
    this.barTargets.forEach((bar) => {
      bar.style.width = `${answered.length === 0 ? 0 : (answeredCount / answered.length) * 100}%`
    })
    this.cellTargets.forEach((cell, index) => {
      this.answeredCellClasses.forEach((name) => cell.classList.toggle(name, answered[index]))
      UNANSWERED_CELL_CLASSES.forEach((name) => cell.classList.toggle(name, !answered[index]))
    })
    this.warningTargets.forEach((warning) => {
      warning.textContent = `未回答が${unansweredCount}問あります`
      warning.classList.toggle("hidden", unansweredCount === 0)
    })
    this.updateSubmitState(unansweredCount)
  }

  // form-dirty の submit ターゲットを兼ねるボタンは、未回答0問のとき form-dirty の判定（変更の有無）に任せる
  updateSubmitState(unansweredCount) {
    this.submitTargets.forEach((button) => {
      if (unansweredCount > 0) {
        button.disabled = true
      } else if (!this.managedByFormDirty(button)) {
        button.disabled = false
      }
    })
  }

  get answeredCellClasses() {
    const colorClasses = this.hasAnsweredClass ? this.answeredClasses : DEFAULT_ANSWERED_CELL_CLASSES
    return [...colorClasses, "text-white"]
  }

  isAnswered(question) {
    if (question.querySelector('input[type="radio"]:checked')) return true

    const textarea = question.querySelector("textarea")
    return textarea !== null && textarea.value.trim() !== ""
  }

  managedByFormDirty(button) {
    return (button.dataset.formDirtyTarget || "").split(" ").includes("submit")
  }
}
