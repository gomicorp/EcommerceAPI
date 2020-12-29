module Companies
  class DefaultDecorator < CompanyDecorator
    delegate_all

    # def brands(template = nil)
    #   @brands ||= if template
    #                 # ....
    #               else
    #                 Brands::DefaultDecorator.decorate(object.brands)
    #               end
    # end
  end
end
