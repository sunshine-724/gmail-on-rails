require 'google/apis/gmail_v1'
require 'googleauth'

class HomeController < ApplicationController
  def index

    access_token = session[:user_info]["token"]
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = access_token
    

    #get to latest of 10 mails
    result = service.list_user_messages('me', max_results: 10)
    @messages = []

    result.messages&.each do |msg|
      message = service.get_user_message('me', msg.id)
      headers = message.payload.headers
      subject = headers.find { |h| h.name == 'Subject' }&.value
      @messages << subject
    end
  rescue => e
    @messages = ["エラーが発生しました: #{e.message}"]
  end
end
