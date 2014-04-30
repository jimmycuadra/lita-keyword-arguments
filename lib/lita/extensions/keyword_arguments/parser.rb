require 'optparse'

module Lita
  module Extensions
    class KeywordArguments
      class Parser
        attr_reader :kwargs, :args, :spec

        def initialize(spec, args)
          @spec = spec
          @args = args
          @kwargs = {}
        end

        def parse
          spec.each { |name, option_spec| add_option(name, option_spec) }

          begin
            parser.parse(args)
          rescue OptionParser::InvalidOption
          end

          add_defaults

          kwargs
        end

        private

        def add_defaults
          spec.each do |name, option_spec|
            kwargs[name] ||= option_spec[:default] if option_spec[:default]
          end
        end

        def add_option(name, spec)
          return unless spec[:short] || spec[:long]

          parser.on(*spec_args(spec)) do |value|
            kwargs[name] = clean_value(value)
          end
        end

        def clean_value(value)
          if TrueClass === value || FalseClass === value
            value
          elsif value.nil?
            nil
          else
            value.strip
          end
        end

        def parser
          @parser ||= OptionParser.new
        end

        def spec_args(spec)
          opt_args = []

          if spec[:short] && spec[:boolean]
            opt_args << "-#{spec[:short]}"
          elsif spec[:short]
            opt_args << "-#{spec[:short]} [VALUE]"
          end

          if spec[:long] && spec[:boolean]
            opt_args << "--[no-]#{spec[:long]}"
          elsif spec[:long]
            opt_args << "--#{spec[:long]} [VALUE]"
          end

          opt_args
        end
      end
    end
  end
end
