module Haravan
  module Api
    module PageCollectable
      def original_collection
        @original_collection ||= []
      end

      def store_originals(dataset)
        @original_collection = original_collection + dataset
      end

      def collect_page_in_row(**option)
        collection = []

        page = 1
        collected = query_with_root_key(page: page, **option)
        collection = collection + collected
        Rails.logger.debug "페이지: #{page}, 찾음: #{collected.length}, 누적: #{collection.length} / Query: #{option}"

        while collected.any?
          page += 1
          collected = query_with_root_key(page: page, **option)
          collection = collection + collected
          Rails.logger.debug "페이지: #{page}, 찾음: #{collected.length}, 누적: #{collection.length} / Query: #{option}"
        end


        collection
      end

      def collect_page(page: 1, step: 100, direction: 1, before_collected: Collection.new, before_page: 1, recursive_limit: 200, &block)
        # dataset = query_with_root_key(page: page)
        # store_originals dataset
        # collected = filtering_dataset(dataset, ->(data) { new(**data) }, &block)
        collected = where(page: page, &block)
        Rails.logger.debug "page: #{page}, step: #{step}, direction: #{direction}, before_collected: #{before_collected.length}, before_page: #{before_page}, collected: #{collected.length}, recursive_limit: #{recursive_limit}"
        return before_collected + collected if recursive_limit.negative?

        if direction.positive?
          # 정방향 탐색에서
          if before_collected.empty? && collected.any?
            # 정방향에서, 이전에 비었고, 지금 있다면
            if step.abs <= 1
              # 스텝의 절대값이 1 이하이면, 페이지 발견.
              collected += collect_page(
                  direction: 1,
                  step: 1,
                  page: page + 1,
                  before_collected: collected,
                  before_page: page,
                  recursive_limit: recursive_limit,
                  &block
              )
            elsif page == 1
              # 첫 페이지에서, 페이지 발견.
              collected += collect_page(
                  direction: 1,
                  step: 1,
                  page: page + 1,
                  before_collected: collected,
                  before_page: page,
                  recursive_limit: recursive_limit,
                  &block
              )
            else
              # 방향을 전환하고
              # 더 작은 보폭으로 스텝 점프 진행
              direction *= -1
              step = step / 2 * -1
              collected += collect_page(
                  direction: direction,
                  step: step,
                  page: page + step,
                  before_page: page,
                  before_collected: collected,
                  recursive_limit: recursive_limit - 1,
                  &block
              )
            end
          elsif before_collected.empty? && collected.empty?
            # 정방향에서, 이전에 비었고, 지금 비었으면
            # 그대로 다음 스텝 점프 진행
            collected += collect_page(
                direction: direction,
                step: step,
                page: page + step,
                before_page: page,
                before_collected: collected,
                recursive_limit: recursive_limit - 1,
                &block
            )
          elsif before_collected.any? && collected.any?
            # 정방향에서, 이전에는 있고, 지금은 있다면
            # 다음 페이지로 진행
            collected += collect_page(
                direction: 1,
                step: 1,
                page: page + 1,
                before_page: page,
                before_collected: collected,
                recursive_limit: recursive_limit,
                &block
            )
          elsif before_collected.any? && collected.empty?
            # 정방향에서, 이전에는 있고, 지금은 없다면
            # 끝
          end


        else
          # 역방향 탐색에서
          if page.negative?
            # 역방향에서, 페이지가 음수가 되면
            # 방향을 전환하고
            # 더 작은 보폭으로 스텝 점프 진행
            direction *= -1
            step = step / 2 * -1
            collected += collect_page(
                direction: direction,
                step: step,
                page: page + step,
                before_page: page,
                before_collected: collected,
                recursive_limit: recursive_limit - 1,
                &block
            )
          elsif before_collected.empty? && collected.any?
            # 역방향에서, 이전에 비었고, 지금 있다면
            # 끝
          elsif before_collected.empty? && collected.empty?
            # 역방향에서, 이전에도 비었고, 지금도 비었으면
            # 끝
          elsif before_collected.any? && collected.any?
            # 역방향에서, 이전에는 있고, 지금은 있다면
            # 그대로 다음 스텝 점프 진행
            collected += collect_page(
                direction: direction,
                step: step,
                page: page + step,
                before_page: page,
                before_collected: collected,
                recursive_limit: recursive_limit - 1,
                &block
            )
          elsif before_collected.any? && collected.empty?
            # 역방향에서, 이전에는 있고, 지금은 없다면
            # 방향을 전환하고
            # 더 작은 보폭으로 스텝 점프 진행
            direction *= -1
            step = step / 2 * -1
            collected += collect_page(
                direction: direction,
                step: step,
                page: page + step,
                before_page: page,
                before_collected: collected,
                recursive_limit: recursive_limit - 1,
                &block
            )
          end
        end

        before_collected + collected
      end
    end
  end
end