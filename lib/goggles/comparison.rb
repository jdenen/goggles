require "image_size"

module Goggles

  def diff_images
    size_to_smallest!

    images = Dir.glob("#{@goggles_result_dir}/*/*.png").sort

    until images.empty?
      one = images.slice(0)
      two = images.slice(0)

      out_path = one.dup
      discard = out_path.slice!(/[^_]*$/)

      diff_out = "#{out_path}diff.png"
      data_out = "#{out_path}data.txt"

      `compare -fuzz #{@goggles_fuzz} -metric AE -highlight-color blue #{one} #{two} #{diff_out} 2> #{data_out}`
    end
  end

  def size_to_smallest!
    images = Dir.glob("#{@goggles_result_dir}/*/*.png").sort

    until images.empty?
      one = images.slice!(0)
      two = images.slice!(0)

      File.open(one, 'rb') do |file_one|
        size_one = ImageSize.new(file_one.read).size
        first_width = size_one[0]
        first_height = size_one[1]

        File.open(two, 'rb') do |file_two|
          size_two = ImageSize.new(file_two.read).size
          second_width = size_two[0]
          second_height = size_two[1]

          if first_width > second_width
            width = second_width
            w_file = one
          else 
            width = first_width
            w_file = two
          end

          if first_height > second_height
            height = second_height
            h_file = one
          else
            height = first_height
            h_file = two
          end

          cut_to_width(w_file, width)
          cut_to_height(h_file, height)

        end
      end
    end
  end

  def cut_to_width(file, w)
    `convert #{file} -background none -extent #{w}x0 #{file}`
  end

  def cut_to_height(file, h)
    `convert #{file} -background none -extent 0x#{h} #{file}`
  end

end
