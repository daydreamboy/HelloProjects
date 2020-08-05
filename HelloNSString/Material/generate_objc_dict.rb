require 'colored2'
require_relative '/Users/wesley_chen/GitHub_Projects/HelloRuby/ruby_tool/dump_tool.rb'

def SPACE(n)
  '  ' * n
end


def convert_to_objc_code
  string = "@{\n"
  IO.readlines('./Uni2Pinyin', chomp: true).each do |line|
    components = line.split(' ')
    if components.length >= 2
      unicode = components[0]

      string += "#{SPACE(1)}@(0x#{unicode}): @[\n"

      components.delete_at(0)
      components.each do |component|
        component.gsub!(/u:/, 'v')
        matches = /([a-zA-Z]+)([0-9]*)/.match(component).to_a

        if matches.nil?
          puts component
          puts line
        end

        dump_object(matches)

        if matches.length == 3 || matches.length == 2
          pinYin = matches[1]
          firstCharacter = matches[1][0]
          tone = matches[2].length != 0 ? matches[2] : '0'

          string += "#{SPACE(2)}@[\n#{SPACE(3)}@\"#{pinYin}\",\n#{SPACE(3)}@\"#{firstCharacter}\",\n#{SPACE(3)}@#{tone}\n#{SPACE(2)}],\n"
        end
      end

      string += "#{SPACE(1)}],\n"
      # puts "#{components[0].to_i(16)}, #{components[1]}"
    elsif components.length == 1
      # puts "[Warning] ignore `#{line}`".yellow
    else
      puts "[Error] parse components failed: `#{line}`".red
    end
  end
  string += "};\n"
  string
end


def generate_files
  template = IO.read('./template_WCPinYinTable.m')
  unicode2PinYin = convert_to_objc_code
  timestamp = Time.now.to_s
  file = __FILE__

  file_content = template % { unicode2PinYin: unicode2PinYin, timestamp: timestamp, file: file }
  IO.write('./WCPinYinTable.m', file_content)
  # puts unicode2PinYin
end

generate_files
