require "spec_helper"

describe Lita::Extensions::KeywordArguments::Parser do
  it "parses long flags" do
    subject = described_class.new(
      { foo: {} },
      "--foo bar".split
    )

    expect(subject.parse).to eq(foo: "bar")
  end

  it "parses mdash flags" do
    subject = described_class.new(
      { foo: {} },
      "—foo bar".split
    )

    expect(subject.parse).to eq(foo: "bar")
  end

  it "sets missing arguments to nil" do
    subject = described_class.new(
      { foo: {} },
      "--foo".split
    )

    expect(subject.parse).to eq(foo: nil)
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
      { foo: { boolean: true } },
      "--foo".split
    )

    expect(subject.parse).to eq(foo: true)
  end

  it "parses inverted long boolean flags" do
    subject = described_class.new(
      { foo: { boolean: true, default: true } },
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
      { foo: { default: "bar" } },
      "".split
    )

    expect(subject.parse).to eq(foo: "bar")
  end

  it "overrides defaults when values are supplied" do
    subject = described_class.new(
      { foo: { default: "bar" } },
      "--foo baz".split
    )

    expect(subject.parse).to eq(foo: "baz")
  end

  it "parses known options even when an unknown option is encountered first" do
    subject = described_class.new(
      { foo: { short: "f", boolean: true } },
      "-x -f".split
    )

    expect(subject.parse).to eq(foo: true)
  end
end
