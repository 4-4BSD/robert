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
    catch(:breakout) do
      loop do
        TUI.draw(ui.root)
        dispatch.on_event(TUI.read_event)
      end
    end
  end
end
main(ARGV)
