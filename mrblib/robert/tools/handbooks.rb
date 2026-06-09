# frozen_string_literal: true

module Robert::Tools
  tool = Robert::Handbook.tool(path: "/handbook/u/search") do |it|
    it.name "search-user-handbook"
    it.description "Search the FreeBSD user's handbook with full-text search"
    it.parameter :q, String, "Tne search query"
    it.required %i[q]
  end
  SearchUsersHandbook = tool

  tool = Robert::Handbook.tool(path: "/handbook/d/search") do |it|
    it.name "search-developer-handbook"
    it.description "Search the FreeBSD developer's handbook with full-text search"
    it.parameter :q, String, "The search query"
    it.required %i[q]
  end
  SearchDevelopersHandbook = tool

  tool = Robert::Handbook.tool(path: "/handbook/p/search") do |it|
    it.name "search-porter-handbook"
    it.description "Search the FreeBSD porter's handbook with full-text search"
    it.parameter :q, String, "The search query"
    it.required %i[q]
  end
  SearchPortersHandbook = tool
end