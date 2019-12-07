module Partner
  class MembershipMailer < ApplicationMailer
    layout false

    HOST = Rails.env == 'production' ? 'https://partner.gomicorp.com' : 'http://localhost:3000'

    def create(membership, membership_param)
      @membership = membership

      token = membership_param[:token]
      @company = Company.find(membership_param[:company_id])
      @manager = Manager.find(membership_param[:manager_id])
      @client_host = HOST
      @callback_url = "#{@client_host}/biz/companies/#{@company.id}?tab=managers&email=#{@manager.email}&token=#{token}"

      mail(
        to: @manager.email,
        from: 'support@gomicorp.com',
        subject: "[고미 파트너센터] #{@company.name} 에서 비즈니스에 초대합니다.",
        template_path: template_path
      )
    end

    private

    def template_path
      'partner/mailers/membership'
    end
  end
end
