import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.pill = document.createElement("span")
    this.pill.className = "sidebar-pill"
    this.element.append(this.pill)

    this.lastKeyAt = 0
    this.lastMoveAt = 0
    this.keyboardActive = false
    this.current = this.linkFor(location.href)

    this.onBeforeVisit = (e) => this.setCurrent(this.linkFor(e.detail.url))
    this.onSync = () => this.setCurrent(this.linkFor(location.href))
    this.onOver = (e) => {
      if (this.lastKeyAt && performance.now() - this.lastKeyAt < 500) return // keyboard is in control
      const l = e.target.closest("a[href]")
      if (l) this.place(l)
    }
    this.onLeave = () => this.place(this.resting())
    this.onMouseMove = (e) => {
      // real mouse movement hands control back to the current page
      if (e.movementX || e.movementY) this.keyboardActive = false
    }
    this.onFocusIn = (e) => {
      const l = e.target.closest("a[href]")
      if (!l) return
      if (l.matches(":focus-visible")) this.keyboardActive = true
      this.place(l)
    }
    this.onFocusOut = (e) => {
      if (!this.element.contains(e.relatedTarget)) this.place(this.resting())
    }
    this.onKeydown = (e) => this.keydown(e)

    document.addEventListener("turbo:before-visit", this.onBeforeVisit)
    document.addEventListener("turbo:load", this.onSync)
    window.addEventListener("resize", this.onSync)
    this.element.addEventListener("mouseover", this.onOver)
    this.element.addEventListener("mouseleave", this.onLeave)
    this.element.addEventListener("mousemove", this.onMouseMove)
    this.element.addEventListener("focusin", this.onFocusIn)
    this.element.addEventListener("focusout", this.onFocusOut)
    this.element.addEventListener("keydown", this.onKeydown)

    this.setCurrent(this.current)
    requestAnimationFrame(() => requestAnimationFrame(() => this.pill.classList.add("is-ready")))
  }

  disconnect() {
    document.removeEventListener("turbo:before-visit", this.onBeforeVisit)
    document.removeEventListener("turbo:load", this.onSync)
    window.removeEventListener("resize", this.onSync)
    this.element.removeEventListener("mouseover", this.onOver)
    this.element.removeEventListener("mouseleave", this.onLeave)
    this.element.removeEventListener("mousemove", this.onMouseMove)
    this.element.removeEventListener("focusin", this.onFocusIn)
    this.element.removeEventListener("focusout", this.onFocusOut)
    this.element.removeEventListener("keydown", this.onKeydown)
    this.pill.remove()
  }

  // Up/Down/Home/End move focus between links (no wrap-around, throttled while held)
  keydown(event) {
    if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return
    this.keyboardActive = true
    const links = [...this.element.querySelectorAll("a[href]")]
    const i = links.indexOf(document.activeElement)
    if (i < 0) return

    let next = null
    if (event.key === "ArrowDown") next = links[Math.min(i + 1, links.length - 1)]
    else if (event.key === "ArrowUp") next = links[Math.max(i - 1, 0)]
    else if (event.key === "Home") next = links[0]
    else if (event.key === "End") next = links[links.length - 1]
    else return

    event.preventDefault()
    this.lastKeyAt = performance.now()

    if (event.repeat && this.lastMoveAt && performance.now() - this.lastMoveAt < 120) return
    this.lastMoveAt = performance.now()
    if (next && next !== links[i]) next.focus()
  }

  // where the pill rests when nothing is hovered:
  // the focused link while the keyboard is in use, otherwise the current page
  resting() {
    const f = document.activeElement
    return this.keyboardActive && this.element.contains(f) ? f : this.current
  }

  // the link whose path is the longest match: /students/5 highlights "Students"
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

  setCurrent(link) {
    this.current = link
    this.element.querySelectorAll("a.active").forEach((a) => a.classList.remove("active"))
    if (link) link.classList.add("active")
    this.place(link)
  }

  place(link) {
    this.element.querySelectorAll("a.is-previewed").forEach((a) => a.classList.remove("is-previewed"))
    if (!link) { this.pill.style.opacity = 0; return }

    link.classList.add("is-previewed")
    this.element.classList.toggle("is-previewing", link !== this.current)

    const nav = this.element.getBoundingClientRect()
    const box = link.getBoundingClientRect()
    this.pill.style.opacity = 1
    this.pill.style.width = `${box.width}px`
    this.pill.style.height = `${box.height}px`
    this.pill.style.transform = `translate(${box.left - nav.left}px, ${box.top - nav.top}px)`
  }
}