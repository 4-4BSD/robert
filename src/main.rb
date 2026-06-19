# frozen_string_literal: true

##
# main

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
      help
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

  TUI.run(ui.root) do
    Robert.set_theme
    TUI.draw(ui.root)
    reason = catch(:breakout) do
      while true
        tick(dispatch, ui)
        Task.pass
      end
    end
    Robert.debug "Robert has exited: '#{reason}'"
  ensure
    Robert.unset_theme
  end
rescue => err
  Robert.debug [
    "Robert has crashed: ",
    "#{err.class}: #{err.message}",
    err.backtrace.join("\n")
  ].join("\n")
  crash(err)
end

##
# utils

def tick(dispatch, ui)
  event = TUI.peek_event(Robert.poll_interval)
  dispatch.on_peek peek_ahead(event) if event
  Task.pass
  dispatch.tick(ui)
  dispatch.refresh
end

def peek_ahead(event)
  events = [event]
  while events.length < Robert.max_events
    event = TUI.peek_event(0)
    break if event.nil?
    events << event
  end
  events
end

def help
  $stderr.puts <<~USAGE
  robert [OPTIONS]

  Options:
    -d  Enable debug mode
    -x  Allow tools to run without confirmation
    -v  Show version
    -h  Show help
  USAGE
end

def crash(err)
  puts "#{err.class}: #{err.message}"
  err.backtrace.each { puts _1 }
  exit 1
end

##
# Let's go

main(ARGV)
