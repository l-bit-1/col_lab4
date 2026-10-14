// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

if (localStorage.getItem("sidebarCollapsed") === "1") {
  document.documentElement.classList.add("sidebar-collapsed")
}

document.addEventListener("click", (event) => {
  if (event.target.closest("[data-sidebar-toggle]")) {
    const collapsed = document.documentElement.classList.toggle("sidebar-collapsed")
    localStorage.setItem("sidebarCollapsed", collapsed ? "1" : "0")
  }
})