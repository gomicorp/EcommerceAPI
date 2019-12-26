require_relative './zoho_env'

module ZohoRequest
  def send_get_request(hoho, access_token)
    con = Faraday.new
    res = con.get do |req| 
      req.url hoho
      req.headers['Authorization'] = "Zoho-oauthtoken #{access_token}"
      req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    end

    JSON.parse(res.body)
  end

  def zoho_env # => return object
    @zoho_env ||= ZohoEnv.new
  end

  def get_new_access_token
    con = Faraday.new
    res = con.post do |req|
      parameters = {
        refresh_token: zoho_env.refresh_token,
        client_id: zoho_env.client_id,
        client_secret: zoho_env.client_secret,
        grant_type: :refresh_token
      }

      req.url zoho_env.url_scope(zoho_env.new_access_token_url, parameters)
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'
    end

    JSON.parse(res.body)['access_token']
  end

  def get_organizations(access_token)
    url = zoho_env.organizations_url
    send_get_request(url, access_token)
  end


  # item # index
  def get_items(access_token, page)
    url = zoho_env.items_url(
      organization_id: zoho_env.organization_id,
      page: page
    )
    send_get_request(url, access_token)
  end

  # item # show
  def get_item(access_token, id)
    url = zoho_env.item_url(
      id,
      organization_id: zoho_env.organization_id
    )
    send_get_request(url, access_token)
  end

  # composite item # index
  def get_composite_items(access_token, page)
    url = zoho_env.composite_items_url(
      organization_id: zoho_env.organization_id,
      page: page
    )
    send_get_request(url, access_token)
  end

  # composite item # show
  def get_composite_item(access_token, id)
    url = zoho_env.composite_item_url(
      id,
      organiztion_id: zoho_env.organization_id
    )
    send_get_request(url, access_token)
  end

  # item groups # index
  def get_item_groups(access_token, page)
    url = zoho_env.item_groups_url(
      organization_id: zoho_env.organization_id,
      page: page
    )
    send_get_request(url, access_token)
  end

  # date 기준으로 필터링 가능
  def get_actions(access_token, page)
    url = zoho_env.adjustments_url(
      organization_id: zoho_env.organization_id,
      page: page
    )
    send_get_request(url, access_token)
  end

  def get_action(access_token, id)
    url = zoho_env.adjustment_url(
      id,
      organization_id: zoho_env.organization_id
    )
    send_get_request(url, access_token)
  end
end
