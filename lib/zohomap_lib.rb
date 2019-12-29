module ZohomapLib
  def object_by_zoho_id(zoho_id)
    Zohomap.find_by(zoho_id: zoho_id)
  end

  def create_zohomap(object, zoho_id, zoho_updated_at)
    Zohomap.create(
      :zohoable => object, 
      :zoho_id => zoho_id.to_s,
      :zoho_updated_at => zoho_updated_at
    )
  end

  def update_zohomap(zoho_id, zoho_updated_at)
    zoho_object = object_by_zoho_id(zoho_id)
    zoho_object[:zoho_updated_at] = zoho_updated_at
    zoho_object.save
  end
end
