require "goggles/configuration"
require "goggles/comparison"
require "goggles/iteration"

module Goggles
  extend self
  
  def configure &block
    configuration.tap { |conf| yield conf }
  end

  def each &block
    configuration.browsers.each do |browser|
      configuration.sizes.each { |size| Iteration.new browser, size, configuration, &block }
    end
    Comparison.new
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end
