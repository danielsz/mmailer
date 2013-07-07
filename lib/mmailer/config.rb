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
    attr_accessor :provider, :template, :subject, :server_port, :collection
  end
end