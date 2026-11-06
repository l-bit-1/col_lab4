 import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.pill = document.createElement("span")
    this.pill.className = "sidebar-pill"
    this.element.append(this.pill)

    this.onBeforeVisit = (e) => this.moveTo(this.linkFor(e.detail.url))
    this.onSync = () => this.moveTo(this.linkFor(location.href))

    document.addEventListener("turbo:before-visit", this.onBeforeVisit) // clicks, including the home cards
    document.addEventListener("turbo:load", this.onSync)                // back/forward buttons, first load
    window.addEventListener("resize", this.onSync)

    this.moveTo(this.linkFor(location.href))
    // enable the glide only after the first placement so it doesn't slide in from the corner
    requestAnimationFrame(() => requestAnimationFrame(() => this.pill.classList.add("is-ready")))
  }

  disconnect() {
    document.removeEventListener("turbo:before-visit", this.onBeforeVisit)
    document.removeEventListener("turbo:load", this.onSync)
    window.removeEventListener("resize", this.onSync)
    this.pill.remove()
  }

  // the link whose path is the longest match: /students/5 highlights "Students", "/" only matches Home
  linkFor(url) {
    const path = new URL(url, location.origin).pathname
    let best = null
    let bestLength = -1
    this.element.querySelectorAll("a[href]").forEach((a) => {
      const p = new URL(a.href).pathname
      const matches = p === path || (p !== "/" && path.startsWith(p + "/"))
      if (matches && p.length > bestLength) { best = a; bestLength = p.length }
    })
    return best
  }

  moveTo(link) {
    this.element.querySelectorAll("a.active").forEach((a) => a.classList.remove("active"))
    if (!link) { this.pill.style.opacity = 0; return }

    link.classList.add("active")
    const nav = this.element.getBoundingClientRect()
    const box = link.getBoundingClientRect()
    this.pill.style.opacity = 1
    this.pill.style.width = `${box.width}px`
    this.pill.style.height = `${box.height}px`
    this.pill.style.transform = `translate(${box.left - nav.left}px, ${box.top - nav.top}px)`
  }
}