require 'google/apis/gmail_v1'
require 'googleauth'
require 'base64'
require 'mail'

class HomeController < ApplicationController
  include HomeHelper #明示的にロード

  #各主要アクション前に認証情報の確認を実施
  before_action :check_session_info, only: %i[ index show send_mail]

  
  #メール一覧表示
  def index
    #メールヘッダの取得、表示
    @messages = []
    begin
      result = @service.list_user_messages('me', max_results: 15)
      result.messages&.each do |msg|
        message = @service.get_user_message('me', msg.id)
        headers = message.payload.headers
        subject = headers.find { |h| h.name == 'Subject' }&.value
        from = headers.find { |h| h.name == 'From' }&.value
        date = headers.find { |h| h.name == 'Date' }&.value
        @messages << { id: msg.id, subject: subject, from: from, date: date }
      end
    rescue => e
      #Google API以外のruby側のエラー
      @messages = [{ subject: "エラーが発生しました: #{e.message}", id: nil }]
      logger.error "Error in index action: #{e.message}"
    end
  end

  #メール内容の表示
  def show

    #メール表示内容の処理
    begin
      #メール情報を取得
      message = @service.get_user_message('me', params[:id])
      payload = message.payload

      #ヘッダを分解
      @subject = payload.headers.find { |h| h.name == 'Subject' }&.value
      @from = payload.headers.find { |h| h.name == 'From' }&.value
      @date = payload.headers.find { |h| h.name == 'Date' }&.value

      #本文をデコード(ヘルパーメソッド)
      @body = decode_message_body(payload)
    #rescue => e
    #  @subject = "エラー"
    #  @body = "本文の取得中にエラーが発生しました: #{e.message}"
    #  logger.error "Error in show action: #{e.message}"
    end
  end

  #ビュー定義
  def new
  end

  #メール送信メソッド
  def send_mail

    #メール構造の構成
    mail = Mail.new
    mail.subject = params[:subject]
    mail.to = params[:to]
    mail.from = session[:user_info]["email"]

    #プレーンテキストとHTMLの対応

    # params[:body] の値を一時変数に代入
    body_content_plain = params[:body] if params[:body].present?
    # params[:html_body] の値を一時変数に代入
    body_content_html = params[:html_body] if params[:html_body].present?
    if params[:body].present?
      mail.text_part = Mail::Part.new do
        content_type 'text/plain; charset=UTF-8'
        body body_content_plain
      end
    end
    #body_temp_html = body params[:html_body] 
    #HTMLが含まれている場合の処理
    if params[:html_body].present? 
      mail.html_part = Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body body_content_html
      end
    end 

    message_to_send = Google::Apis::GmailV1::Message.new(raw: mail.to_s)

    #送信処理
    begin
      result = @service.send_user_message('me', message_to_send)
      logger.debug "Mail sent Successfully"
      flash[:notice] = "メールが正常に送信されました!"
      redirect_to home_path #メール一覧画面へ遷移
    rescue => e
      flash[:alert] = "予期せぬエラーが発生しました"
      logger.error "Unexpected error sending mail: #{e.message}"
      redirect_to new_mail_path
    end
  end
  private
    # セッション情報の確認
    def check_session_info
      unless session[:user_info]&.key?("token")
        flash[:alert] = "認証情報がありません。再度ログインしてください。"
        redirect_to root_path and return
      end
      access_token = session[:user_info]["token"]
      @service = Google::Apis::GmailV1::GmailService.new
      @service.authorization = access_token
    end
end
