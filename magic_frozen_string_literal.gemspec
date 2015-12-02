# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = %q{magic_frozen_string_literal}
  spec.version = "0.0.2"

  spec.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if spec.respond_to? :required_rubygems_version=
  spec.authors = ["Colin Kelley after Jared Roesch after Manuel Ryan"]
  spec.date = %q{2015-08-21}
  spec.executables = ["magic_frozen_string_literal"]
  spec.email = ["colin@invoca.com"]
  spec.executables = ["magic_frozen_string_literal"]
  spec.files = Dir.glob("{bin,lib}/**/*") + %w(README.rdoc CHANGELOG LICENCE)
  spec.homepage = %q{https://github.com/invoca/magic_frozen_string_literal}
  spec.require_paths = ["lib"]
  spec.rubygems_version = %q{1.3.6}
  spec.summary = %q{Easily add magic comments '# frozen_string_literal: true' on multiple ruby source files}
  spec.homepage      = "https://github.com/Invoca/magic_frozen_string_literal"
  spec.license       = "MIT"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
