module Api
  module V1
    module ErrorHandler

      ERROR_ALIAS_MAP = {
        bad_request: 400,
        forbidden: 403,
        not_found: 404,
      }.freeze

      def self.included(base)
        base.include MethodFactory
        base.include RescueMethods
      end


      module RescueMethods
        def self.included(base)
          base.instance_exec do
            unless Rails.application.config.consider_all_requests_local
              rescue_from ActionController::RoutingError, with: :render_not_found
            end
            rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
            rescue_from ActionController::RoutingError, with: :render_forbidden
          end
        end
      end


      module MethodFactory
        def self.included(base)
          base.extend ClassMethods
          base.rendering_error_method_factory ERROR_ALIAS_MAP
        end

        module ClassMethods
          # 에러 랜더링 메소드를 찍어내는 공장입니다.
          #
          # dispatcher 는 해시 테이블이고, 키로는 에러의 상태메세지를 값으로는 에러의 상태코드를 가집니다.
          #
          # ===
          #
          # 만약 아래와 같이 dispatcher 가 입력된다면:
          #
          #   dispatcher = {
          #     not_found: 404
          #   }
          #
          #   rendering_error_method_factory(dispatcher)
          #
          # 실행의 결과로 다음과 같은 코드를 생산합니다.
          #
          #   def render_not_found(exception)
          #     render json: exception, status: :not_found
          #   end
          #   alias_method :render_404, :render_not_found
          #
          def rendering_error_method_factory(dispatcher)
            dispatcher.keys.each do |response_status|
              method_name_by_word = "render_#{response_status}"
              method_name_by_code = "render_#{dispatcher[response_status]}"

              define_method method_name_by_word do |exception|
                render json: exception, status: response_status
              end

              alias_method method_name_by_code, method_name_by_word
            end
          end
        end
      end
    end
  end
end