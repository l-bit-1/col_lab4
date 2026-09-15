module ApplicationHelper
  def sidebar_link(label, path, controller, icon)
    css = "nav-link text-white"
    css += " active" if controller_name == controller

    link_to path, class: css do
      content_tag(:i, "", class: "bi #{icon} me-2") + label
    end
  end
end
