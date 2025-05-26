class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include SessionsHelper

  allow_browser versions: :modern

  #before_action :require_login

  #def require_login
  #  return if current_user

  #  flash[:danger] = 'Googleログインが必要です'
  #  redirect_to root_path
  #end
end
