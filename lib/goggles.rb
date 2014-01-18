require "goggles/version"
require "goggles/comparison"
require "goggles/scripter"

require "watir-webdriver"
require "yaml"
require "fileutils"

module Goggles
  extend self

  def swim(config_path)
    conf = YAML::load(File.open(config_path))

    @goggles_result_dir = conf['results_directory']
    @goggles_script_dir = conf['scripts_directory']
    @goggles_domain = conf['domain_under_test']
    @goggles_paths = conf['paths_to_capture']
    @goggles_scripts = conf['scripts_to_execute']
    @goggles_platforms = conf['browsers']
    @goggles_widths = conf['browser_widths']
    @goggles_fuzz = conf['image_fuzzing']

    embark!
    diff_images
  end

  def grab_screenshot(detail)
    make_result_dir

    image_dir = "#{@goggles_result_dir}/#{@gg_label}"
    image_name = "#{detail}_#{@gg_size}_#{@gg_browser}"

    @watir.screenshot.save "#{image_dir}/#{image_name}.png"
  end

  private

  def embark!
    ensure_fresh_start
    
    @goggles_widths.each do |size|
      @gg_size = size.to_i

      @goggles_platforms.each do |pf|
        @gg_browser = pf
        
        @watir = Watir::Browser.new pf.to_sym
        @watir.driver.manage.window.resize_to(@gg_size, 768)

        @goggles_paths.each do |label, path|
          @gg_label = label
          url = "#{@goggles_domain}#{path}"

          if @goggles_scripts.nil?
            @watir.goto url
            grab_screenshot("screenshot")
          else
            @goggles_scripts.each do |script|
              script_name = script.gsub(/\/(.*)\//, '').gsub('.rb', '')
              script = "#{@goggles_script_dir}/#{script}"

              execute_script(url, script)

              grab_screenshot(script_name)
            end
          end
        end

        @watir.close
      end
    end
  end

  def ensure_fresh_start
    FileUtils.rm_rf("#{@goggles_result_dir}")
  end

  def make_result_dir
    FileUtils.mkdir_p("#{@goggles_result_dir}/#{@gg_label}")
  end

end
