module Common
  class SocialMediaServicesController < BaseController

    def index
      @social_media_services = SocialMediaService.all
    end
  end
end
