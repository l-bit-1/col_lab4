import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "menu"]
  static values = { url: String }

  connect() {
    this.items = []
    this.active = -1
    this.onOutsideClick = (e) => { if (!this.element.contains(e.target)) this.close() }
    document.addEventListener("click", this.onOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.onOutsideClick)
    clearTimeout(this.timer)
  }

  search() {
    clearTimeout(this.timer)
    const q = this.inputTarget.value.trim()
    if (!q) return this.close()

    this.timer = setTimeout(async () => {
      const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(q)}`, {
        headers: { Accept: "application/json" }
      })
      this.render(await response.json())
    }, 200)
  }

  render(items) {
    this.items = items
    this.menuTarget.replaceChildren()
    this.active = -1

    if (items.length === 0) {
      const empty = document.createElement("div")
      empty.className = "list-group-item text-muted"
      empty.textContent = "No matches"
      this.menuTarget.append(empty)
      this.menuTarget.hidden = false
      return
    }

    const typed = this.inputTarget.value.trim()
    const labels = {
      starts: `Names starting with “${typed}”`,
      contains: `Names containing “${typed}”`
    }

    let lastGroup = null
    items.forEach((item) => {
      if (item.group && item.group !== lastGroup) {
        const header = document.createElement("div")
        header.className = "list-group-item autocomplete-header"
        header.textContent = labels[item.group] ?? item.group
        this.menuTarget.append(header)
        lastGroup = item.group
      }

      const link = document.createElement("a")
      link.href = item.url
      link.className = "list-group-item list-group-item-action"

      const name = document.createElement("div")
      name.className = "fw-semibold"
      name.textContent = item.name

      const meta = document.createElement("small")
      meta.className = "text-muted"
      meta.textContent = item.subtitle ?? ""

      link.append(name, meta)
      this.menuTarget.append(link)
    })

    this.menuTarget.hidden = false
  }

  keydown(event) {
    if (event.key === "Escape") return this.close()

    const links = [...this.menuTarget.querySelectorAll("a")]

    if (event.key === "Enter") {
      event.preventDefault()
      if (this.active >= 0 && links[this.active]) {
        links[this.active].click()
        return
      }
      const typed = this.inputTarget.value.trim().toLowerCase()
      const exact = (this.items || []).find((i) => i.name.trim().toLowerCase() === typed)
      if (exact) window.location.href = exact.url
      return
    }

    if (this.menuTarget.hidden || links.length === 0) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.highlight(links, (this.active + 1) % links.length)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.highlight(links, (this.active - 1 + links.length) % links.length)
    }
  }

  highlight(links, index) {
    links.forEach((l) => l.classList.remove("active"))
    this.active = index
    links[index].classList.add("active")
    links[index].scrollIntoView({ block: "nearest" })
  }

  close() {
    this.menuTarget.hidden = true
    this.active = -1
  }
}