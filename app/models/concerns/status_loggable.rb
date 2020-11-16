module StatusLoggable
  extend ActiveSupport::Concern

  def self.included(model)
    model.extend ClassMethods
  end

  module ClassMethods
    def act_as_status_loggable(**option)
      loggable_model_name = self.name
      loggable_table_name = self.table_name
      status_code_class_name, status_log_class_name = make_class_names(loggable_model_name)

      # 결과적으로, `enum name: value` 구문의 'value'로서 동작하게 됩니다.
      # 따라서, enum 실행에서 받을 수 있도록 정의된 모든 형태의 value 활용을 지원합니다.
      # ref: https://naturaily.com/blog/ruby-on-rails-enum
      status_list = option.dig(:status_list) || raise("#{loggable_model_name}.act_as_status_loggable 에서 정의된 :status_list 값이 없습니다.")

      declare_loggable_model_method status_log_class_name
      declare_loggable_status_code_class loggable_model_name, status_log_class_name, status_list
      declare_loggable_status_log_class loggable_model_name, loggable_table_name, status_code_class_name

      make_update_status_method status_code_class_name
    end


    private

    def make_class_names(loggable_model_name)
      %W[#{loggable_model_name}::StatusCode #{loggable_model_name}::StatusLog]
    end

    # ShipInfo.last.status_logs.create(status_code: ShipInfo::StatusCode.find_by(name: 'stage2'))
    # 이게 너무 긴게 문제입니다.
    def make_update_status_method(status_code_class_name)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def update_status(code_name)
          status_logs.create(status_code: #{status_code_class_name}.find_by_name(code_name))
        end
      CODE
    end

    def declare_loggable_model_method(status_log_class_name)
      has_many :status_logs, class_name: status_log_class_name, as: :loggable

      has_one :current_status, -> { order(id: :desc).limit(1) }, class_name: status_log_class_name, as: :loggable
    end

    def declare_loggable_status_code_class(loggable_model_name, status_log_class_name, code_names = [])
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        class StatusCode < ::StatusCode
          enum name: #{code_names}
          has_many :status_logs, class_name: "#{status_log_class_name}"

          default_scope { where(domain_type: "#{loggable_model_name}") }
        end
      CODE
    end

    def declare_loggable_status_log_class(loggable_model_name, loggable_table_name, status_code_class_name)
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        class StatusLog < ::StatusLog
          belongs_to :status_code, class_name: "#{status_code_class_name}"
          alias_attribute :"#{loggable_table_name.singularize}", :loggable

          default_scope { where(loggable_type: "#{loggable_model_name}") }
        end
      CODE
    end
  end
end
