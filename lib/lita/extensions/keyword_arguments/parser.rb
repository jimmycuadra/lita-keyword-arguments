require 'slop'

module Lita
  module Extensions
    class KeywordArguments
      class Parser
        attr_reader :args, :spec

        def initialize(spec, args)
          @spec = spec
          @args = prepare_args(args)
        end

        def parse
          spec.each { |name, option_spec| add_option(name, option_spec) }
          parser.parse(args)
          parser.to_hash
        end

        private

        def add_option(name, spec)
          opt_args = []
          opt_options = {}

          opt_args << spec[:short] if spec[:short]
          opt_args << name
          opt_options[:default] = spec[:default] if spec[:default]
          opt_options[:optional_argument] = true unless spec[:boolean]
          opt_args << opt_options

          parser.on(*opt_args)
        end

        def prepare_args(args)
          args.map do |arg|
            arg.tr('—', '--')
          end
        end

        def parser
          @parser ||= Slop.new
        end
      end
    end
  end
end
