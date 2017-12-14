require_relative '../02 - Ruby Helper/rubyscript_helper'
require 'pp'

dict1 = {
    'a' => '1',
    'b' => '3',
    'array' => [1, 2],
    'array2' => [1, 2, 3, [5, 6] ],
    'hash' => {
        'x' => 24,
        'hash-a' => {
            'a' => '1',
            'b' => '1'
        }
    }
}

dump_object(dict1)
pp dict1


