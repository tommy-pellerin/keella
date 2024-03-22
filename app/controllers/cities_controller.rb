class CitiesController < ApplicationController
    def index
        if params[:query].present?
          @cities = City.search_by_full_name(params[:query])
        else
          @cities = City.all
        end
    end
      

end
