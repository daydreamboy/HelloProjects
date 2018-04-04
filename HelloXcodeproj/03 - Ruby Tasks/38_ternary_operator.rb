
pod_name = 'SomePod'
product_name = nil
# product_name = 'nil'

# if product_name not nil, use it
# if product_name is nil, use pod_name
target_name = product_name || pod_name

puts target_name

