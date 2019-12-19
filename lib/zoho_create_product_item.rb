module ZohoCreateProductItem
  #brand를 반환한다.
  def get_or_create_brand(name)
    brand = Brand.find_by(name: name)
    if brand == nil
      brand = Brand.new
      brand[:name] = name
      brand.save
    end
    return brand
  end
    
  # get_product_item_group
  # product_item_group을 만들거나 반환한다.
  def get_or_create_product_item_group(brand, name, id)
    object = brand.product_item_groups.find_by_id(id=id)
  
    if object == nil
      object = brand.product_item_groups.new(:id => id)
      object[:name] = name
      object.save
    end
  
    return object
  end
  
  # product_attribute들을 만들거나 반환한다.
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
  
  # product_attribute를 만들거나 반환한다.
  def get_or_create_product_attribute(product_item_group, id, name)
    # find product_attribute
    object = ProductAttribute.find_by_id(id=id)
  
    # if not found, create new product_attribute
    if object == nil
      object = ProductAttribute.new(:id => id)
      object[:name] = name
      object.save
    end
  
    get_or_create_product_attribute_product_item_group(object, product_item_group)
  
    return object
  end
  
  # product_attribute, product_item_group사이의 관계 테이블에 행을 추가한다.
  def get_or_create_product_attribute_product_item_group(product_attribute, product_item_group)
    object = product_item_group.product_attributes.find_by_id(id=product_attribute[:id])
  
    if object == nil
      ProductAttributeProductItemGroup.create(
        :product_item_group_id => product_item_group[:id], 
        :product_attribute_id => product_attribute[:id]
      )
    end
    return object
  end
  
  #product_attribute_option들을 추가하거나 업데이트 한다.
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
  
  #product_attribute_option을 추가한다
  def get_or_create_product_attribute_option(product_attribute, id, name)
    object = product_attribute.options.find_by_id(id=id)
  
    if object == nil
      object = product_attribute.options.new(:id => id)
      object[:name] = name
      object.save
    end
  
    return object
  end

  # product_item 들을 생성한다.
  def create_product_items(items)
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
      end
    end

    return objects
  end  

  # 현재 product_item이 존재하는지 확인한다
  def check_existed_product_item(id)
    product_item = ProductItem.find_by_id(id=id)
    if product_item
      return product_item
    else
      return nil
    end
  end

  #product_item을 추가하는 절차
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

    #product_item 생성후 반환
    product_item = create_product_item(product_item_group, item["item_id"], item["name"])
    return product_item
  end

  #product_item을 추가한다.
  def create_product_item(product_item_group, id, name)
    object = product_item_group.items.new(:id => id)
    object[:name] = name
    object.save
    return object
  end
end
