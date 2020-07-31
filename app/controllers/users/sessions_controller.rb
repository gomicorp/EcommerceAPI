# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      # 소셜 로그인 콜백 요청인지?
      if params[:auth].present?
        auth = JSON.parse(auth_params.to_json, object_class: OpenStruct)
        @user = User.find_for_oauth(auth, current_user)

        case params[:level]
        when 'seller' then @user.update(is_seller: true)
        end

        # super 내의 warden.authenticate! 메소드를 무시하기 위해
        # super 를 override 했습니다.
        self.resource = @user   # 원래 self.resource = warden.authenticate!(auth_options) 였습니다.
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        super
      end
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

    def respond_with(resource, _opts = {})
      render json: resource
    end

    def respond_to_on_destroy
      head :no_content
    end

    def auth_params
      params.require(:auth).permit!
    end
  end
end
