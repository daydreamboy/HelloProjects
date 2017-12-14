require_relative '../02 - Ruby Helper/rubyscript_helper'

dict1 = {
    'a' => '1',
    'array' => [1, 2],
    'hash' => {
        'x' => 24,
    }
}
dict2 = {
    'a' => '1',
    'b' => '2',
    'array' => [1, 2, 3],
    'hash' => {
        'y' => 25,
    }
}

# merge方法按照key进行合并，如果dict1和dict2有相同key，dict2中key对应的value会覆盖dict1中，而且value是容器时不会递归合并
merged_dict = dict1.merge(dict2)

dump_object(merged_dict)
# {"a"=>"1", "array"=>[1, 2, 3], "hash"=>{"y"=>25}, "b"=>"2"}
