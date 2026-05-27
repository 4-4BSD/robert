# frozen_string_literal: true

module Robert::Tools
  class Version < LLM::Tool
    name "version"
    description "Provides Robert's version number"

    def call
      {version: "v#{Robert::VERSION}"}
    end
  end
end
