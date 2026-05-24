# frozen_string_literal: true

module Robert::Tools
  ##
  # The {ManPage} tool provides the contents of a man
  # page - alongside an optional section.
  class ManPage < LLM::Tool
    name "man-page"
    description "Returns the contents of a man page"
    parameter :name, String, "The name of the man page"
    parameter :section, Integer, "The man page section (optional)"
    required %i[name]

    def call(name:, section: nil)
      {contents: spawn(name:, section:).stdout}
    end

    private

    def spawn(name:, section:)
      Command
        .new("man")
        .argv(*[section ? section.to_s : nil, name.to_s].compact)
    end
  end
end
