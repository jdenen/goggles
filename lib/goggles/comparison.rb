require "image_size"

module Goggles
  class Comparison
    attr_reader :directory, :fuzzing, :color, :groups, :results_dir
    
    def initialize config
      @directory = config.directory
      @fuzzing   = config.fuzzing
      @color     = config.color
      @groups    = config.groups
    end
    
    def make!
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

    def highlight_differences
      groups.each do |desc|
        ensure_result_directory desc
        find_comparable(desc).combination(2).to_a.each { |imgs| diff imgs[0], imgs[1]  }
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

    attr_writer :results_dir

    def cut! images, sizes
      w = find_common_width sizes
      h = find_common_height sizes
      images.each { |img| `convert #{img} -background none -extent #{w}x#{h} #{img}` }
    end

    def diff img_one, img_two
      fuzz = "#{results_dir}/diff.png"
      data = "#{results_dir}/data.txt"
      `compare -fuzz #{fuzzing} -metric AE -highlight-color #{color} #{img_one} #{img_two} #{fuzz} 2>#{data}`
    end

    def read_size file
      ImageSize.new(file.read).size
    end

    def ensure_result_directory description
      self.results_dir = "#{directory}/#{description}"
      FileUtils.rm_rf   results_dir
      FileUtils.mkdir_p results_dir
    end
  end
end
