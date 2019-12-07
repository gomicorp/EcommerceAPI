module Partner
  class CompanyUpdateService
    attr_reader :params, :company, :membership

    def initialize(company, params)
      @params = params
      @company = company
      @membership = Membership.find_or_initialize_by(manager_id: membership_param[:manager_id], company_id: company.id)
    end

    def save
      save_company && set_ownership
    end

    private

    def save_company
      company.update(company_param)
    end

    def set_ownership
      return true if company.ownership.id == membership.id

      company.ownership.update(role: 'admin')
      membership.role = 'owner'
      membership.save
    end

    def company_param
      params.require(:company).permit(:name, :description)
    end

    def membership_param
      params.require(:membership).permit(:manager_id, :role)
    end
  end
end
