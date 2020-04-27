# => 컨셉
#
# 1. 동적으로 계산되는 "가격 추론"을 각 테이블에 컬럼으로 캐싱하여 쿼리 및 버저닝 등 에서 성능을 개선합니다. (액티브 레코드의 카운터캐시 기능을 참고했습니다.)
# 2. "추론 체인"을 구성하고 있는 필드 중 하나에서 변경이 감지되는 경우, 해당 내용을 "추론 체인"내 다른 필드들에 자동으로 전파합니다.
# 3. 타임머신을 통해 "추론 체인"의 상태를 특정 시점으로 한꺼번에 체크아웃 할 수 있습니다.
#
#
#
# # 가격 변경 시나리오
#
#
# --------------- 방향 ---------------->
# 상품품목 -- 세트상품 -- 옵션 브릿지 -- 옵션
#        \___________ 옵션 브릿지 _/
#
#
#
#   1. 상품 "품목"의 가격이 변동되면,
#
#   - 해당 "품목"을 가진 "세트상품"도 가격이 변경된다.
#   - 해당 "품목"을 직접 가진 "옵션 브릿지"도 가격이 변경된다.
#
#
#   2. "세트상품"의 가격이 변경되면,
#
#   - 해당 "세트상품"을 직접 가진 "옵션 브릿지"도 가격이 변경된다.
#
#
#   3. "옵션 브릿지"의 가격이 변경되면,
#
#   - 해당 "옵션브릿지"를 가지는 "옵션"도 가격이 변경된다.
#
#
class CalculatePriceColumns < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      PaperTrail.request(enabled: false) do
        ProductCollection.without_callback(:save, :after, :after_save_propagation) do
          ProductCollection.unscoped.all.each do |collection|
            collection.calculate_price_columns
            collection.save!
          end
        end

        ProductOptionBridge.without_callback(:save, :after, :after_save_propagation) do
          ProductOptionBridge.unscoped.all.each do |bridge|
            bridge.calculate_price_columns
            bridge.save!
          end
        end

        ProductOption.without_callback(:save, :after, :after_save_propagation) do
          ProductOption.unscoped.all.each do |product_option|
            product_option.calculate_price_columns
            product_option.save!
          end
        end
      end
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
