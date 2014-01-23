require "goggles/version"
require "goggles/comparison"
require "goggles/error"

require "watir-webdriver"
require "yaml"
require "fileutils"

module Goggles
  extend self

  def swim(config_path)
    conf = YAML::load(File.open(config_path))

    @gg_result_dir = conf['results_directory']
    @gg_script_dir = conf['scripts_directory']
    @gg_domain = conf['domain_under_test']
    @gg_paths = conf['paths_to_capture']
    @gg_scripts = conf['scripts_to_execute']
    @gg_platforms = conf['browsers']
    @gg_widths = conf['browser_widths']
    @gg_fuzz = conf['image_fuzzing']
    @gg_color = conf['diff_color'] || 'blue'

    embark!
    diff_images
  end

  def grab_screenshot(detail)
    make_result_dir

    image_dir = "#{@gg_result_dir}/#{@gg_label}"
    image_name = "#{detail}_#{@gg_size}_#{@gg_browser}"

    @watir.screenshot.save "#{image_dir}/#{image_name}.png"
  end

  private

  def embark!
    ensure_fresh_start
    
    @gg_widths.each do |size|
      @gg_size = size.to_i

      @gg_platforms.each do |pf|
        @gg_browser = pf
        
        @watir = Watir::Browser.new pf.to_sym
        @watir.driver.manage.window.resize_to(@gg_size, 768)

        @gg_paths.each do |label, path|
          @gg_label = label
          @gg_url = "#{@gg_domain}#{path}"

          if @gg_scripts.nil?
            @watir.goto @gg_url
            grab_screenshot("screenshot")
          else
            @gg_scripts.each do |script|
              script = "#{@gg_script_dir}/#{script}"
              @watir.goto @gg_url
              eval(File.read(script))
            end
          end
        end

        @watir.close
      end
    end
  end

  def ensure_fresh_start
    FileUtils.rm_rf("#{@gg_result_dir}")
  end

  def make_result_dir
    FileUtils.mkdir_p("#{@gg_result_dir}/#{@gg_label}")
  end

end
