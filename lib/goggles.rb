require "goggles/configuration"
require "goggles/comparison"
require "goggles/iteration"

module Goggles
  extend self
  
  def configure &block
    configuration.tap { |conf| yield conf }
  end

  def each browsers = nil, sizes = nil, &block
    browsers ||= configuration.browsers
    sizes    ||= configuration.sizes
    
    browsers.product(sizes).each { |browser, size| Iteration.new browser, size, configuration, &block }
    
    Comparison.new configuration
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end
