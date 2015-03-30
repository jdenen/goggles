module Goggles
  class Iteration
    def initialize driver, width, config
      @browser_name = driver
      @config       = config
      @size         = width
    end
  end
end
