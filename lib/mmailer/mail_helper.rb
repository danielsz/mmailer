module Mmailer
  class MailHelper
    attr_reader :template, :subject, :from

    def initialize(args)
      set_provider args.fetch(:provider, :mandrill)
      @template=args[:template]
      @subject=args[:subject]
      @from=args[:from]
    end

    def set_provider(provider)
      providers = {google: Providers.gmail, mandrill: Providers.mandrill, zoho: Providers.zoho}
      Mail.defaults(&providers[provider])
    end

    def send_email(user)

      mail = Mail.new do
        to user.email
      end
      mail.from = from
      mail.subject = subject

      text_part = Mail::Part.new
      text_part.body=ERB.new(File.read(Dir.pwd + "/" + Mmailer.configuration.template + ".txt.erb")).result(binding)

      html_part = Mail::Part.new
      html_part.content_type='text/html; charset=UTF-8'
      html_part.body=ERB.new(File.read(Dir.pwd + "/" + Mmailer.configuration.template + ".html.erb")).result(binding)

      mail.text_part = text_part
      mail.html_part = html_part
      #when Non US-ASCII detected and no charset defined. Defaulting to UTF-8, set your own if this is incorrect.
      mail.charset = 'UTF-8'

      case ENV['MMAILER_ENV']
        when "production"
          mail.deliver!
        when "development"
          puts mail.to_s
        else
          mail.deliver!
      end
    end
  end
end