require "watir-webdriver"

module Goggles
  class Iteration
    attr_reader :browser, :browser_name, :size
    
    def initialize driver, width, config, &block
      @browser_name = driver
      @config       = config
      @size         = width
      build_browser
      yield browser
    end

    def build_browser
      @browser = Watir::Browser.new browser_name
      @browser.driver.manage.window.resize_to size, 768
    end
  end
end
