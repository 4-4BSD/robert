# frozen_string_literal: true

module Robert::Tools
  class ReadFile < LLM::Tool
    name "read-file"
    description "Read a file"
    parameter :path, String, "The file path"
    required %i[path]

    def call(path:)
      if Robert.binary?(path)
        raise Robert::Error, "robert cannot read binary files"
      else
        {content: Robert.sanitize(File.read(path))}
      end
    end
  end
end
