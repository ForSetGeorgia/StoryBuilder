if Rails.env.production? || Rails.env.staging?
  ActionMailer::Base.smtp_settings = {
    :address              => ENV['EMAIL_FROM_SMTP'],
    :port                 => 587,
    :domain               => 'forset.ge',
    :user_name            => ENV['EMAIL_FROM'],
    :password             => ENV['EMAIL_FROM_PWD'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }
end
