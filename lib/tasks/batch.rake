# 주요 비즈니스 로직을 매뉴얼하게 실행할 수 있는 장치입니다.

namespace :batch do
  desc '배송완료 처리가 필요한 배송건들을 훑어 배송현황을 조회하고, 완료된 배송건은 배송완료 처리를 합니다.'
  task track_shipping_complete: :environments do
    ship_infos = ShipInfo.where(current_status: ShipInfo::StatusLog.where(code: 'ship_ing'))
    agent = Store::GomiBranch::ShippingManager.new

    agent.update_tracking_info(ship_infos.where.not(carrier_code: nil)) || raise('배송 완료 처리 실패. 망함.')
  end
end
