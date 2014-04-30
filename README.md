# lita-keyword-arguments

**lita-keyword-arguments** is an extension for [Lita](https://www.lita.io/) that extracts keyword arguments from messages in the style of command line flags.

## Installation

Add lita-keyword-arguments to your Lita plugin's gemspec:

``` ruby
spec.add_runtime_dependency "lita-keyword-arguments"
```

## Usage

Define keyword arguments for a route using the `kwargs` option. The value should be a hash, mapping keywords to a hash detailing the rules about that keyword.

When the route matches, the response object passed to the handler method will have the `:kwargs` key in its `extensions` attribute populated with the parsed keyword argument values.

Example:

``` ruby
class MyHandler < Lita::Handler
  route(
    /^my_command/,
    :callback
    command: true,
    kwargs: {
      foo: {
        short: "f",
        long: "foo",
        default: "unset"
      },
      verbose: {
        short: "v",
        long: "verbose",
        boolean: true
      }
    }
  )

  def callback(response)
    # response.extensions[:kwargs] will be populated with a hash of keywords and their values.
  end
end
```

The possible keys for each keyword argument's specification are:

* `:short` - A single letter to use for the short flag. Invoked with a single preceeding dash.
* `:long` - A word to use for the long flag. Invoked with two preceeding dashes.
* `:boolean` - The flag represents a boolean and does not have an argument. Set to true by providing the flag. Set to false by providing the long version of the flag, prefixing the keyword with "no-". For example: "--no-verbose".
* `:default` - A default value to give the keyword argument if the flag is not provided in the message.

Either `:short` or `:long` is required. The other keys are optional.

Example messages and their resulting hashes:

``` ruby
# Lita: my_command -f bar
{ foo: "bar" }

# Lita: my_command --foo baz
{ foo: "baz" }

# Lita: my_command -v
{ foo: "unset", verbose: true }

# Lita: my_command --no-verbose
{ foo: "unset", verbose: false }
```

## License

[MIT](http://opensource.org/licenses/MIT)
