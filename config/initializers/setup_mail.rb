ActionMailer::Base.smtp_settings = {
  :address              => "smtp.strato.de",
  :port                 => 587,
  :domain               => "theresienschule.de",
  :user_name            => "theresienball@theresienschule.de",
  # Set password as an environment variable
  :password             => ENV["THERESIENBALL_MAIL_PASS"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to      = "julien@bergner.fr"
  end
end

ActionMailer::Base.default_url_options[:host] = "0.0.0.0:3000"

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
