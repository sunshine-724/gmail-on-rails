# app/helpers/home_helper.rb

module HomeHelper
  # メッセージの本文をデコードするヘルパーメソッド
  def decode_message_body(payload)
    plain_part = find_part_recursively(payload, 'text/plain')
    html_part = find_part_recursively(payload, 'text/html')

    decoded_body = "本文が見つかりませんでした。"

    # ぼっち演算子を使った記述例
    if html_part&.body&.data
        decoded_body = decode_part_body(html_part)
        return decoded_body.html_safe
    elsif plain_part&.body&.data
        decoded_body = decode_part_body(plain_part)
        return decoded_body
    end

    decoded_body
  rescue ArgumentError => e
    # Base64デコードエラーの場合
    Rails.logger.error "Base64 decode error for message body: #{e.message}"
    "本文のデコード中にエラーが発生しました。不正な形式のデータです。"
  end

  private

  # MIMEタイプに基づいてメッセージパートを再帰的に検索するヘルパー
  def find_part_recursively(payload, mime_type)
    if payload.mime_type == mime_type
      return payload
    end

    payload.parts&.each do |part|
      found_part = find_part_recursively(part, mime_type)
      return found_part if found_part
    end
    nil
  end

  # 特定のパートのbodyデータをデコードするヘルパーメソッド
  def decode_part_body(part)
    encoded_body = part.body.data
    transfer_encoding = part.headers.find { |h| h.name == 'Content-Transfer-Encoding' }&.value

    # Content-Transfer-Encoding が "base64" または "quoted-printable" の場合にデコード
    if transfer_encoding == 'base64'
      Base64.urlsafe_decode64(encoded_body)
    else
      # ここでエンコーディングをUTF-8に強制する
      encoded_body.force_encoding('UTF-8')
    end
  end
end