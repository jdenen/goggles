module Goggles
  class Configuration
    attr_accessor :browsers, :sizes, :directory, :fuzzing, :color, :groups

    def initialize
      @browsers  = []
      @sizes     = []
      @groups    = []
      @directory = ""
      @color     = "blue"
      @fuzzing   = "20%"
    end
  end
end
