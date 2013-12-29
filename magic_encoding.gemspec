# -*- immutable: string -*-

Gem::Specification.new do |s|
  s.name = %q{magic_immutable_string}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jared Roesch after Manuel Ryan"]
  s.date = %q{2013-12-28}
  s.default_executable = %q{magic_immutable_string}
  s.email = ["jared@invoca.com"]
  s.executables = ["magic_immutable_string"]
  s.files = Dir.glob("{bin,lib}/**/*") + %w(README.rdoc CHANGELOG LICENCE)
  s.homepage = %q{https://github.com/invoca/magic_immutable_string}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Easily add magic comments for immutable: string on multiple ruby source files}
end
