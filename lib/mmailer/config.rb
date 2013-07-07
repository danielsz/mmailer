module Mmailer
  class << self
    attr_accessor :configuration, :shop

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end

    def shop
      @shop ||= Shop.get(configuration.shop)
    end

  end

  class Configuration
    attr_accessor :shop
  end

  class Shop
    def self.get(shop)
      shops = {shopify: Shopify.new, etsy: Etsy.new, dummy: Dummy.new}
      shops[shop]
    end
  end

end