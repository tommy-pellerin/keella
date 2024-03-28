class ContactMailer < ApplicationMailer
    def contact_notification_admin(contact)
        @contact = contact
        mail(to: ENV['ADMIN_EMAIL'], subject: "formulaire contact #{@contact.issue}")
      end
    def contact_notification_user(contact)
        @contact = contact
        mail(to: "#{@contact.user.email}", subject: "formulaire contact #{@contact.issue}")
    end
end
