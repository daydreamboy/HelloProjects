require_relative '../02 - Ruby Helper/rubyscript_helper'

require 'uri'
require 'cgi'

url = 'http://h5.m.taobao.com/taopai/shoot.html?preset_record_aspect=0&shot_ratio=111&back_camera=1&max_duration=15&record_decals_off=1&special_effect_off=1&record_music_entry_off=1&show_video_pick=1&record_music_off=1&music_paster=0'

url += '&editor_finish_title=发送'

# @see https://stackoverflow.com/questions/6714196/ruby-url-encoding-string
url_encoded = URI.encode(url)

# @see https://stackoverflow.com/questions/13243195/how-to-parse-a-url-and-extract-the-required-substring
uri = URI(url_encoded)

# @see https://stackoverflow.com/questions/2500462/how-to-extract-url-parameters-from-a-url-with-ruby-or-rails
params = CGI.parse(uri.query)
# Note: sort hash by keys
# @see https://stackoverflow.com/questions/4339553/sort-hash-by-key-return-hash-in-ruby
params = params.sort.to_h

# @see https://stackoverflow.com/a/11251654
query = URI.encode_www_form(params)
uri.query = query

puts uri.to_s







