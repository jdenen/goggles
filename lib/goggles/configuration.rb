module Goggles
  class Configuration
    attr_accessor :browsers, :size

    def initialize
      @browsers = []
      @size    = nil
    end
  end
end
