module Goggles
  class Configuration
    attr_accessor :browsers, :sizes, :fuzzing, :color, :groups
    attr_reader :directory

    def initialize
      @browsers  = []
      @sizes     = []
      @groups    = []
      @directory = ""
      @color     = "blue"
      @fuzzing   = "20%"
    end

    def directory=(path)
      @directory = path
      FileUtils.mkdir_p path unless path.empty?
    end
  end
end
