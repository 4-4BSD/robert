##
# The {Robert::Handbook} module creates a single subclass
# of LLM::Tool for each FreeBSD handbook. Compared to the
# the rest of the codebase, this module is a little unusual
# because it solves code re-use through meta-programming, and
# usually I try to avoid meta-programming because it can get
# complex quickly.
module Robert::Handbook
  extend self

  ##
  # @param [String] path
  # @param [Proc] b
  # @return [LLM::Tool]
  def tool(path:, &b)
    Class.new(LLM::Tool) do
      instance_exec(self, &b)

      def call(q:)
        res = Curl.get(endpoint, params: {q:})
        JSON.parse(res.body)
      end

      define_method(:endpoint) do
        path = path[0] == "/" ? path[1..] : path
        "https://4.4bsd.dev/#{path}"
      end
    end
  end
end