module Mmailer
  module Providers

    class << self
      attr_accessor :mandrill, :gmail, :zoho
    end

    @mandrill = Proc.new do
      delivery_method :smtp, {
          :port => 587,
          :address => ENV['MANDRILL_SMTP'],
          :user_name => ENV['MANDRILL_USERNAME'],
          :password => ENV['MANDRILL_API_KEY']
      }
    end

    @gmail = Proc.new do
      delivery_method :smtp, {
          :port => 587,
          :address => ENV['GMAIL_SMTP'],
          :user_name => ENV['GMAIL_USERNAME'],
          :password => ENV['GMAIL_PASSWORD'],
          :authentication => :plain,
          :enable_starttls_auto => true
      }
    end
  end
end