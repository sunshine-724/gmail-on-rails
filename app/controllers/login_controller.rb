class LoginController < ApplicationController

  #skip_before_action :require_login, only: [:index]

  def index
    Rails.logger.info "OmniAuth initializer loaded"
  end
end
