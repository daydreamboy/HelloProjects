
s = '"some"'
s = "'some'"

# @see https://www.ruby-forum.com/topic/6878144
# s.gsub!(/\A"|"\z/,'')
s.gsub!(/\A'|'\z/,'')

puts s