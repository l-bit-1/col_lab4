class ApplicationController < ActionController::Base
  # Browser compatibility
  allow_browser versions: :modern

  # Importmap configuration
  stale_when_importmap_changes

  # Pagy
  include Pagy::Method

  # Authentication
  before_action :authenticate_user!

  helper_method :current_user, :logged_in?, :admin?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    unless logged_in?
      redirect_to new_session_path, alert: "Please log in first."
    end
  end

  # Authorization
  def admin?
    current_user&.admin?
  end

  def require_admin!
    return if admin?

    redirect_back(
      fallback_location: root_path,
      alert: "Access denied. You do not have permission to perform this action.",
      status: :see_other
    )
  end
end