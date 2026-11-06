import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "veil"]
  static values = {
    distance: { type: Number, default: 500 },  // px of scrolling until fully white
    maxBlur:  { type: Number, default: 6 }     // px of blur at the end
  }

  connect() {
    this.ticking = false
    this.onScroll = () => {
      if (this.ticking) return
      this.ticking = true
      requestAnimationFrame(() => { this.update(); this.ticking = false })
    }
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.update()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  update() {
    const progress = Math.min(window.scrollY / this.distanceValue, 1)
    this.imageTarget.style.filter = `blur(${progress * this.maxBlurValue}px)`
    this.veilTarget.style.opacity = progress
  }
}