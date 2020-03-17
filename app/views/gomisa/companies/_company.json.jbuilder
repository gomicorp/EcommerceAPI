json.except! company
json.url gomisa_company_url(company, format: :json)
json.brand_counts company.brands.count
