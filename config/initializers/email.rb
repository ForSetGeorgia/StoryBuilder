if Rails.env.production? || Rails.env.staging?
	ActionMailer::Base.smtp_settings = {
    :address              => ENV['STORY_BUILDER_EMAIL_SMTP_ADDRESS'],
    :port                 => 587,
    :domain               => 'forset.ge',
    :user_name            => ENV['STORY_BUILDER_EMAIL_SMTP_AUTH_USER'],
    :password             => ENV['STORY_BUILDER_EMAIL_SMTP_AUTH_PASSWORD'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
	}
end
