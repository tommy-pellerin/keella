class Image1Controller < ApplicationController
    def create
        @workout = Workout.find(params[:workout_id])
        @workout.image1.attach(params[:image1])
        redirect_to edit_workout_path(@workout), notice: "L'image 1 a été ajoutée avec succès."
      end
end
