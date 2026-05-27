# frozen_string_literal: true

def main(argv)
  while option = argv.shift
    case option
    when '-v'
      puts Robert::VERSION
      exit(0)
    else
      $stderr.puts "robert: bad option #{option}"
      exit(1)
    end
  end

  llm       = LLM.deepseek(key: ENV["DEEPSEEK_SECRET"])
  ui        = Robert::Tree.build(llm)
  ui.stream = Robert::Stream.new(ui)
  agent     = Robert::Agent.new(llm, stream: ui.stream)
  agent.ui  = ui
  dispatch  = Robert::Dispatch.new(LLM::Object.from(llm:, agent:, ui: agent.ui))

  TUI.run(ui.root) do
    Task.new(name: "event-loop") do
      TUI.draw(ui.root)
      catch(:breakout) do
        loop do
          dispatch.tick(ui.root)
          while event = TUI.peek_event(50)
            dispatch.on_event(event)
          end
        end
      end
    end
    Task.run
  end
end
main(ARGV)
