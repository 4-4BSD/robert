# frozen_string_literal: true

module Robert::Tools
  class SearchHandbook < LLM::Tool
    name "search-handbook"
    description "Search the FreeBSD handbook with full-text search"
    parameter :q, String, "Tne search query"
    required %i[q]

    def call(q:)
      res = Curl.get(endpoint, params: {q:})
      JSON.parse(res.body)
    end

    private

    def endpoint
      "https://4.4bsd.dev/handbook/u/search"
    end
  end
end
