class ImagesController < ApplicationController
    def create
        @workout = Workout.find(params[:workout_id])
        @workout.images.attach(params[:images])
        redirect_to edit_workout_path(@workout), notice: "L'image a été ajoutée avec succès."
    end
end
