require "spec_helper"

describe Lita::Extensions::KeywordArguments::Parser do
  it "requires ignores keys that don't have a short or long flag" do
    subject = described_class.new(
      { foo: {} },
      "--foo bar".split
    )

    expect(subject.parse).to be_empty
  end

  it "parses long flags" do
    subject = described_class.new(
      { foo: { long: "foo" } },
      "--foo bar".split
    )

    expect(subject.parse).to eq(foo: "bar")
  end

  it "parses short flags" do
    subject = described_class.new(
      { foo: { short: "f" } },
      "-f bar".split
    )

    expect(subject.parse).to eq(foo: "bar")
  end

  it "parses long boolean flags" do
    subject = described_class.new(
      { foo: { long: "foo", boolean: true } },
      "--foo".split
    )

    expect(subject.parse).to eq(foo: true)
  end

  it "parses inverted long boolean flags" do
    subject = described_class.new(
      { foo: { long: "foo", boolean: true } },
      "--no-foo".split
    )

    expect(subject.parse).to eq(foo: false)
  end

  it "parses short boolean flags" do
    subject = described_class.new(
      { foo: { short: "f", boolean: true } },
      "-f".split
    )

    expect(subject.parse).to eq(foo: true)
  end

  it "includes defaults" do
    subject = described_class.new(
      { foo: { long: "foo", default: "bar" } },
      "".split
    )

    expect(subject.parse).to eq(foo: "bar")
  end

  it "overrides defaults when values are supplied" do
    subject = described_class.new(
      { foo: { long: "foo", default: "bar" } },
      "--foo baz".split
    )

    expect(subject.parse).to eq(foo: "baz")
  end
end
