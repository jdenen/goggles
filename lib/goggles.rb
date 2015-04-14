require "goggles/configuration"
require "goggles/comparison"
require "goggles/iteration"

module Goggles
  extend self

  #
  # Yields the global configuration object to a block.
  #
  # @yield  [Goggles::Configuration] global configuration
  # @return [Goggles::Configuration] global configuration
  #
  def configure &block
    configuration.tap { |conf| yield conf }
  end

  #
  # Creates an Iteration object for each combination of browser and width derived from global
  #  configuration and given arguments. 
  #
  # @param instance [Array<String,Fixnum,Symbol>, String, Fixnum, Symbol] configuration extension
  # @return [Goggles::Comparison]
  # @see Goggles::Iteration
  #
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

  #
  # @api private
  #
  def configuration
    @configuration ||= Configuration.new
  end
end
