module Sellers
  class SessionsController < BaseController
    before_action :authenticate_user!

    # = GET /sellers/user
    def show
      # = show.json.jbuilder
    end
  end
end
