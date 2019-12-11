module Gomisa
  class BaseController < ApiController
    before_action :set_app_locale

    # CRUD stuff
    def index; end

    # CRUD stuff
    def show; end

    # CRUD stuff
    def new; end

    # CRUD stuff
    def create; end

    # CRUD stuff
    def edit; end

    # CRUD stuff
    def update; end

    # CRUD stuff
    def destroy; end

    protected

    def set_app_locale
      I18n.default_locale = :ko
    end
  end
end
