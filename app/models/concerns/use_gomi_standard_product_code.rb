module UseGomiStandardProductCode

  def self.included(base)
    base.alias_attribute :gspc, :gomi_standard_product_code

    # 루비 오브젝트 생성 시 gspc 를 바로 세팅
    base.after_initialize -> { self.gspc ||= self.gspc_gen }

    # 저장 하면 검증 실행
    base.validates :gspc, presence: true, uniqueness: true

    # 수정은 불가능
    base.validate :forbid_changing_gspc, on: :update

    base.extend ClassMethods
  end

  module ClassMethods
    def gspc_gen
      country_code = default_country_code # 'th' or 'vn'
      is_collection = name == 'ProductCollection' ? 1 : 0

      [
        country_code,
        is_collection.to_s,
        SecureRandom.alphanumeric(10)
      ].join
    end
  end

  def gspc_gen
    self.class.gspc_gen
  end

  private

  def forbid_changing_gspc
    return unless gspc_changed?
    return if gspc_was.nil?

    self.gspc = gspc_was
    errors.add(:gspc, 'can not be changed!')
  end
end
