# frozen_string_literal: true

MRuby::Gem::Specification.new("robert") do |spec|
  spec.license = "0BSD"
  spec.authors = "0x1eef <0x1eef@hardenedbsd.org>"
  spec.version = "0.1.1"
  spec.description = "Robert is designed to help you learn about FreeBSD"
  spec.rbfiles = Dir[
    File.expand_path("mrblib/*.rb", __dir__),
    File.expand_path("mrblib/**/*.rb", __dir__),
    File.expand_path("build/mrblib/**/*.rb", __dir__)
  ].sort.uniq
end
