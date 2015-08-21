# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = %q{magic_frozen_string_literal}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colin Kelley after Jared Roesch after Manuel Ryan"]
  s.date = %q{2015-8-21}
  s.default_executable = %q{magic_frozen_string_literal}
  s.email = ["colin@invoca.com"]
  s.executables = ["magic_frozen_string_literal"]
  s.files = Dir.glob("{bin,lib}/**/*") + %w(README.rdoc CHANGELOG LICENCE)
  s.homepage = %q{https://github.com/invoca/magic_frozen_string_literal}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Easily add magic comments '# frozen_string_literal: true' on multiple ruby source files}
end
