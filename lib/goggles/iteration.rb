require "watir-webdriver"

module Goggles
  class Iteration
    attr_reader :browser
    
    def initialize driver, width, config, &block
      @browser_name = driver
      @config       = config
      @size         = width
      build_browser
      yield browser
    end

    def build_browser
      @browser = Watir::Browser.new
    end
  end
end
