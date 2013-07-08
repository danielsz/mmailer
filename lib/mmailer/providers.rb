module Mmailer
  module Providers

    class << self
      attr_accessor :mandrill, :gmail, :zoho
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
          :port => 587,
          :address => "smtp.zoho.com",
          :user_name => ENV['ZOHO_USERNAME'],
          :password => ENV['ZOHO_PASSWORD'],
          :authentication => :plain,
          :enable_starttls_auto => true
      }
    end

  end
end