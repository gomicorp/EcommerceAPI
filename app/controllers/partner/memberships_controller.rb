module Partner
  class MembershipsController < BaseController
    before_action :authenticate_request!
    before_action :set_membership, only: [:show, :update, :destroy]

    def index
      render json: Membership.where(params.permit(*Membership.attribute_names))
    end

    def show
      render json: @membership, status: :ok
    end

    def create
      @membership = Membership.find_or_initialize_by(membership_params)
      # new_record = !@membership.persisted?

      if @membership.save
        # 초대 메일을 보내는 내용이나, 당분간 사용할 계획이 없어 주석처리했습니다.
        # 삭제하지 말아주세요!
        # send_invite_email if new_record
        render json: @membership, status: :created
      else
        render json: @membership.errors, status: :unprocessable_entity
      end
    end

    def update
      @membership.update(membership_params)
      render json: @membership, status: :ok
    end

    def destroy
      @membership.destroy
      head :no_content
    end

    private

    def set_membership
      @membership = Membership.find(params[:id])
    end

    def membership_params
      params.require(:membership).permit(:company_id, :manager_id, :role, :accepted)
    end

    def send_invite_email
      MembershipMailer.create(@membership, membership_params.merge(token: invite_token)).deliver_now
    end

    def invite_token
      params[:token].presence || 'gomi_invitee-'+jwt_payload(@membership.manager)[:token]
    end
  end
end
