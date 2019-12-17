module ZohoCreateSku
  def get_or_create_brand(name)
    brand = Brand.find_by(name: name)
    if brand == nil
      brand = Brand.create
      brand[:name] = name
      brand.save
    end
    return brand
  end
  
  def get_or_create_product_item_group(brand, name, id)
    object = brand.product_item_groups.find_by_id(id=id)

    if object == nil
      object = brand.product_item_groups.create(:id => id)
      object[:name] = name
      object.save
    end
    return object
  end

  def get_or_create_product_attributes(product_item_group, infos)
    #id 배열 뽑아내고
    ids = infos.select{|k, v| k =~ /^(?=.*id).*/}.values

    #name 배열 뽑아내고
    names = infos.select{|k, v| k =~ /^(?=.*name).*/}.values

    #새롭거나 이미 만들어진 attribute를 반환하고
    #attributes에 push한다.
    objects = []
    ids.each_with_index do |id, index|
      if id != ""
        object = get_or_create_product_attribute(product_item_group, id, names[index])
        objects.push(object)
      end
    end
    
    #완성된 attributes를 반환한다
    return objects
  end

  def get_or_create_product_attribute(product_item_group, id, name)
    # find product_attribute
    object = ProductAttribute.find_by_id(id=id)

    # if not found, create new product_attribute
    if object == nil
      object = ProductAttribute.create(:id => id)
      object[:name] = name
      object.save
    end
    
    # create many to many relation
    get_or_create_product_attribute_product_item_group(object, product_item_group)

    return object
  end

  def get_or_create_product_attribute_product_item_group(product_attribute, product_item_group)
    # find product_attribute_product_item_group
    object = product_item_group.product_attributes.find_by_id(id=product_attribute[:id])

    if object == nil
      ProductAttributeProductItemGroup.create(
        :product_item_group_id => product_item_group[:id], 
        :product_attribute_id => product_attribute[:id]
      )
    end
    return object
  end

  def get_or_create_product_attribute_options(product_attributes, infos)
    #id 배열 뽑아내고
    ids = infos.select{|k, v| k =~ /^(?=.*id).*/}.values

    #name 배열 뽑아내고
    names = infos.select{|k, v| k =~ /^(?=.*name).*/}.values

    #새롭거나 이미 만들어진 option를 반환하고
    #options에 push한다.
    objects = []
    ids.each_with_index do |id, index|
      if id != ""
        object = get_or_create_product_attribute_option(product_attributes[index], id, names[index])
        objects.push(object)
      end
    end
    
    #완성된 attributes를 반환한다
    return objects
  end

  def get_or_create_product_attribute_option(product_attribute, id, name)
    object = product_attribute.options.find_by_id(id=id)

    if object == nil
      object = product_attribute.options.create(:id => id)
      object[:name] = name
      object.save
    end
    return object
  end
  
  def create_product_item(product_item_group, id, name)
    object = product_item_group.items.create(:id => id)
    object[:name] = name
    object.save

    # options.each do |option|
    #   ProductItemProductOption.create(
    #     :product_item_id => object[:id], 
    #     :product_option_id => option[:id]
    #   )
    # end
    
    return object
  end
    
  # item(sku)를 생성한다.
  def create_product_item_procedure(item)
    # example: "name": "그라펜-스킨-100ml/동그라미"
    brand_name, product_item_group_name, options = item["name"].split('-') 

    # brand 저장후 반환 (ㅇ)
    brand = get_or_create_brand(name=brand_name)

    # product 저장후 반환 (ㅇ)
    product_item_group = get_or_create_product_item_group(brand, name=product_item_group_name, item["group_id"])

    # options이 존재할때만 아래 과정 수행 (ㅇ)
    if options != ""
      # attributes 저장후 반환 (ㅇ)
      attribute_infos = item.select{|k, v| k =~ /^(?=.*attribute)(?!.*option).*/}
      product_attributes = get_or_create_product_attributes(product_item_group, attribute_infos)

      # attribute_option 저장 (ㅇ)
      product_attribute_option_infos = item.select{|k, v| k =~ /^(?=.*attribute)(?=.*option).*/}
      product_attribute_options = get_or_create_product_attribute_options(product_attributes, product_attribute_option_infos)
    end

    #sku 생성후 반환
    product_item = create_product_item(product_item_group, item["item_id"], item["name"])
    return product_item
  end
    
  # 현재 item이 존재하는지 확인한다
  def check_existed_product_item(id)
    product_item = ProductItem.find_by_id(id=id)
    if product_item
      return product_item
    else
      return nil
    end
  end

  # item(sku)들을 생성한다.
  def create_items(items)
    objects = []
    items.each do |item|  
      # item 유뮤 확인
      product_item = check_existed_product_item(item["item_id"])

      # item 없으면 create, 있으면 update
      if product_item == nil
        object = create_product_item_procedure(item)
        objects.push(object)
      else
        objects.push(product_item)
        # update_item(sku, item)
      end
    end
    return objects
  end
end
