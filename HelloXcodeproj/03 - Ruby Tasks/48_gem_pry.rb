

h = {
    "bool" => true,
    "number" => 2,
    "string" => "hello",
    "array" => [4, 5, 6],
    "hash" => {
        "key" => "value"
    }
}

# @see http://daguar.github.io/2014/06/05/just-dropped-in-interactive-coding-in-ruby-python-javascript/

# pry-nav provide 'next', 'step', and 'continue' in pry context
# @see https://gist.github.com/lfender6445/9919357
require 'pry-nav'
require 'pry'; binding.pry

h = "replace by a string"

puts "continue to do something"
