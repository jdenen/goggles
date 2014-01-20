require 'goggles'
require 'optparse'

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

  end
end
