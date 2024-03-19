class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILJET_NOREPLY_FROM']
  layout "mailer"
end
