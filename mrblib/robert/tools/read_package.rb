module Robert::Tools
  class ReadPackage < LLM::Tool
    name "read-package"
    description "Read package metadata from the pkg(8) database"
    parameter :name, String, "The package name"

    def call(name:)
      Robert.spawn command(name:)
    end

    private

    def command(name:)
      Command
        .new("pkg")
        .argv("search", "-f")
        .argv(name)
    end
  end
end
