module Api
  module V1
    class ManagersController < BaseController
      before_action :authenticate_request!, except: %i[create]
      before_action :set_manager, only: %i[show update destroy]

      # GET: /api/v1/managers
      def index
        @managers = decorator_class.decorate_collection(Manager.all)

        render json: @managers
      end

      # GET: /api/v1/managers/:id
      def show
        render json: @manager
      end

      # POST: /api/v1/managers
      def create
        @manager = Manager.new(manager_params)

        if @manager.save
          render json: @manager
        else
          render json: @manager.errors, status: :unprocessable_entity
        end
      end

      # PUT | PATCH: /api/v1/managers/:id
      def update
        if @manager.update(manager_params)
          render json: @manager
        else
          render json: @manager.errors, status: :unprocessable_entity
        end
      end

      # DELETE: /api/v1/managers/:id
      def destroy
        @manager.destroy
      end

      protected

      def default_decorator_name
        'Users::Managers::DefaultDecorator'
      end

      private

      def set_manager
        @manager = decorator_class.decorate(Manager.find(params[:id]))
      end

      def manager_params
        params.require(:manager).permit(:name, :email, :password, :password_confirmation, :invite_confirmation_token)
      end
    end
  end
end
