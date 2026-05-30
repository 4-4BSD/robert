# frozen_string_literal: true
load File.join(__dir__, "mrblib/robert/version.rb")

MRuby::Gem::Specification.new("robert") do |spec|
  spec.license = "0BSD"
  spec.authors = "0x1eef <0x1eef@hardenedbsd.org>"
  spec.version = Robert::VERSION
  spec.description = "Robert is designed to help you learn about FreeBSD"
  spec.rbfiles = Dir[
    File.expand_path("mrblib/*.rb", __dir__),
    File.expand_path("mrblib/**/*.rb", __dir__),
    File.expand_path("build/mrblib/**/*.rb", __dir__)
  ].sort.uniq
end
