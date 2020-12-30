# Draper::Decorator 로부터 한 단계 레이어를 추가하기 위한 클래스 입니다.
# 기본적으로 모델 추상 데코레이터(CompanyDecorator 등)의 부모 클래스로서 동작합니다.
# 따라서 모든 모델 데코레이터에 대해 동일한 기능을 갖는 메소드들이 모여있게 됩니다.

require_relative './concerns/data_field_collectable'

class ApplicationDecorator < Draper::Decorator
  include DataFieldCollectable
  # decorates_finders

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
