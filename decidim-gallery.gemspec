# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/gallery/version"

Gem::Specification.new do |s|
  s.version = Decidim::Gallery.version
  s.authors = ["Alexandru-Emil Lupu"]
  s.email = ["contact@alecslupu.ro"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/alecslupu-pfa/decidim-module-gallery"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-gallery"
  s.summary = "A decidim gallery module"
  s.description = "Decidim Gallery Module."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin", ">= 0.26.0", "< 0.28.0"
  s.add_dependency "decidim-core", ">= 0.26.0", "< 0.28.0"
  s.add_development_dependency "decidim-participatory_processes", ">= 0.26.0", "< 0.28.0"
  s.metadata["rubygems_mfa_required"] = "true"
end
