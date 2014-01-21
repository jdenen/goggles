require 'goggles'
require 'optparse'
require 'pathname'

module Goggles
  class CLI

    def initialize(argv)
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Goggles: Compare responsive screenshots in multiple browsers"
        opts.separator ""
        opts.separator "Options"

        opts.on("-c", "--config CONFIG_FILE", "configuration to execute") do |config|
          run_conf(config)
        end

        opts.on("-i", "--init CONFIG_FILE", "create empty config file") do |config|
          file = Pathname.new(config)

          if file.exist?
            puts "Configuration file already exists: #{Pathname.new(config).realpath}"
          else
            File.open(file, 'w+') { |f| f.write(YAML::dump(EMPTY_CONFIG)) }
          end
        end

        opts.on("-v", "--version", "Goggles::VERSION") do
          puts Goggles::VERSION
        end

        opts.on("-h", "--help", "help text") do
          puts opt_parser
        end
      end

      opt_parser.parse!
    end

    def run_conf(config)
      if File.exists? config
        Goggles.swim config
      else
        puts "Not a valid configuration file: #{config}"
      end
    end

    EMPTY_CONFIG = {
      'results_directory' => "/home/example/results",
      'scripts_directory' => "/home/example/scripts",
      'scripts_to_execute' => ["first_example.rb", "second_example.rb"],
      'domain_under_test' => "http://www.google.com",
      'paths_to_capture' => { 'home' => "/", 'gmail' => "/gmail" },
      'browsers' => ["chrome", "firefox"],
      'browser_widths' => [1024, 600],
      'image_fuzzing' => "20%"
    }
  end
end
