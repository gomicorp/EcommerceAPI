# frozen_string_literal: true

module Partner
  module Users
    class SessionsController < BaseController
      before_action :authenticate_request!, only: [:show, :destroy]

      # POST /users/sign_in
      def create
        if session_param[:token].present?
          decoded_token = decode_jwt(session_param[:token])
          return render json: jwt_payload(Manager.find(decoded_token[:user_id]))
        end

        @manager = Manager.where(email: session_param[:email]).first
        return render json: { message: 'Email not found' }, status: :unauthorized unless @manager

        unless @manager.valid_password?(session_param[:password])
          return render json: { message: 'Invalid password' }, status: :unauthorized
        end

        render json: jwt_payload(@manager)
      end

      def show
        render :'partner/managers/show', locals: { manager: @current_user }, status: :ok
      end

      # DELETE /users/sign_out
      def destroy
        @current_user.update!(token: nil)
        head :no_content
      end

      protected

      def session_param
        params.require(:users).permit(:email, :password, :token)
      end
    end
  end
end
