# frozen_string_literal: true

module Robert::Tools
  class ManSearch < LLM::Tool
    name "man-search"
    description "Search the manual pages for keyword(s)"
    parameter :keywords, Array[String], "One or more keywords to search for"
    required %i[keywords]

    def call(keywords:)
      {results: spawn(keywords:).stdout}
    end

    private

    def spawn(keywords:)
      Command
        .new("apropos")
        .argv(*keywords)
    end
  end
end
