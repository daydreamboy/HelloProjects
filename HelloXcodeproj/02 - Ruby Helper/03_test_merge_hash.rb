require_relative './rubyscript_helper'
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
dict2 = {
    'a' => '1',
    'b' => '2',
    'c' => '3',
    'array' => [1, 2, 3],
    'array2' => [1, 2, 3, [4, 5] ],
    'hash' => {
        'y' => 25,
        'hash-a' => {
            'b' => '2'
        }
    },
    'other_hash' => {
        'z' => 26
    }
}

merged_hash1 = Collection.merge_hash(dict1, dict2)
dump_object(merged_hash1)


