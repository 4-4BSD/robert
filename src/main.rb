# frozen_string_literal: true

def main(argv)
  while option = argv.shift
    case option
    when '-v'
      puts Robert::VERSION
      exit(0)
    when '-d'
      $DEBUG = true
    when '-x'
      Robert.disable_confirmations!
    when '-h'
      $stderr.puts <<~USAGE
      robert [OPTIONS]

      Options:
        -h  Show help
        -v  Show version
        -d  Enable debug mode
        -x  Allow tools to run without confirmation
      USAGE
      exit(0)
    else
      $stderr.puts "robert: bad option #{option}"
      exit(1)
    end
  end

  Robert.debug "A new session of Robert has started"
  llm       = LLM.deepseek(key: ENV["DEEPSEEK_SECRET"])
  ui        = Robert::Tree.build(llm)
  ui.stream = Robert::Stream.new Task::Queue.new
  agent     = Robert::Agent.new(llm, stream: ui.stream)
  agent.ui  = ui
  dispatch  = Robert::Dispatch.new(LLM::Object.from(llm:, agent:, ui: agent.ui))

  Task.new(name: "event-loop") do
    TUI.run(ui.root) do
      Robert.set_theme
      begin
        TUI.draw(ui.root)
        catch(:breakout) do
          loop { tick(dispatch, ui) }
        end
        Robert.debug "Robert has exited"
      ensure
        Robert.unset_theme
      end
    end
  rescue => err
    Robert.debug "Robert has crashed"
    crash(err)
  end
  Task.run
end

def tick(dispatch, ui)
  event = TUI.peek_event(5)
  dispatch.on_peek peek_ahead(event) if event
  dispatch.tick(ui)
  dispatch.refresh
  Task.pass
end

def peek_ahead(event)
  events = [event]
  while event = TUI.peek_event(0)
    events << event
  end
  events
end

def crash(err)
  puts "#{err.class}: #{err.message}"
  err.backtrace.each { puts _1 }
  exit 1
end

main(ARGV)
