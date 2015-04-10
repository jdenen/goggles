require "watir-webdriver"

module Watir
  class Browser
    attr_accessor :goggles, :iteration

    def grab_screenshot name
      description = "#{name}_#{iteration.size}"
      goggles.groups << description unless goggles.groups.include? description
      screenshot.save "#{goggles.directory}/#{description}_#{iteration.browser_name}.png"
    end
  end
end

module Goggles
  class Iteration
    attr_reader :browser, :browser_name, :size, :config
    
    def initialize driver, width, config, &block
      @browser_name = driver
      @config       = config
      @size         = width
      build_browser
      yield browser
      browser.close
    end

    private

    def build_browser
      @browser = Watir::Browser.new(browser_name).tap do |engine|
        engine.goggles   = config
        engine.iteration = self
        engine.driver.manage.window.resize_to size, 768
      end
    end
  end
end
