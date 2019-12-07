json.except! manager
json.companies manager.memberships do |membership|
  json.except! membership.company
  json.membership membership
end
json.url partner_manager_url(manager, format: :json)
