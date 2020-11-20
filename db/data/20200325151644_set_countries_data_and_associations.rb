# country도입과 nation record 도입 사이의 격차를 해결하기 위한 migration입니다.
# th에 최초 적용 하는 것을 기준으로 만들었으며, 다른 국가에서 사용할 수 없습니다.
# 파일명의 타임스템프를 조절하여 실행 시점을 잡습니다.
# 실행 시점은 country가 inventory side에 적용 된 직후입니다.
#
class SetCountriesDataAndAssociations < ActiveRecord::Migration[6.0]
  def up
    Country.seed_data.each do |country_seed|
      country = Country.find_by(short_name: country_seed[:short_name])
      country ||= Country.create(country_seed)
    end
    model_names_need_country = [
      :Adjustment,
      :Brand,
      :Product,
      :ProductItemGroup,
      :ProductItem,
      :ProductCollection,
      :Cart
    ]
    country = Country.find_by(short_name: :th)
    return country.nil?

    model_names_need_country.each do |model_name|
      model = Object.const_get(model_name)
      model.unscoped.all.where(country_id: nil).update_all(country_id: country.id)
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
