unless ENV["NO_COVERALLS"]
  require "coveralls"
  Coveralls.wear!
end

require "structure_conflict_resolver"

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
