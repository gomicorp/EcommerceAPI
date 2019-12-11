json.except! company
json.approve_status company.approve_status
json.owner do
  json.except! company.owner
  json.membership company.ownership
end
json.managers company.memberships do |membership|
  json.except! membership.manager
  json.membership membership
end
json.brands company.brands do |brand|
  json.except! brand
  json.logo brand.logo.attached? ? rails_blob_url(brand.logo) : nil
  json.country brand.country
end
json.url partner_company_url(company, format: :json)
