module Goggles
  class Comparison
    def initialize config
      @directory = config.directory
      @fuzzing   = config.fuzzing
      @color     = config.color
    end
    
    def make_comparison
      cut_to_common_size
      highlight_differences
    end
  end
end
