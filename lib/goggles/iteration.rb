require "watir-webdriver"

module Goggles
  class Iteration
    attr_reader :browser, :browser_name
    
    def initialize driver, width, config, &block
      @browser_name = driver
      @config       = config
      @size         = width
      build_browser
      yield browser
    end

    def build_browser
      @browser = Watir::Browser.new browser_name
    end
  end
end
