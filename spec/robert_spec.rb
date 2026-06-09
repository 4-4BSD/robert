# frozen_string_literal: true

describe "Robert" do
  describe ".sanitize" do
    it "drops control bytes that are unsafe in JSON strings" do
      expect(Robert.sanitize("a\0b\x01c")).must_equal "abc"
    end

    it "keeps normal text whitespace" do
      expect(Robert.sanitize("a\nb\rc\td")).must_equal "a\nb\rc\td"
    end

    it "sanitizes nested tool payloads" do
      payload = {content: ["a\0b", {path: "/tmp/x\x02"}]}
      expect(Robert.sanitize(payload)).must_equal({content: ["ab", {path: "/tmp/x"}]})
    end
  end

  describe ".binary?" do
    subject { Robert.binary?(path) }

    context "when given a binary file" do
      let(:path) { "/bin/ls" }
      it "returns true" do
        expect(subject).must_equal(true)
      end
    end

    context "when given a text file" do
      let(:path) { "./README.md" }
      it "returns false" do
        expect(subject).must_equal(false)
      end
    end
  end
end

Minitest.run(ARGV) || exit(1)
