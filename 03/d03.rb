#!/usr/bin/env ruby

# Part 1

sum = 0
data = "do()"

ARGF.each do |line|
  data << line.chomp    # Save for part 2
  sum = line.scan(/mul\((\d+),(\d+)\)/).inject(sum) do |s, v| 
    s + Integer(v[0]) * Integer(v[1])
  end
end

puts sum

# Part 2

enabled = ""
data.split("don't()").each do |str|
  e = str.split("do()", 2)
  enabled << e[1] if e.size > 1
end

sum2 = enabled.scan(/mul\((\d+),(\d+)\)/).inject(0) do |s, v| 
  s + Integer(v[0]) * Integer(v[1])
end  

puts sum2