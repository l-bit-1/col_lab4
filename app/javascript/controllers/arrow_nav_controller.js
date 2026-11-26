import { Controller } from "@hotwired/stimulus"

const SELECTOR = [
  "main a[href]",
  "main button:not([disabled])",
  "main [tabindex='0']",
  ".sidebar-nav a[href]"
].join(",")

const DIRECTIONS = { ArrowRight: "right", ArrowLeft: "left", ArrowDown: "down", ArrowUp: "up" }

export default class extends Controller {
  key(event) {
    if (event.defaultPrevented || event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return
    const typing = this.typing(event.target)

    if (event.repeat) {
    const now = performance.now()
        if (this.lastAt && now - this.lastAt < 120) { event.preventDefault(); return }
    }
        this.lastAt = performance.now()

    if (event.key === "/" && !typing) {                      // "/" jumps to the search box
      const search = document.querySelector("main input[type='search']")
      if (search) { event.preventDefault(); search.focus() }
      return
    }
    if (event.key === "Escape") {                            // Esc hands scrolling back to the page
      if (!typing) document.activeElement?.blur()
      return
    }

    const dir = DIRECTIONS[event.key]
    if (!dir || typing) return

    const items = this.items()
    const from = document.activeElement
    if (!from || from === document.body) {                   // nothing focused yet: start at the sidebar
      const start = document.querySelector(".sidebar-nav a.active") || items[0]
      if (start) { event.preventDefault(); start.focus() }
      return
    }

    const next = this.nearest(from, items, dir)
    if (!next) return
    event.preventDefault()

    // entering the sidebar always lands on the current page's link
    const inSidebar = next.closest(".sidebar-nav")
    const target = inSidebar ? (inSidebar.querySelector("a.active") || next) : next
    target.focus()
    target.scrollIntoView({ block: "nearest", behavior: "instant" })
  }

  items() {
    return [...document.querySelectorAll(SELECTOR)].filter((el) =>
      el.getClientRects().length > 0 && !el.closest(".autocomplete-menu") && !el.closest("[hidden]"))
  }

  nearest(from, items, dir) {
    const a = from.getBoundingClientRect()
    const ax = a.left + a.width / 2
    const ay = a.top + a.height / 2
    let best = null
    let bestScore = Infinity

    for (const el of items) {
      if (el === from) continue
      const b = el.getBoundingClientRect()
      const dx = b.left + b.width / 2 - ax
      const dy = b.top + b.height / 2 - ay

      let primary, secondary
      if (dir === "right")     { if (dx <= 4)  continue; primary = dx;  secondary = Math.abs(dy) }
      else if (dir === "left") { if (dx >= -4) continue; primary = -dx; secondary = Math.abs(dy) }
      else if (dir === "down") { if (dy <= 4)  continue; primary = dy;  secondary = Math.abs(dx) }
      else                     { if (dy >= -4) continue; primary = -dy; secondary = Math.abs(dx) }

      const score = primary + secondary * 2                  // favour staying in line
      if (score < bestScore) { best = el; bestScore = score }
    }
    return best
  }

  typing(el) {
    return !!el?.closest?.("input, textarea, select, [contenteditable='true']")
  }
}