module Robert
  module Tools
  end

  module Widgets
  end

  ##
  # @return [Array<LLM::Tool>]
  def self.tools
    [
      Tools::ManPage,
      Tools::ManSearch,
    ]
  end
end
