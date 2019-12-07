json.except! company
json.owner do
  json.except! company.owner
  json.membership company.ownership
end
json.managers company.memberships do |membership|
  json.except! membership.manager
  json.membership membership
end
json.brands company.brands
json.url partner_company_url(company, format: :json)
