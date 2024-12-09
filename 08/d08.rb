#!/usr/bin/env ruby

def get(m, x, y)
  return "-" if offside(m, x, y)
  m[y][x]
end

def set(m, x, y, c) 
  return if offside(m, x, y)
  m[y][x] = c
end

def offside(m, x, y)
  return true if y < 0 || y >= m.size
  return true if x < 0 || x >= m[y].size
  return false
end

def count(m)
  count = 0
  m.each do |y|
    y.each do |x|
      count += 1 if x != '-'
    end
  end
  count
end

matrix = []
ARGF.each do |line|
  matrix << line.chomp.chars
end

size = [ matrix[0].size, matrix.size ]

antennas = Hash.new

(0...size[0]).each do |x|
  (0...size[1]).each do |y|
    next if get(matrix, x, y) == "."
    if antennas.has_key?(get(matrix, x, y))
      antennas[get(matrix, x, y)] << [x, y]
    else
      antennas[get(matrix, x, y)] = [[x, y]]
    end
  end
end

antinodes = Array.new(size[0]) { Array.new(size[1]) { "-" } }

antennas.each do |k, v|
  v.combination(2).each do |v|
    x0 = v[0][0]
    y0 = v[0][1]
    x1 = v[1][0]
    y1 = v[1][1]
    dx = x1 - x0
    dy = y1 - y0
    
    set(antinodes, x0-dx, y0-dy, '#')
    set(antinodes, x1+dx, y1+dy, '#')
  end
end

puts count(antinodes)

# Part 2

antinodes2 = Array.new(size[0]) { Array.new(size[1]) { "-" } }

antennas.each do |k, v|
  v.combination(2).each do |v|
    x0 = v[0][0]
    y0 = v[0][1]
    x1 = v[1][0]
    y1 = v[1][1]
    dx = x1 - x0
    dy = y1 - y0

    set(antinodes2, x0, y0, k)
    set(antinodes2, x1, y1, k)
    
    (1..size[0]).each do |i| 
      break if offside(antinodes2, x0-i*dx, y0-i*dy)   
      set(antinodes2, x0-i*dx, y0-i*dy, '#')
    end
    (1..size[0]).each do |i| 
      break if offside(antinodes2, x1+i*dx, y1+i*dy)   
      set(antinodes2, x1+i*dx, y1+i*dy, '#')
    end
  end
end

puts count(antinodes2)
