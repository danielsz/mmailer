module Mmailer
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end

    def provider
      self.configuration = provider
    end

  end

  class Configuration
    attr_accessor :provider, :template, :subject, :from, :server_port, :collection, :time_interval, :mail_interval, :sleep_time

    def sleep_time
      @sleep_time || 3600
    end

    def time_interval
      @time_interval || 6
    end

    def mail_interval
      @mail_interval || 48
    end

  end
end