require "goggles/configuration"

module Goggles
  class << self
    def configure &block
      @configuration ||= Goggles::Configuration.new.tap { |conf| yield conf }
    end
  end
end
