require 'json'

$json_string = '
"key": {
  "some": "thing",
}
'

def test1
  JSON.parse($json_string)
end

def test2
  # @see https://stackoverflow.com/questions/27944050/how-to-handle-json-parser-errors-in-ruby
  begin
    JSON.parse($json_string)
  rescue JSON::ParserError
    puts "json is not valid"
  end
end

test2
