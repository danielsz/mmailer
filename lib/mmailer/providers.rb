module Mmailer
  module Providers

    class << self
      attr_accessor :mandrill, :gmail, :zoho, :mailgun
    end

    @mandrill = Proc.new do
      delivery_method :smtp, {
          :port => 587,
          :address => 'smtp.mandrillapp.com',
          :user_name => ENV['MANDRILL_USERNAME'],
          :password => ENV['MANDRILL_PASSWORD'],
          :domain => 'heroku.com',
          :authentication => :plain
      }
    end

    @mailgun = Proc.new do
      delivery_method :smtp, {
          :port => 587,
          :address => 'smtp.mailgun.org',
          :user_name => ENV['MAILGUN_USERNAME'],
          :password => ENV['MAILGUN_PASSWORD'],
          :domain => ENV['MAILGUN_DOMAIN'],
          :authentication => :plain
      }
    end

    @gmail = Proc.new do
      delivery_method :smtp, {
          :port => 587,
          :address => "smtp.gmail.com",
          :user_name => ENV['GMAIL_USERNAME'],
          :password => ENV['GMAIL_PASSWORD'],
          :authentication => :plain,
          :enable_starttls_auto => true
      }
    end

    @zoho = Proc.new do
      delivery_method :smtp, {
          :port => 465,
          :address => "smtp.zoho.com",
          :user_name => ENV['ZOHO_USERNAME'],
          :password => ENV['ZOHO_PASSWORD'],
          :authentication => :login,
          :ssl => true,
          :tls => true,
          :enable_starttls_auto => true
      }
    end

  end
end
