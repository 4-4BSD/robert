# frozen_string_literal: true

module Robert
  ##
  # The {Agent} class implements an agent
  # with a set of predefined tools and a
  # system prompt that is injected on the
  # first turn.
  class Agent < LLM::Agent
    instructions Robert.prompt
    tools { Robert.tools }
    confirm :tools

    attr_accessor :ui

    ##
    # @return [Task::Queue]
    def queue
      stream.task_queue
    end

    ##
    # @param [LLM::Function] tool
    # @param [Symbol] strategy
    # @return [LLM::Function::Return]
    def on_tool_confirmation(tool, strategy)
      Widgets::Confirmation.new(ui, tool).confirm(strategy)
    end

    private

    ##
    # @return [Array<String>]
    def tools
      Robert.disable_confirmations? ? [] : filesystem_tools
    end

    ##
    # @return [Array<String>]
    def filesystem_tools
      ["read-file", "grep", "find"]
    end
  end
end
