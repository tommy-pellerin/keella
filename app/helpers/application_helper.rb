module ApplicationHelper
    def bootstrap_class_for_flash(type)
      case type
        when 'notice' then "alert-info"
        when 'success' then "alert-success"
        when 'error' then "alert-danger"
        when 'alert' then "alert-warning"
      end
    end

      def workout_jsonld(workout)
        {
          "@context": "http://schema.org",
          "@type": "ExercisePlan",
          "image":{
            "@type": "ImageObject",
            "caption": workout.images
          },
          "name": workout.title,
          "spatial": workout.location,
          "author": {
            "@type": "Person",
            "name": workout.host.pseudo
          },
          "description": workout.description,
          "temporal": workout.start_date.strftime("%d/%m/%Y %H:%M"),
          "expires": workout.end_date.strftime("%d/%m/%Y %H:%M"),
          
        }.to_json.html_safe
      end
end
