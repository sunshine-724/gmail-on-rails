class SessionsController < ApplicationController
#skip_before_action :require_login, only: :create


  def create
    session[:user_info] = request.env['omniauth.auth']

    auth = request.env['omniauth.auth']
    session[:user_info] = {
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email,
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      token_credential_uri: 'https://oauth2.googleapis.com/token'

      }

    Rails.logger.info "Session set: #{session[:user_info].inspect}"

    redirect_to home_path
  end

  def destroy
    session[:user_info] = nil
    redirect_to root_path
  end

end
