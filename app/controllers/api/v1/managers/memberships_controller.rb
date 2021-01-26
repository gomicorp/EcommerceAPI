module Api
  module V1
    module Managers
      class MembershipsController < BaseController
        before_action :authenticate_request!
        before_action :set_manager
        before_action :set_membership, only: %i[show update destroy]

        # GET: /api/v1/managers/:manager_id/memberships
        def index
          @memberships = decorator_class.decorate_collection(@manager.memberships)

          render json: @memberships
        end

        # GET: /api/v1/managers/:manager_id/memberships/:id
        def show
          render json: @membership
        end

        # POST: /api/v1/managers/:manager_id/memberships
        def create
          @membership = Membership.new(membership_params)

          if @membership.save
            render json: decorator_class.decorate(@membership)
          else
            render json: @membership.errors, status: :unprocessable_entity
          end
        end

        # PUT | PATCH: /api/v1/managers/:manager_id/memberships/:id
        def update
          if @membership.update(membership_params)
            render json: @membership
          else
            render json: @membership.errors, status: :unprocessable_entity
          end
        end

        # DELETE: /api/v1/managers/:manager_id/memberships/:id
        def destroy
          @membership.destroy
        end

        protected

        def default_decorator_name
          'Memberships::DefaultDecorator'
        end

        private

        def set_manager
          @manager = Manager.find(params[:manager_id])
        end

        def set_membership
          membership = @manager.memberships.find(params[:id])
          @membership = decorator_class.decorate(membership)
        end

        # Only allow a list of trusted parameters through.
        def membership_params
          params.fetch(:membership, {}).permit(:company_id, :manager_id, :role, :accepted)
        end
      end
    end
  end
end
