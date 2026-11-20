class ApplicationController < ActionController::Base
  # Browser compatibility
  allow_browser versions: :modern

  # Importmap configuration
  stale_when_importmap_changes

  # Pagy
  include Pagy::Method

  SESSION_TIMEOUT = 30.minutes

  # Authentication
  before_action :enforce_session_timeout
  before_action :authenticate_user!

  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "Please log in first." unless logged_in?
  end

  # Authorization
  def admin?
    current_user&.admin?
  end

  def require_admin!
    redirect_to root_path, alert: "You are not authorized to perform this action." unless admin?
  end

  def enforce_session_timeout
    return unless session[:user_id]

    last_seen = session[:last_seen_at].presence && Time.zone.parse(session[:last_seen_at])
    if last_seen.nil? || last_seen < SESSION_TIMEOUT.ago
      reset_session
      redirect_to new_session_path, alert: "Your session expired. Please log in again."
    else
      session[:last_seen_at] = Time.current.iso8601
    end
  end
end
