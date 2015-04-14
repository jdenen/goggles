require "goggles/configuration"
require "goggles/comparison"
require "goggles/iteration"

module Goggles
  extend self
  
  def configure &block
    configuration.tap { |conf| yield conf }
  end

  def each browsers = nil, sizes = nil, &block
    instance_config = configuration.dup.tap do |c|
      c.browsers << browsers unless browsers.nil?
      c.sizes << sizes unless sizes.nil?
    end
    
    instance_config.browsers.product(instance_config.sizes).each do |browser, size|
      Iteration.new browser, size, configuration, &block 
    end
    
    Comparison.new(configuration).tap { |comparison| comparison.make! }
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end
