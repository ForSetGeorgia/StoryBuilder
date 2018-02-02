BootstrapStarter::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true


	# devise requires
	config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  config.middleware.use ExceptionNotifier,
    :email_prefix => "[Story Builder Dev App Error (#{Rails.env})] ",
    :sender_address => ENV['STORY_BUILDER_FROM_EMAIL'],
    :exception_recipients => ENV['STORY_BUILDER_ERROR_TO_EMAIL']

  Paperclip.options[:command_path] = "/usr/local/bin/"



  # Prevents from writing logs on `log/development.log`
  logger        = ::Logger.new(STDOUT)
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  # Replace `config.active_support.deprecation = :log` with:
  config.active_support.deprecation = :stderr
end


# module ActiveSupport
#   class LogSubscriber
#     def debug(*args, &block)
#     end
#   end
# end
