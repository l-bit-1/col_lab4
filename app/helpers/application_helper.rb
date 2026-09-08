module ApplicationHelper

  def sidebar_link(label, path, controller)
    css = "nav-link text-white"
    css += " active" if controller_name == controller

    link_to label, path, class: css
  end
end
