json.except! company
json.owner company.owner
json.managers company.memberships do |membership|
  json.except! membership.manager
  json.role membership.role
end
json.brands company.brands
json.url partner_company_url(company, format: :json)
