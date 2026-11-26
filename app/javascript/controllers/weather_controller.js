import { Controller } from "@hotwired/stimulus"

const ICONS = [
  [[0], "bi-sun", "Clear"],
  [[1, 2], "bi-cloud-sun", "Partly cloudy"],
  [[3], "bi-cloud", "Overcast"],
  [[45, 48], "bi-cloud-fog", "Fog"],
  [[51, 53, 55, 56, 57], "bi-cloud-drizzle", "Drizzle"],
  [[61, 63, 65, 66, 67, 80, 81, 82], "bi-cloud-rain-heavy", "Rain"],
  [[95, 96, 99], "bi-cloud-lightning-rain", "Thunderstorm"]
]

export default class extends Controller {
  static targets = ["icon", "temp", "label", "detail"]
  static values = {
    lat: { type: Number, default: 13.6218 },    // Naga City
    lon: { type: Number, default: 123.1948 },
    place: { type: String, default: "Naga City" }
  }

  connect() {
    this.load()
    this.timer = setInterval(() => this.load(), 15 * 60 * 1000)
  }

  disconnect() { clearInterval(this.timer) }

  async load() {
    const key = `weather:${this.latValue},${this.lonValue}`
    try {
      const cached = JSON.parse(localStorage.getItem(key) || "null")
      if (cached && Date.now() - cached.at < 15 * 60 * 1000) return this.render(cached.data)
    } catch (_) {}

    const url = "https://api.open-meteo.com/v1/forecast" +
      `?latitude=${this.latValue}&longitude=${this.lonValue}` +
      "&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m" +
      "&timezone=Asia%2FManila"

    try {
      const res = await fetch(url)
      if (!res.ok) throw new Error(res.status)
      const data = (await res.json()).current
      try { localStorage.setItem(key, JSON.stringify({ at: Date.now(), data })) } catch (_) {}
      this.render(data)
    } catch (_) {
      this.labelTarget.textContent = "Weather unavailable"
    }
  }

  render(d) {
    const [, icon, label] = ICONS.find(([codes]) => codes.includes(d.weather_code)) || [[], "bi-cloud", "—"]
    this.iconTarget.className = `bi ${icon} weather__icon`
    this.tempTarget.textContent = `${Math.round(d.temperature_2m)}°C`
    this.labelTarget.textContent = `${label} · ${this.placeValue}`
    this.detailTarget.textContent =
      `Feels ${Math.round(d.apparent_temperature)}° · ${d.relative_humidity_2m}% humidity · ${Math.round(d.wind_speed_10m)} km/h`
  }
}