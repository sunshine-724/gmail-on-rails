class HealthController < ApplicationController
      # CSRF 不要、かつ認証不要にする
  skip_before_action :verify_authenticity_token
  def up
    render plain: 'OK', status: :ok
  rescue
    head :internal_server_error
  end
end
