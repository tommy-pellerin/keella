class ApplicationController < ActionController::Base
    before_action :set_locale
    before_action :configure_devise_parameters, if: :devise_controller?

    def configure_devise_parameters
      devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:pseudo, :city, :phone, :email, :password, :password_confirmation)}
      devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:pseudo, :city, :phone, :email, :current_password, :password, :password_confirmation)}
    end

    private
  
    def set_locale
      if params[:locale]
        I18n.locale = params[:locale]
      end
    end
end
