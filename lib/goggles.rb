require "goggles/configuration"
require "goggles/comparison"

module Goggles
  class << self
    def configure &block
      @configuration ||= Goggles::Configuration.new.tap { |conf| yield conf }
    end

    def each
      Goggles::Comparison.new
    end
  end
end
