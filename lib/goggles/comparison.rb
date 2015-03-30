module Goggles
  class Comparison
    attr_reader :directory, :fuzzing, :color, :groups
    
    def initialize config
      @directory = config.directory
      @fuzzing   = config.fuzzing
      @color     = config.color
      @groups    = config.groups
    end
    
    def make_comparison
      cut_to_common_size
      highlight_differences
    end
    
    def cut_to_common_size
      groups.each_with_object([]) do |group, array|
        collection = find_comparable group
      end
    end

    def find_comparable 
    end
  end
end
