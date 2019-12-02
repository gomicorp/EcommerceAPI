# frozen_string_literal: true

module Partner
  module Users
    class SessionsController < BaseController

      # POST /users/sign_in
      def create
        @manager = Manager.find_by_email(manager_param[:email])
        return render json: { message: 'Email not found' }, status: :unauthorized unless @manager

        unless @manager.valid_password?(manager_param[:password])
          return render json: { message: 'Invalid password' }, status: :unauthorized
        end

        render json: jwt_payload(@manager)
      end

      # DELETE /users/sign_out
      # def destroy
      #   super
      # end

      protected

      def manager_param
        params.require(:users).permit(:email, :password)
      end
    end
  end
end
