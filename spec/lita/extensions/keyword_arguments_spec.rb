require "spec_helper"

describe Lita::Extensions::KeywordArguments, lita: true do
  let(:message) { instance_double("Lita::Message", args: []) }
  let(:parser) { instance_double("Lita::Extensions::KeywordArguments::Parser", parse: {}) }
  let(:response) { instance_double("Lita::Response", extensions: {}, message: message) }
  let(:route) { instance_double("Lita::Handler::Route", extensions: { kwargs: {} }) }

  describe ".call" do
    before { allow(Lita::Extensions::KeywordArguments::Parser).to receive(:new).and_return(parser) }
    it "adds kwargs to the response's extensions data" do
      described_class.call(response: response, route: route)
      expect(response.extensions[:kwargs]).not_to be_nil
    end

    it "does nothing if the route did not include a kwargs spec" do
      route.extensions.delete(:kwargs)
      described_class.call(response: response, route: route)
      expect(response.extensions[:kwargs]).to be_nil
    end
  end
end
