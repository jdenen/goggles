require "goggles/configuration"
require "goggles/comparison"
require "goggles/iteration"

module Goggles
  extend self
  
  def configure &block
    configuration.tap { |conf| yield conf }
  end

  def each *instance, &block
    args = instance.flatten.map(&:to_s)
    
    sizes = configuration.sizes + args.grep(/\d+/).map(&:to_i)
    browsers = configuration.browsers + args.grep(/[^\d+]/).map(&:to_sym)
    
    browsers.product(sizes).each do |browser, size|
      Iteration.new browser, size, configuration, &block 
    end
    
    Comparison.new(configuration).tap { |comparison| comparison.make! }
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end
