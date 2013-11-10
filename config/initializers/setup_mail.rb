ActionMailer::Base.smtp_settings = {
  :address              => Figaro.env.theresienball_mail_host,
  :port                 => 587,
  :domain               => Figaro.env.theresienball_mail_domain,
  :user_name            => Figaro.env.theresienball_mail,
  # Set password as an environment variable
  :password             => Figaro.env.theresienball_mail_pass,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to      = Figaro.env.theresienball_mail
  end
end

ActionMailer::Base.default_url_options[:host] = "0.0.0.0:3000"

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
