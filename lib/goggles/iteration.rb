require "watir-webdriver"

module Watir
  class Browser
    attr_accessor :goggles, :iteration

    #
    # Saves a screenshot as "given-description_width.png" in the configured results
    #  directory.
    #
    # @param name [String] screenshot description
    # @return [nil]
    #
    def grab_screenshot name
      description = "#{name}_#{iteration.size}"
      goggles.groups << description unless goggles.groups.include? description
      screenshot.save "#{goggles.directory}/#{description}_#{iteration.browser_name}.png"
    end
  end
end

module Goggles

  #
  # Executes the block passed to `Goggles.each` with every configured combination of browser
  #  and browser size. 
  #
  # @see Goggles.each
  #
  class Iteration
    attr_reader :browser, :browser_name, :size, :config

    #
    # Creates a script iteration instance, building yielded browser object from the
    #  given arguments. Closes the browser instance after yielding to the block.
    #
    # @param driver [String, Symbol] browser name
    # @param width  [Fixnum] browser width
    # @param config [Goggles::Configuration] global configuration
    # @yield [Watir::Browser] browser object
    #
    def initialize driver, width, config, &block
      @browser_name = driver
      @config       = config
      @size         = width
      build_browser
      yield browser
      browser.close
    end

    private

    #
    # @api private
    #
    def build_browser
      @browser = Watir::Browser.new(browser_name).tap do |engine|
        engine.goggles   = config
        engine.iteration = self
        engine.driver.manage.window.resize_to size, 768
      end
    end
  end
end
