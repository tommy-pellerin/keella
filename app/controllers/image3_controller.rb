class Image3Controller < ApplicationController
    def create
        @workout = Workout.find(params[:workout_id])
        @workout.image3.attach(params[:image3])
        redirect_to edit_workout_path(@workout), notice: "L'image 3 a été ajoutée avec succès."
      end
end
