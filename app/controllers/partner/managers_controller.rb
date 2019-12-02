module Partner
  class ManagersController < BaseController
    def index
      if params[:format] == 'json' && params[:email]
        @managers = Manager.where('email LIKE ?', "%#{params[:email]}%")
        return render json: @managers
      end
    end
  end
end
