#!/usr/bin/env ruby

$matrix = []

def get_score(x, y, expected)
  return 0 if y < 0 || y >= $matrix.size
  return 0 if x < 0 || x >= $matrix[y].size
  return 0 if $matrix[y][x] != expected
  return 1 if expected == 9

  return  get_score(x+1, y, expected + 1) +
          get_score(x, y+1, expected + 1) +
          get_score(x-1, y, expected + 1) +
          get_score(x, y-1, expected + 1)
end

def get(x, y)
  return nil if y < 0 || y >= $matrix.size
  return nil if x < 0 || x >= $matrix[y].size
  return $matrix[y][x]
end

def reachable(x, y, value)
  return [] unless get(x, y) == value
  return [[x, y]] if value == 9

  r = Array.new
  r += reachable(x+1, y, value + 1) if get(x+1, y) == value + 1
  r += reachable(x, y+1, value + 1) if get(x, y+1) == value + 1
  r += reachable(x-1, y, value + 1) if get(x-1, y) == value + 1
  r += reachable(x, y-1, value + 1) if get(x, y-1) == value + 1

  return r.reject { |v| v.nil? }.uniq
end

ARGF.each do |line|
  $matrix << line.scan(/\w/).map { |v| Integer(v) }
end

score1 = 0
score2 = 0

(0...$matrix.size).each do |y|
  (0...$matrix[y].size).each do |x|
    score1 += reachable(x, y, 0).size if get(x, y) == 0
    score2 += get_score(x, y, 0)
  end
end

puts score1
puts score2