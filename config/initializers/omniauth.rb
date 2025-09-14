Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch("GOOGLE_CLIENT_ID", "dummy_client_id"),
           ENV.fetch("GOOGLE_CLIENT_SECRET", "dummy_client_secret"),
           {
             scope: 'userinfo.email, userinfo.profile, gmail.readonly, gmail.send',
             access_type: 'offline',
             prompt: 'consent'
           }
end

OmniAuth.config.allowed_request_methods = %i[get]
Rails.logger.info "Omni Load!!!!!"
