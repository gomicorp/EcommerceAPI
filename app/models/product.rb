# == Schema Information
#
# Table name: products
#
#  id                :bigint           not null, primary key
#  barcode_count     :integer          default(0), not null
#  price             :integer          default(0), not null
#  running_status    :integer          default("pending"), not null
#  slug              :string(255)
#  title             :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  brand_id          :bigint
#  country_id        :bigint
#  default_option_id :bigint
#
# Indexes
#
#  index_products_on_brand_id           (brand_id)
#  index_products_on_country_id         (country_id)
#  index_products_on_default_option_id  (default_option_id)
#  index_products_on_slug               (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (default_option_id => product_options.id)
#
class Product < NationRecord
  include Translatable
  extend FriendlyId
  extend_has_one_attached :thumbnail
  extend_has_many_attached :images
  extend_has_many_attached :catalogs
  translate_column :title
  friendly_id :slug_candidates, use: %i[slugged finders history]

  RUNNING_STATUSES = {
    pending: '판매대기',
    running: '판매 중',
    paused: '판매중지',
    sold_out: '품절',
    stopped: '판매종료'
  }.freeze
  enum running_status: RUNNING_STATUSES.keys

  has_many :product_mappers, class_name: 'ExternalChannel::ProductMapper', dependent: :destroy

  belongs_to :brand

  belongs_to :country
  has_many :option_groups, class_name: 'ProductOptionGroup', dependent: :destroy
  has_many :options, through: :option_groups
  belongs_to :default_option, class_name: 'ProductOption', optional: true

  has_many :barcodes, dependent: :destroy
  has_many :product_categories, class_name: 'ProductCategory', dependent: :destroy
  has_many :categories, through: :product_categories

  has_many :product_permits, dependent: :destroy

  has_one :seo_application, as: :page, required: false, dependent: :destroy

  scope :running, -> { where.not(running_status: %w[pending paused stopped]) }

  def say_running_status
    self.class.running_statuses[running_status.to_sym]
  end

  def self.running_statuses
    RUNNING_STATUSES
  end

  # ============================================================================
  #   재고 복구 기능만을 위한 메소드 입니다.
  #
  #
  def barcode_groups
    @barcode_groups ||= barcode_grouping
  end

  def alive_barcode_count
    barcode_groups.map(&:alive_barcode_count).sum
  end

  def barcode_grouping
    codes = barcodes.includes(:product_options)
    g = {}
    codes.each do |barcode|
      option_ids = barcode.product_options.ids
      g[option_ids] ||= []
      g[option_ids] << barcode.id
    end

    res = []
    g.each do |option_ids, barcode_ids|
      res << BarcodeGroup.new(self, option_ids, barcode_ids)
    end

    res
  end
  #
  #
  #   재고 복구 기능만을 위한 메소드 입니다.
  # ============================================================================

  def has_permitted?
    return false if product_permits.empty?

    product_permits.last.permitted_at.present?
  end

  def discounted?
    discount.present?
  end

  def discount
    nil
    # return nil unless !(id % 2).zero?
    #
    # Discount.new(price_original, 0, 20)
  end

  def price_original
    self['price']
  end

  def price
    return @_price unless @_price.nil?

    result = price_original
    result = discount.after_price if discounted?

    @_price ||= result
  end

  def update_barcode_cache
    update(barcode_count: barcodes.alive.count)
  end

  def slug_candidates
    [
      :translated_title,
      [:translated_title, :slug_sequence]
    ]
  end

  def translated_title
    translate(locale: country.locale).title
  end

  def slug_sequence
    column = friendly_id_config.slug_column
    separator = friendly_id_config.sequence_separator
    slug = normalize_friendly_id(send(slug_candidates.first))
    self.class.where("#{column} LIKE ?", "#{slug}%").count + 1
  end

  class Discount
    attr_reader :discount_type, :discount_value
    attr_reader :original_price

    ENUM_TYPE = %w[rate amount].freeze

    def initialize(original_price, discount_type = 0, discount_value)
      @original_price = original_price
      @discount_type = ENUM_TYPE[discount_type] || discount_type
      @discount_value = discount_value
    end

    # To be method
    def after_price
      @after_price ||= calculate.to_i
    end

    # To be decoration method
    def label
      percentage = if discount_type == 'rate'
                     discount_value
                   else
                     (discount_value * 0.1 / original_price) * 100
                   end

      "#{percentage.to_i}%"
    end

    private

    # To be method
    def calculate
      discount_amount = case discount_type.to_sym
                        when :rate
                          original_price * (discount_value * 0.01)
                        when :amount
                          discount_value
                        else
                          raise "Invalid discount type (discount_type: #{discount_type})"
                        end

      original_price - discount_amount
    end
  end
end
