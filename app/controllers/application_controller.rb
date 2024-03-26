class ApplicationController < ActionController::Base
    before_action :set_locale

    private
  
    def set_locale
      if params[:locale]
        I18n.locale = params[:locale]
      end
    end
end
