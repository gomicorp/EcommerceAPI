module Haravan
  class WebhookController < ApplicationController
    include Haravan::ApiService
    include Haravan::ApiService::HaravanProduct

    skip_before_action :verify_authenticity_token

    def regist
      if webhook_regist_params['hub.verify_token'] == Rails.application.credentials.dig(:haravan, :webhook, :verify_token)
        render status: 200, plain: webhook_regist_params['hub.challenge']
      else
        render status: 401, plain: 'Unmatched Verify Code'
      end
    end

    def logged_in
      if verify_id_token
        render status: 200, plain: 'Login Success'
      else
        render status: 401, plain: 'Wrong ID Token'
      end
    end

    def installed
      if verify_id_token
        token = request_access_token(code_params['code']).to_hash

        request_subscribe token[:access_token]

        render status: 200, plain: 'subscribe success'
      else
        render status: 401, plain: 'Wrong ID Token'
      end
    end

    def webhooking
      if verify_sender(request)
        webhook = HaravanWebhook.create

        case request.headers['x-haravan-topic']
        when 'products/create', 'products/update'
          webhook.update(table_name: 'products', event_name: "#{request.headers['x-haravan-topic'].gsub('products/', '')}", haravan_id: product_params[:id])
          # == 하라반에서 생성 / 수정한 상품의 브랜드가 고미 DB에 있어야만 정상적으로 작동합니다.
          # == 상품을 find_or_initialize 하기 때문에 create / update 두 이벤트에 모두 적용 가능합니다.
          save_haravan_products(product_params) ? webhook.update(is_applied: true) : webhook.update(is_applied: false)
        when 'products/deleted'
          webhook.update(table_name: 'products', event_name: 'deleted', haravan_id: product_params[:id])

          Product.find_by(haravan_id: product_params[:id].to_s).destroy ? webhook.update(is_applied: true) : webhook.update(is_applied: false)
        end

        render status: 200, plain: 'success'
        #= 비정상적인 접근(데이터, 권한)일 경우 에러코드 반환


        #= 로직 수행
      else
        render status: 401, plain: 'hacked data'
      end
    end

    private

    def webhook_regist_params
      params.permit('hub.verify_token', 'hub.challenge')
    end

    def code_params
      params.permit('code', 'id_token')
    end

    def access_token_params
      params.permit('access_token')
    end

    def product_params
      params.permit(:id, :title, :vendor, variants: [:title, :id, :price])
    end

    def verify_id_token
      JWT.decode(code_params['id_token'], nil, false, { algorithm: 'RS256'})[0]['orgid'] == Rails.application.credentials.dig(:haravan, :orgid).to_s
    end

    def verify_sender(request)
      key = 'b4c7c0880aa766bd4f39d5be2246b70b837821736115af132a41d2a9a8e6bf12'
      data = request.body.string
      digest = OpenSSL::Digest.new('sha256')

      Base64.encode64(OpenSSL::HMAC.digest(digest, key, data)).strip() == request.headers['x-haravan-hmacsha256']
    end

    def request_access_token(code)
      client = OAuth2::Client.new('158345fb41b1f7e8491fe7b810a451e7',
                                  'b4c7c0880aa766bd4f39d5be2246b70b837821736115af132a41d2a9a8e6bf12',
                                  site: 'https://accounts.haravan.com')
      client.options[:authorize_url]= '/connect/authorize'
      client.options[:token_url]= '/connect/token'

      client.auth_code.authorize_url(redirect_uri: 'https://782ad929e6df.ngrok.io/haravan/webhook/installed')

      client.auth_code.get_token(code,
                                 client_id: '158345fb41b1f7e8491fe7b810a451e7',
                                 client_secret: 'b4c7c0880aa766bd4f39d5be2246b70b837821736115af132a41d2a9a8e6bf12',
                                 redirect_uri: 'https://782ad929e6df.ngrok.io/haravan/webhook/installed')
    end

    def request_subscribe(access_token)
      url = URI.parse('https://webhook.haravan.com/api/subscribe')

      req = Net::HTTP::Post.new(url.path)
      req.add_field('Content-Type', 'application/json')
      req.add_field('Authorization', "Bearer #{access_token}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.start {|h| h.request(req)}
    end
  end
end
