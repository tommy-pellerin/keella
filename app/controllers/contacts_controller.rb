class ContactsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_notification_admin(@contact).deliver_now
      ContactMailer.contact_notification_user(@contact).deliver_now
      redirect_to root_path, notice: "Votre message a bien été envoyé"
    else
      flash[:error] = "Erreur lors de l'enregistrement du contact : #{@contact.errors.full_messages.join(", ")}" 
      render 'new'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:user_id, :issue, :message)
  end
end
