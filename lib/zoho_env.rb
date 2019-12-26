# # items index
# def items_url(**params)
#   path = [inventory_api, 'items'].join('/')
#   url_scope path, **params
# end
#
# # items show
# def item_url(id, **params)
#   path = [items_url, id].join('/')
#   url_scope path, **params
# end
#
# # composite_items index
# def composite_items_url(**params)
#   path = [inventory_api, 'compositeitems'].join('/')
#   url_scope path, **params
# end
#
# # composite_items show
# def composite_item_url(id, **params)
#   path = [composite_items_url, id].join('/')
#   url_scope path, **params
# end
#
# # item_groups index
# def item_groups_url(**params)
#   path = [inventory_api, 'itemgroups'].join('/')
#   url_scope path, **params
# end
#
# # item_groups show
# def item_group_url(id, **params)
#   path = [item_groups_url, id].join('/')
#   url_scope path, **params
# end
#
# # adjustments index
# def adjustments_url(**params)
#   path = [inventory_api, 'inventoryadjustments'].join('/')
#   url_scope path, **params
# end
#
# # adjustments show
# def adjustment_url(id, **params)
#   path = [adjustments_url, id].join('/')
#   url_scope path, **params
# end
#
class ZohoEnv
  attr_reader :client_id, :client_secret
  attr_reader :refresh_token, :organization_id

  def initialize
    @client_id = ENV['ZOHO_CLIENT_ID']
    @client_secret = ENV['ZOHO_CLIENT_SECRET']
    @refresh_token = ENV['ZOHO_REFRESH_TOKEN']
    @organization_id = ENV['ZOHO_ORGAINZATION_ID']
  end

  def new_access_token_url
    api_hosts[:accounts] + '/token'
  end

  # Generate Query String
  #
  # query_string(object_id: 1, page: 3)
  # => "object_id=1&page=3"
  def query_string(**params)
    params.map { |k, v| [k, v].join('=') }.join('&')
  end

  def url_scope(path, **params)
    [path, query_string(**params).presence].compact.join('?')
  end

  def self.generate_resources_url(resource_name, endpoint)
    class_eval %Q(
      def #{resource_name}_url(**params)
        path = [inventory_api, '#{endpoint}'].join('/')
        url_scope path, **params
      end
    )
  end

  def self.generate_resource_url(resource_name)
    class_eval %Q(
      def #{resource_name}_url(id, **params)
        path = [#{resource_name.to_s.pluralize}_url, id].join('/')
        url_scope path, **params
      end
    )
  end

  # Generate [Index] Endpoint for resources
  {
    organizations: 'organizations',
    items: 'items',
    composite_items: 'compositeitems',
    item_groups: 'itemgroups',
    adjustments: 'inventoryadjustments'
  }.each do |resource, endpoint|
    generate_resources_url(resource, endpoint)
  end

  # Generate [Show] Endpoint for resources
  %i[item composite_item item_group adjustment].each do |resource|
    generate_resource_url(resource)
  end


  private

  def api_hosts
    {
      inventory: 'https://inventory.zoho.com/api/v1',
      accounts: 'https://accounts.zoho.com/oauth/v2'
    }
  end

  def inventory_api
    api_hosts[:inventory]
  end
end
