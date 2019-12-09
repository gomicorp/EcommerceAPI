json.except! brand
json.logo brand.logo.attached? ? rails_blob_url(brand.logo) : nil
json.country brand.country
json.company brand.company
json.url partner_brand_url(brand, format: :json)
