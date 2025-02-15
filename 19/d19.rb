#!/usr/bin/env ruby

$towels = Array.new
$designs = Array.new
$cache = Hash.new

def can_create_design(design, depth)
  return true if design.size == 0
  
  $towels.each do |t|
    if t == design[0...t.size]
      found = can_create_design(design[t.size...design.size], depth+1)
      return true if found
    end
  end
  
  return false
end


def can_create_design_count(design, depth)
  return 1 if design.size == 0

  return $cache[design] if $cache[design]

  result = 0
  $towels.each do |t|
    if t == design[0...t.size]
      result += can_create_design_count(design[t.size...design.size], depth+1)
    end
  end

  $cache[design] = result
  return result
end


ARGF.each do |line|
  line.chomp!
  next if line.empty?

  if $towels.size == 0
    $towels = line.split(", ")
  else
    $designs << line
  end
end

puts "Number of towel variants     : #{$towels.size}"
puts "Number of designs            : #{$designs.size}"
puts

possible = []
impossible = 0
total = 0
$designs.each do |d|
  #puts "Testing design: #{d}"
  total += can_create_design_count(d, 1)
  if can_create_design(d, 1)
    possible << d
  else
    #puts "Impossible design: #{d}"
    impossible += 1
  end
end

puts "Part 1"
puts "Number of impossible designs : #{impossible}"
puts "Number of possible designs   : #{possible.size}"
puts

puts "Part 2"
puts "Number of combinations       : #{total}"

