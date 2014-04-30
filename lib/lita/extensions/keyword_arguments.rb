module Lita
  module Extensions
    class KeywordArguments
      def self.call(payload)
        spec = payload[:route].extensions[:kwargs]

        if spec
          response = payload[:response]
          kwargs = Parser.new(spec, response.message.args).parse
          response.extensions[:kwargs] = kwargs
        end
      end
    end

    Lita.register_hook(:trigger_route, KeywordArguments)
  end
end
