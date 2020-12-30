module Companies
  class WithBrandDecorator < DefaultDecorator
    delegate_all

    # TODO: 기본적으로 자기 원본 레코드의 전체 키를 사용하는 방법을 명시적으로 추가할 필요가 있을 것 같습니다.
    data_keys_from_model :company, except: %i[created_at updated_at]
    data_key :brands, with: Brands::DefaultDecorator
  end
end
