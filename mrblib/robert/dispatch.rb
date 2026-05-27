# frozen_string_literal: true

module Robert
  class Dispatch
    def initialize(context)
      @ui = context.ui
      @llm = context.llm
      @agent = context.agent
      @last_event = 0.0
      @worker = nil
      @stream_queue = nil
      @stream_buffer = +""
      @wakeup = Task::Queue.new
    end

    def on_event(event)
      now = Time.now.to_f
      elapsed = now - @last_event
      @last_event = now

      if event.key?(:CTRL_C) && @worker
        @worker.terminate rescue nil
        @worker = nil
        @stream_queue = nil
        status_bar.left = "Cancelled"
        status_bar.right = Tree::HINTS
      elsif event.key?(:CTRL_C)
        throw(:breakout)
      elsif event.key?(:ENTER) && elapsed < 0.05
        ui.input.put("\n")
      elsif event.key?(:ENTER)
        on_submit(event)
        TUI.draw(ui.root)
      elsif event.ch == 0x0A
        ui.input.put("\n")
      elsif TUI.backspace?(event.key)
        ui.input.backspace
      elsif event.key?(:UP)
        ui.chat.scroll_up
      elsif event.key?(:DOWN)
        ui.chat.scroll_down
      elsif event.ch == 0x15
        ui.input.clear
      elsif event.ch >= 0x20 && event.ch <= 0x7E
        ui.input.put(event.ch.chr)
      elsif event.event?(:RESIZE)
        TUI.draw(ui.root)
      end
    end

    def start_worker(prompt)
      @stream_queue = Task::Queue.new
      queue = @stream_queue
      wakeup = @wakeup
      llm = @llm
      @worker = Task.new(name: "llm-worker") do
        agent = Robert::Agent.new(llm, stream: Robert::QueueStream.new(queue))
        begin
          agent.talk(prompt)
          queue.push("done")
        rescue => ex
          queue.push("error:#{ex.message}")
        end
        wakeup.push(nil)
      end
    end

    def tick(root)
      if @worker
        drain_stream_queue
        if @worker.status == :DORMANT
          status_bar.left = "Idle"
          status_bar.right = Tree::HINTS
          @worker = nil
          @stream_queue = nil
        end
      end
      TUI.draw(root)
    end

    private

    attr_reader :llm, :agent, :ui

    def drain_stream_queue
      return unless @stream_queue
      loop do
        msg = @stream_queue.pop(true) rescue nil
        break unless msg
        case msg
        when /\Acontent:(.*)\z/m
          @stream_buffer << $1
        when /\Atool_call:(.*)\z/
          ui.status.right = $1
        when "done"
          # will be handled in tick
        when /\Aerror:(.*)\z/m
          ui.chat.replace_last(:assistant, "Error: #{$1}")
        end
      end
      if @stream_buffer
        ui.chat.replace_last(:assistant, Markdown.new(@stream_buffer.rstrip).ast)
      end
    end

    def on_submit(_event)
      return if ui.input.empty?
      message = ui.input.value
      ui.center.show(ui.chat) unless showing_chat?
      agent.stream.clear
      ui.input.clear
      @stream_buffer = +""
      ui.chat.add(:user, message)
      ui.chat.add(:assistant, "")
      status_bar.left = "Thinking..."
      status_bar.right = ""
      start_worker(message)
    end

    def status_bar
      ui.status
    end

    def showing_chat?
      ui.chat.parent == ui.center
    end
  end
end
