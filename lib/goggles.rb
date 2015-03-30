require "goggles/configuration"
require "goggles/comparison"

module Goggles
  extend self
  
  def configure &block
    configuration.tap { |conf| yield conf }
  end

  def each &block
    configuration.browsers.each do |browser|
      configuration.sizes.each { |size| yield browser, size }
    end
    Goggles::Comparison.new
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end
