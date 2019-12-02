module Partner

  # @param
  #
  # {
  #   company: {
  #     name,
  #     description
  #   },
  #   owner_id
  # }
  class CompanyCreateService
    attr_reader :params, :company

    def initialize(params)
      @params = params
      @company = Company.new(company_param)
    end

    def save
      set_ownership && save_company
    end

    private

    def save_company
      company.save
    end

    def set_ownership
      return false if membership_param[:role] != 'owner'

      company.memberships.build membership_param.as_json
    end

    def company_param
      params.require(:company).permit(:name, :description)
    end

    def membership_param
      params.require(:membership).permit(:manager_id, :role)
    end
  end
end
