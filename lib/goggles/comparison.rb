require "image_size"

module Goggles

  def diff_images
    images = Dir.glob("#{@gg_result_dir}/*/*.png").sort
    raise Goggles::EmptyResultError, "No screenshots found in results directory: #{@gg_result_dir}" if images.empty?

    size_to_smallest!

    until images.empty?
      one = images.slice!(0)
      two = images.slice!(0)

      out_path = one.gsub(/[^_]*$/, '')

      diff_out = "#{out_path}diff.png"
      data_out = "#{out_path}data.txt"

      `compare -fuzz #{@gg_fuzz} -metric AE -highlight-color #{@gg_color} #{one} #{two} #{diff_out} 2>#{data_out}`
    end
  end

  def size_to_smallest!
    images = Dir.glob("#{@gg_result_dir}/*/*.png").sort

    until images.empty?
      pair = images.slice!(0..1)
      widths = []
      heights = []

      File.open(pair[0], 'rb') do |one|
        size = ImageSize.new(one.read).size
        widths << size[0]
        heights << size[1]

        File.open(pair[1], 'rb') do |two|
          size = ImageSize.new(two.read).size
          widths << size[0]
          heights << size[1]

          pair.each do |file|
            `convert #{file} -background none -extent #{widths.sort[0]}x#{heights.sort[0]} #{file}`
          end
        end
      end
    end
  end

end
