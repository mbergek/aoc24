#!/usr/bin/env ruby

def safe?(values)
  aa = values.first(values.size-1)
  ab = values.last(values.size-1)
  di = aa.zip(ab).map { |v| v[1] - v[0] }

  # Test if min and max are within [-3, -1] or [1, 3]
  (di.max <= 3 && di.min >= 1) || (di.max <= -1 && di.min >= -3)
end

def dampener(values)
  # Return all variants of the array
  rv = []
  (0...values.size).each do |i|
    v = Array.new(values)
    v.delete_at(i)
    rv << v
  end
  rv
end

safe1 = 0
safe2 = 0

ARGF.each do |line|
  values = line.scan(/\w+/).map { |v| Integer(v) }

  if safe?(values)
    safe1 = safe1 + 1
  else
    dampener(values).each do |v|
      if safe?(v)
        safe2 = safe2 + 1
        break
      end
    end

  end
end

puts safe1
puts safe1+safe2
