module Goggles
  class Configuration
    attr_accessor :browser, :size

    def initialize
      @browser = nil
      @size    = nil
    end
  end
end
