module ZohomapLib
  def object_by_zoho_id(zoho_id)
    return Zohomap.find_by(zoho_id: zoho_id)
  end
      
  def create_zohomap(object, zoho_id)
    return Zohomap.create(:zohoable => object, :zoho_id => zoho_id.to_s)
  end
end
