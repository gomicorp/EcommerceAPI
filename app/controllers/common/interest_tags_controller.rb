module Common
  class InterestTagsController < BaseController
    before_action :set_interest_tags_scope, only: %i[index]

    def index
      # = index.json.jbuilder
    end

    private

    def set_interest_tags_scope
      # = 현재 스코프는 "gomi", "user" 가 존재합니다.
      scope = params[:scope]
      if scope
        @interest_tags = InterestTag.where(created_by: params[:scope])
      else
        @interest_tags = InterestTag.all
      end
    end

  end
end
