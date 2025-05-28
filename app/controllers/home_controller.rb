require 'google/apis/gmail_v1'
require 'googleauth'
require 'base64'
require 'mail'

class HomeController < ApplicationController
  def index
    if(session[:user_info] == nil)
      redirect_to root_path
    end
    access_token = session[:user_info]["token"]
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = access_token

    result = service.list_user_messages('me', max_results: 10)
    @messages = []

    result.messages&.each do |msg|
      message = service.get_user_message('me', msg.id)
      headers = message.payload.headers
      subject = headers.find { |h| h.name == 'Subject' }&.value
      @messages << { id: msg.id, subject: subject }
    end
  rescue => e
    @messages = [{ subject: "エラーが発生しました: #{e.message}", id: nil }]
  end

  def show
    access_token = session[:user_info]["token"]
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = access_token

    message = service.get_user_message('me', params[:id])
    payload = message.payload

    parts = payload.parts || [payload]
    plain_part = parts.find { |part| part.mime_type == 'text/plain' }

    if plain_part && plain_part.body && plain_part.body.data
      encoded_body = plain_part.body.data

      # Base64っぽいかどうかを簡易判定（改行や特殊文字がないか）
      if encoded_body.match?(/\A[a-zA-Z0-9\-_]+=*\z/)
        decoded_body = Base64.urlsafe_decode64(encoded_body)
      else
        decoded_body = encoded_body  # すでにデコード済み
      end
    else
      decoded_body = "本文が見つかりませんでした。"
    end

    @subject = payload.headers.find { |h| h.name == 'Subject' }&.value
    @body = decoded_body
  rescue => e
    @subject = "エラー"
    @body = "本文の取得中にエラーが発生しました: #{e.message}"
  end


  def new
  end

  def send_mail
    access_token = session[:user_info]["token"]
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = access_token

    #temp body cause can't load inside scope
    msg1 = params[:body]

    mailst = Mail.new
    mailst.subject = params[:subject]
    mailst.to = params[:to]
    mailst.from = session[:user_info]["email"]
    # to add your html and plain text content, do this
    mailst.text_part = Mail::Part.new do
      content_type 'text/plain; charset=UTF-8'
      body msg1
    end

    message_to_send = Google::Apis::GmailV1::Message.new(raw: mailst.to_s)
    result = service.send_user_message('me', message_to_send)

    logger.debug "response!!!#{result.inspect}"
  end

end
