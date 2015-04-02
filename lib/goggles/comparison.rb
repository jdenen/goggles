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
      groups.each_with_object([]) do |group, sizes|
        collection = find_comparable group
        
        collection.each do |img|
          File.open(img, 'rb'){ |file| sizes << read_size(file) }
        end

        cut! collection, sizes
      end
    end

    def find_comparable description
      Dir.glob("#{directory}/*.png").grep(/#{description}_/).sort
    end

    def find_common_width array
      array.collect(&:first).sort.first
    end

    def find_common_height array
      array.collect(&:last).sort.first
    end

    private

    def cut! images, sizes
      w = find_common_width sizes
      h = find_common_height sizes
      images.each { |img| `convert #{img} -background none -extent #{w}x#{h} #{img}` }
    end

    def read_size file
      ImageSize.new(file.read).size
    end
  end
end
