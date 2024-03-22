class Image2Controller < ApplicationController
    def create
        @workout = Workout.find(params[:workout_id])
        @workout.image2.attach(params[:image2])
        redirect_to edit_workout_path(@workout), notice: "L'image 2 a été ajoutée avec succès."
      end
end
