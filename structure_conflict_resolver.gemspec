lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "structure_conflict_resolver/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "structure_conflict_resolver"
  s.version     = StructureConflictResolver::VERSION
  s.authors     = ["Justin Aiken"]
  s.email       = ["60tonangel@gmail.com"]
  s.license     = "MIT"
  s.homepage    = "https://github.com/JustinAiken/structure_conflict_resolver"
  s.summary     = %q{Automate tedious db/structure.sql conflict resolution}
  s.description = %q{Automate tedious db/structure.sql conflict resolution}

  s.rubyforge_project = "structure_conflict_resolver"

  s.files           = `git ls-files`.split("\n")
  s.test_files      = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths   = ["lib"]
  s.bindir          = "bin"
  s.executables     = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  s.add_dependency "rainbow",       "~> 3.0"
  s.add_dependency "aasm",          "~> 4.12"

  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "pry"
end
