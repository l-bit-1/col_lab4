class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: "Too many attempts. Try again in a few minutes." }

  def new
  end

  def create
    user = User.authenticate_by(
      email: params[:email].to_s.strip.downcase,
      password: params[:password].to_s
    )

    if user
      reset_session                                  # new session id on login
      session[:user_id] = user.id
      session[:last_seen_at] = Time.current.iso8601
      redirect_to root_path, notice: "Successfully logged in."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "Successfully logged out."
  end
end
