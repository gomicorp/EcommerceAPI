module Gomisa
  class UpdateController < BaseController
    include ZohoRequest, ZohoCreateSku
      # GET /gomisa/brands
      # GET /gomisa/brands.json
    def index
      $access_token = get_new_access_token
      res = get_items($access_token)
      items = res['items']
      items = create_items(items)
      @result = { "result" => "successful" }
    end
  end
end
  