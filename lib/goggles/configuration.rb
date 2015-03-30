module Goggles
  class Configuration
    attr_accessor :browsers, :sizes

    def initialize
      @browsers = []
      @sizes    = []
    end
  end
end
