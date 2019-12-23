module Gomisa
  class UpdateController < BaseController
    include ZohoRequest, ZohoManageProductItem, ZohoManageAdjustment, ZohoManageCompositeItem

    before_action :set_access_token, only: :index
    
    # GET /gomisa/updates.json
    def index
      flag = true
      page = 1
      while(flag)
        res = get_items(access_token, page)
        flag = res['page_context']['has_more_page']
        page = page + 1
        items = res['items']
        items = create_or_update_product_items(items)
      end

      flag = true
      page = 1
      while(flag)
        res = get_composite_items(access_token, page)
        flag = res['page_context']['has_more_page']
        page = page + 1
        datas = res['composite_items']
        items = create_composite_items(datas, access_token)
      end

      flag = true
      page = 1
      while(flag)
        res = get_actions(access_token, page)
        flag = res['page_context']['has_more_page']
        page = page + 1
        datas = res['inventory_adjustments']
        items = create_adjustments(datas)
      end

      @result = { "result" => "successful" }
    end

    private

    def access_token
      $access_token ||= set_access_token
    end

    def set_access_token
      $access_token = refresh_access_token
    end

    def refresh_access_token
      get_new_access_token
    end
  end
end
