require "image_size"

module Goggles

  #
  # Generates a diff image and data file from two images.
  #
  # Results are saved to a new directory derived from the configured directory setting,
  #  a description given to `Watir::Browser.grab_screenshot`, browser size, and the
  #  browsers used to take the screenshots.
  #
  # @example Results
  #     Goggles.configure do |c|
  #       c.directory = "/path/results"
  #       c.browsers = [:chrome, :firefox]
  #       c.sizes = [100]
  #     end
  #
  #     Goggles.each do |b|
  #       b.goto "www.google.com"
  #       b.grab_screenshot "search"
  #     end
  #
  #     #=> /path/results
  #     #   |- /search_100
  #     #    |- chrome_firefox_data.txt
  #     #    |- chrome_firefox_diff.png
  #
  class Comparison
    attr_reader :directory, :fuzzing, :color, :groups, :results_dir
    
    def initialize config
      @directory = config.directory
      @fuzzing   = config.fuzzing
      @color     = config.color
      @groups    = config.groups
    end

    #
    # Sizes and compare screenshots.
    #
    # @return [nil]
    #
    def make!
      cut_to_common_size
      highlight_differences
    end

    #
    # Sizes comparable screenshots to a common height and width.
    #
    # @return [nil]
    #
    def cut_to_common_size
      groups.each_with_object([]) do |group, sizes|
        collection = find_comparable group
        
        collection.each do |img|
          File.open(img, 'rb'){ |file| sizes << read_size(file) }
        end

        cut! collection, sizes
      end
    end

    #
    # Generates diff images for comparable screenshots.
    #
    # @return [nil]
    #
    def highlight_differences
      groups.each do |desc|
        ensure_result_directory desc
        find_comparable(desc).combination(2).to_a.each { |imgs| diff imgs[0], imgs[1]  }
      end
    end

    #
    # Finds comparable screenshots for sizing and comparing.
    #
    # @param description [String] screenshot description
    # @return [Array<String>] paths to comparable screenshots
    #
    def find_comparable description
      Dir.glob("#{directory}/*.png").grep(/#{description}_/).sort
    end

    #
    # Finds the smallest first element for all arrays in the given array. This is 
    #  the screenshot width attribute. Used for resizing.
    #
    # @param array [Array<Array>] collection of screenshot sizes
    # @return [Fixnum] smallest width
    #
    def find_common_width array
      array.collect(&:first).sort.first
    end

    #
    # Finds the smallest second element for all arrays in the given array. This is
    #  the screenshot height attribute. Used for resizing.
    #
    # @param array [Array<Array>] collection of screenshot sizes
    # @return [Fixnum] smallest screenshot height
    #
    def find_common_height array
      array.collect(&:last).sort.first
    end

    private

    attr_writer :results_dir

    #
    # @api private
    #
    # Cuts comparable screenshots to smallest width by smallest height with ImageMagick.
    #
    # @param images [Array<String>] comparable screenshots
    # @param sizes  [Array<Fixnum>] sizes (width, height) of comparable screenshots
    # @return [nil]
    #
    def cut! images, sizes
      w = find_common_width sizes
      h = find_common_height sizes
      images.each { |img| `convert #{img} -background none -extent #{w}x#{h} #{img}` }
    end

    #
    # @api private
    #
    # Generates comparison data for two screenshots with ImageMagick.
    #
    # @param img_one [String] first screenshot path
    # @param img_two [String] second screenshot path
    # @return [nil]
    #
    def diff img_one, img_two
      b1 = diffed img_one
      b2 = diffed img_two
      
      fuzz = "#{results_dir}/#{b1}_#{b2}_diff.png"
      data = "#{results_dir}/#{b1}_#{b2}_data.txt"
      
      `compare -fuzz #{fuzzing} -metric AE -highlight-color #{color} #{img_one} #{img_two} #{fuzz} 2>#{data}`
    end

    #
    # @api private
    #
    # Parses a browser from a screenshot filepath.
    #
    # @param img [String] screenshot path
    # @return [String] browser
    #
    def diffed img
      File.basename(img).match(/\d+_(.*)\.png/)[1]
    end

    #
    # @api private
    #
    # Finds the width and height of an image.
    #
    # @param file [File] image
    # @return [Array<Fixnum>] width and height
    #
    def read_size file
      ImageSize.new(file.read).size
    end

    #
    # @api private
    #
    # Ensures the results directory for comparable screenshots exists.
    #
    # @param description [String] screenshot description
    # @return [nil]
    #
    def ensure_result_directory description
      self.results_dir = "#{directory}/#{description}"
      FileUtils.rm_rf   results_dir
      FileUtils.mkdir_p results_dir
    end
  end
end
