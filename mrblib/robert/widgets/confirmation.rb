# frozen_string_literal: true

module Robert::Widgets
  ##
  # {Confirmation} renders an inline status-bar confirmation prompt.
  class Confirmation
    HINT = "[Enter/y] allow [n/Esc] deny"

    ##
    # @param [LLM::Object] ui
    # @param [LLM::Function] tool
    def initialize(ui, tool)
      @ui = ui
      @tool = tool
      @queue = Task::Queue.new
      @resolved = false
    end

    ##
    # Prompt for confirmation and resolve the tool call.
    #
    # @param [Symbol] strategy
    # @return [LLM::Function::Return]
    def confirm(strategy)
      ui.stream.task_queue.push ["confirmation", self]
      if @queue.pop == :allow
        tool.spawn(strategy).wait
      else
        tool.cancel(reason: "user denied tool execution")
      end
    ensure
      ui.stream.task_queue.push ["confirmation_done", nil]
    end

    ##
    # Approve the pending tool call.
    # @return [void]
    def allow
      ui.status.left, ui.status.right = "Please wait.", ""
      TUI.draw(ui.root)
      resolve(:allow)
    end

    ##
    # Deny the pending tool call.
    # @return [void]
    def deny
      resolve(:deny)
    end

    ##
    # @return [String]
    def hint
      HINT
    end

    ##
    # @return [String]
    def prompt
      case tool.name
      when "find"
        "Allow robert search for the file #{tool.arguments.name} in #{tool.arguments.root} ?"
      when "grep"
        "Allow robert to search for the term #{tool.arguments.string} in #{tool.arguments.root} ?"
      when "read-file"
        "Allow robert to read #{tool.arguments.path} ?"
      else
        "Allow robert to run #{tool.name}?"
      end
    end

    private

    attr_reader :ui, :tool

    def resolve(decision)
      return if @resolved
      @resolved = true
      @queue.push(decision)
    end
  end
end
