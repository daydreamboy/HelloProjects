#encoding: utf-8
#

HORSES = [
    {
        :name => "Slow and not furious",
        :also_known_as => ["Tender","Terrible Choice"],
        :speed => 1, :intelligence => 10,
        :favorite_quote => "Pick me once, regret it for a lifetime."
    }
]

class String
  # Note: add category method to existing class
  def horse
    res = HORSES.select { |h| h[:name] == self || h[:also_known_as].include?(self)}
    res.first if res.length > 0
  end
end

#Then you can do stuff like this :
horse = "Tender".horse
if horse
  puts "#{horse[:name]}, also known as #{horse[:also_known_as].join(", ")}, has a speed of #{horse[:speed]} and an intelligence of #{horse[:intelligence]}. In its free time, this horse becomes a philosopher, looks at the sky and often says : '#{horse[:favorite_quote]}'"
else
  puts "This horse doesn't exists in our records"
end
