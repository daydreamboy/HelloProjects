
arr = %w(
    "WXSDK/project/tcmpushsdk/inet/inet/tcm/tcmprotocol/TcmslogsrvPack.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/tcm/tcmprotocol/WxaccessPack.{h,m,mm,c,cpp}",
)

replaced_arr = arr.map { |item| item.gsub(/\..*/, ".h") }

puts replaced_arr