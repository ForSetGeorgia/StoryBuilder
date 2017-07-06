class ContactMailer < ActionMailer::Base
  default :from => ENV['EMAIL_FROM']
  default :to => ENV['EMAIL_TO']

  def new_message(message)
    @message = message
    mail(:cc => "#{message.name} <#{message.email}>",
			:subject => I18n.t("mailer.contact.contact_form.subject"))
  end


end
