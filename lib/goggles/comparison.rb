require "image_size"

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
        
        collection.each do |img|
          File.open(img, 'rb'){ |file| array << read_size(file) }
        end

        cut! collection, array
      end
    end

    def find_comparable description
      Dir.glob("#{directory}/*.png").sort.select { |img| img =~ /#{description}_/ }
    end

    def cut! images, sizes
    end

    def find_common_width array
      array.collect(&:first).sort.first
    end

    private

    def read_size file
      ImageSize.new(file.read).size
    end
  end
end
