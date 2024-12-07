#!/usr/bin/env ruby

$matrix = []

def char(x, y)
  return "-" if y < 0 || y >= $matrix.size
  return "-" if x < 0 || x >= $matrix[y].size
  $matrix[y][x]
end

def words(x, y)
  w = []
  w<< char(x, y) + char(x+1, y+0) + char(x+2, y+0) + char(x+3, y+0)
  w<< char(x, y) + char(x+1, y+1) + char(x+2, y+2) + char(x+3, y+3)
  w<< char(x, y) + char(x+0, y+1) + char(x+0, y+2) + char(x+0, y+3)
  w<< char(x, y) + char(x-1, y+1) + char(x-2, y+2) + char(x-3, y+3)
  w<< char(x, y) + char(x-1, y+0) + char(x-2, y+0) + char(x-3, y+0)
  w<< char(x, y) + char(x-1, y-1) + char(x-2, y-2) + char(x-3, y-3)
  w<< char(x, y) + char(x+0, y-1) + char(x+0, y-2) + char(x+0, y-3)
  w<< char(x, y) + char(x+1, y-1) + char(x+2, y-2) + char(x+3, y-3)
end

def crosswords(x, y)
  w = []
  w<< char(x-1, y-1) + char(x, y) + char(x+1, y+1)
  w<< char(x-1, y+1) + char(x, y) + char(x+1, y-1)
end

ARGF.each do |line|
  $matrix <<line.scan(/\w/)
end

count1 = 0
count2 = 0
(0...$matrix.size).each do |y|
  (0...$matrix[y].size).each do |x|
    count1 += words(x, y).select { |v| v == "XMAS" }.count
    count2 += 1 if crosswords(x, y).select { |v| v == "MAS" || v == "SAM" }.count == 2
  end
end

puts count1
puts count2

