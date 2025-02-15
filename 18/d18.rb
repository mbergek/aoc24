#!/usr/bin/env ruby

require 'parslet'
require 'parslet/convenience'
require 'pqueue'

INF = (2**(0.size * 8 -2) -1)
BIG = INF/2


class Mini < Parslet::Parser
  rule(:cr) { match('[\n]').repeat(0) }
  rule(:eol?) { any.absent? | cr }
  rule(:integer) { match('[+-]').repeat(0) >> match('[0-9]').repeat(1) }
  rule(:coordinate) { integer.as(:x) >> str(',') >> integer.as(:y) >> eol? }
  rule(:coordinates) { coordinate.repeat(1) }
  root(:coordinates)
end

def display(map)
  (0...map.size).each do |y|
    puts map[y].map { |x| x[2] > BIG ? '#' : '.' }.join 
  end
end

def dijkstra(coords, bytes)
  max_x = coords.max { |a, b| a[0] <=> b[0] }[0]
  max_y = coords.max { |a, b| a[1] <=> b[1] }[1]

  map = Array.new(max_y + 1){Array.new(max_x + 1)}
  (0...map.size).each do |y|
    (0...map[y].size).each do |x|
      map[y][x] = [x, y, BIG, nil]
    end
  end

  coords[0...bytes].each do |c|
    map[c[1]][c[0]][2] = INF
  end
  
  puts
  display(map)
  # Update start position
  map[0][0][2] = 0
  
  pq = PQueue.new( {} ){ |a,b| a[2] < b[2] }
  pq.push(map[0][0])

  while !pq.empty?
    current = pq.pop
    
    # Find neighbours
    ns = []
    [ [0,-1], [1,0], [0,1], [-1,0] ].each do |n|
      next if current[0] + n[0] < 0 || current[0] + n[0] > max_x
      next if current[1] + n[1] < 0 || current[1] + n[1] > max_y
      next if map[current[1] + n[1]][current[0] + n[0]][2] == INF
      ns << map[current[1] + n[1]][current[0] + n[0]]
    end
    
    ns.each do |n|
      if current[2] + 1 < n[2]
        n[2] = current[2] + 1
        n[3] = [current[0], current[1]]
        pq.push(n)
      end
      
      if n[0] == max_x && n[1] == max_y
        return n[2]
      end
    end
  end
  return nil
end

# Parse input
input = ARGF.read
coords = Mini.new.parse_with_debug(input)
coords.map! { |v| [ v[:x].to_i, v[:y].to_i] }

# Part 1
max_x = coords.max { |a, b| a[0] <=> b[0] }[0]
max_y = coords.max { |a, b| a[1] <=> b[1] }[1]

# Select number of bytes based on input
bytes = max_x < 10 ? 12 : 1024

puts dijkstra(coords, bytes)

# Part 2

while true
  steps = dijkstra(coords, bytes)
    
  if steps.nil?
    puts "No longer any exit at byte count: #{bytes}"
    puts "Last byte was: #{coords[bytes-1]}"
    exit
  end
  
  bytes += 1
end

  
