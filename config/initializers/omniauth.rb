Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret],
           {
             scope: 'userinfo.email, userinfo.profile, gmail.readonly',
             access_type: 'offline',
             prompt: 'consent'
           }
end

OmniAuth.config.allowed_request_methods = %i[get]
Rails.logger.info "Omni Load!!!!!"
