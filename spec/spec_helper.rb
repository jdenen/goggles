require 'rspec'
require 'rspec-given'

require 'goggles'

RSpec.configure do |config|
  config.order = 'default'
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :skip => true
end
