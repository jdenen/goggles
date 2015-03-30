require "goggles/configuration"

module Goggles
  class << self
    def configure &block
      yield Goggles::Configuration.new
    end
  end
end
