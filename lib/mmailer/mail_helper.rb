module Mmailer
  class MailHelper
    attr_reader :template, :subject

    def initialize
      set_provider args.fetch(:provider, :mailchimp)
      @template=args[:template]
      @subject=args[:subject]
    end

    def set_provider(provider)
      providers = {google: Providers.gmail, mailchimp: Providers.mandrill}
      Mail.defaults(&providers[provider])
    end

    def send_email(user)

      mail = Mail.new do
        to user.email
        from 'Etsy Fu <info@shopi-fu.com>'
      end
      mail.subject = subject

      text_part = Mail::Part.new
      text_part.body=ERB.new(File.read(Dir.pwd + Mmailer.configuration.template)).result(binding)

      html_part = Mail::Part.new
      html_part.content_type='text/html; charset=UTF-8'
      html_part.body=ERB.new(File.read(Dir.pwd + Mmailer.configuration.template)).result(binding)

      mail.text_part = text_part
      mail.html_part = html_part
      #when Non US-ASCII detected and no charset defined. Defaulting to UTF-8, set your own if this is incorrect.
      mail.charset = 'UTF-8'
      #puts mail.to_s
      mail.deliver!

    end
  end
end