module ZohoRequest
  def send_get_request(hoho, access_token)
    con = Faraday.new
    res = con.get do |req| 
      req.url hoho
      req.headers['Authorization'] = "Zoho-oauthtoken #{access_token}"
      req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    end
  
    return JSON.parse(res.body)
  end

  def get_new_access_token
    con = Faraday.new
    res = con.post do |req| 
    req.url "https://accounts.zoho.com/oauth/v2/token?refresh_token=#{ENV['ZOHO_REFRESH_TOKEN']}&client_id=#{ENV['ZOHO_CLIENT_ID']}&client_secret=#{ENV['ZOHO_CLIENT_SECRET']}&grant_type=refresh_token"
      req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    end
  
    return JSON.parse(res.body)["access_token"]
  end

  def get_organizations(access_token)
    url = "https://inventory.zoho.com/api/v1/organizations"
    return send_get_request(url, access_token)
  end

  def get_item(access_token, id)
    url = "https://inventory.zoho.com/api/v1/items/#{id}?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    return send_get_request(url, access_token)
  end

  def get_composite_item(access_token, id)
    url = "https://inventory.zoho.com/api/v1/compositeitems/#{id}?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    return send_get_request(url, access_token)
  end

  def get_composite_items(access_token)
    url = "https://inventory.zoho.com/api/v1/compositeitems?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    return send_get_request(url, access_token)
  end

  def get_items(access_token)
    url = "https://inventory.zoho.com/api/v1/items?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}&created_time=2019-12-30"
    return send_get_request(url, access_token)

    # con = Faraday.new
    # res = con.get do |req| 
    #   req.url "https://inventory.zoho.com/api/v1/items?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}&created_time=2019-12-30"
    #   req.headers['Authorization'] = "Zoho-oauthtoken #{access_token}"
    #   req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    # end
    
    # return JSON.parse(res.body)
  end

  def get_item_groups(access_token)
    url = "https://inventory.zoho.com/api/v1/itemgroups?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    return send_get_request(url, access_token)

    # con = Faraday.new
    # res = con.get do |req| 
    #   req.url "https://inventory.zoho.com/api/v1/itemgroups?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    #   req.headers['Authorization'] = "Zoho-oauthtoken #{access_token}"
    #   req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    # end
    
    # return JSON.parse(res.body)
  end

  # date 기준으로 필터링 가능
  def get_actions(access_token)
    url = "https://inventory.zoho.com/api/v1/inventoryadjustments?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    return send_get_request(url, access_token)

    # con = Faraday.new

    # res = con.get do |req| 
    #   req.url "https://inventory.zoho.com/api/v1/inventoryadjustments?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    #   req.headers['Authorization'] = "Zoho-oauthtoken #{access_token}"
    #   req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    # end
    
    # return JSON.parse(res.body)
  end

  def get_action(access_token, id)
    url = "https://inventory.zoho.com/api/v1/inventoryadjustments/#{id}?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    return send_get_request(url, access_token)

    # con = Faraday.new
    # res = con.get do |req| 
    #   req.url "https://inventory.zoho.com/api/v1/inventoryadjustments/#{id}?organization_id=#{ENV['ZOHO_ORGAINZATION_ID']}"
    #   req.headers['Authorization'] = "Zoho-oauthtoken #{access_token}"
    #   req.headers['Content-Type'] = ' application/x-www-form-urlencoded;charset=UTF-8'
    # end
    
    # return JSON.parse(res.body)
  end
end
