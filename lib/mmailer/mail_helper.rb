module Mmailer
  class MailHelper
    include ErrorHandling
    attr_reader :template, :subject, :from

    def initialize(args)
      set_provider args.fetch(:provider, :mandrill)
      @template=args[:template]
      @subject=args[:subject]
      @from=args[:from]
    end

    def set_provider(provider)
      providers = {gmail: Providers.gmail, mandrill: Providers.mandrill, zoho: Providers.zoho, mailgun: Providers.mailgun }
      Mail.defaults(&providers[provider])
    end

    def send_email(user)

      mail = Mail.new 
      mail.to = user.email
      mail.from = from
      mail.subject = subject
      #Defaulting to UTF-8, set your own if this is incorrect.
      mail.charset = 'UTF-8'
      mail.content_transfer_encoding = '8bit'
      
      compiled_source=ERB.new(File.read(Dir.pwd + "/" + Mmailer.configuration.template + ".md.erb")).result(binding)

      text_part = Mail::Part.new
      text_part.body=compiled_source

      html_part = Mail::Part.new
      html_part.content_type='text/html; charset=UTF-8'
      html_part.body=Kramdown::Document.new(compiled_source).to_html

      mail.text_part = text_part
      mail.html_part = html_part

      case ENV['MMAILER_ENV']
        when "production"
          try { mail.deliver! }
        when "development"
          puts mail.to_s
        else
          mail.to_s
      end
    end
  end
end
