#encoding: utf-8

# @see https://stackoverflow.com/a/45757084
user_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => %W[
      '$(inherited)'
      '${PODS_ROOT}/Headers/Public/MPMessageContainer/MCTree'
      '${PODS_ROOT}/Headers/Public/MPMessageContainer/MPDynamicCard'
      '${PODS_ROOT}/Headers/Public/MPMessageContainer/MPMUIComponent'
      '${PODS_ROOT}/Headers/Public/MPMessageContainer/MPUIKit'
      ].join(' ')
}
puts user_target_xcconfig

# %w vs. %W @see https://stackoverflow.com/a/690826
foo = "hello"
puts %W(foo bar baz #{foo})
puts %w(foo bar baz #{foo})
