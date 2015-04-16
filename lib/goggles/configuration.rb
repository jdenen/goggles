module Goggles

  #
  # Stores configuration information for runtime.
  #
  # The `directory` setting +must+ be configured.
  #
  # The `browsers` and `sizes` settings can be extended through `Goggles.each` as arguments.
  # 
  # @see Goggles.each
  # @see Goggles.configure
  #
  class Configuration
    attr_accessor :browsers, :sizes, :fuzzing, :color, :groups
    attr_reader :directory

    def initialize
      @browsers  = []
      @sizes     = []
      @groups    = []
      @directory = ""
      @color     = "blue"
      @fuzzing   = "20%"
    end

    #
    # Ensures the configured path exists, but otherwise acts as a normal
    #  attr_accessor. Path argument must be an absolute path.
    #
    # @param path [String] directory path
    #
    def directory=(path)
      @directory = path
      FileUtils.mkdir_p path unless path.nil? or path.empty?
    end
  end
end
