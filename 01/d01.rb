#!/usr/bin/env ruby

# Part 1

ax = Array.new
ay = Array.new

ARGF.each do |line|
  x, y = line.scan(/\w+/)
  ax << Integer(x)
  ay << Integer(y)
end

puts ax.sort.zip(ay.sort).inject(0) { |sum, v| sum + (v[0] - v[1]).abs }

# Part 2

hy = Hash.new
hy.default = 0

ay.each do |y|
  hy[y] = hy[y]+1
end

puts ax.inject(0) { |sum, v| sum + v*hy[v] }