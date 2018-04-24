require 'pry'

h = {
    "podspec" => {
        "somePod1" => {
            "sub_pod" => {
                "somePod2" => {
                    "path" => '../',
                    "universal_framework" => true
                }
            }
        }
    }
}

def convert_attribute_key_to_symbol(hash)
  hash.each do |key, value|
    # @see https://stackoverflow.com/questions/800122/best-way-to-convert-strings-to-symbols-in-hash
    # @see https://stackoverflow.com/questions/710501/need-a-simple-explanation-of-the-inject-method
    if value.is_a?(Hash)
      value = value.inject({}) {|memo, (k, v)| memo[k.to_sym] = v; memo}
    end

    hash[key] = value
  end

  hash.values.each do |value1|
    if value1.is_a?(Hash)
      value1.values.each do |value2|
        if value2.is_a?(Hash)
          convert_attribute_key_to_symbol(value2)
        end
      end
    end
  end
end

convert_attribute_key_to_symbol(h['podspec'])
puts h

