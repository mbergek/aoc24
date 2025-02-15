#!/usr/bin/env ruby

require 'pqueue'

INF = (2**(0.size * 8 -2) -1)
$matrix = []
$nodes = []

def get(x, y)
  return "#" if offside(x, y)
  $matrix[y][x]
end

def offside(x, y)
  return true if y < 0 || y >= $matrix.size
  return true if x < 0 || x >= $matrix[y].size
  return false
end

class Position
  attr_accessor :x, :y, :z, :cost, :from, :char, :visited

  def forward
    return @forward if @forward
    d = [ [0,-1], [1,0], [0,1], [-1,0] ][@z]
    @forward = $nodes.select { |n| n.x == @x + d[0] && n.y == @y + d[1] && n.z == @z }.first
  end

  def left
    return @left if @left
    @left = $nodes.select { |n| n.x == @x && n.y == @y && n.z == (@z+3) % 4 }.first
    @left.right = self
    return @left
  end
  def left=(val)
    @left = val
  end
  def right
    return @right if @right
    @right = $nodes.select { |n| n.x == @x && n.y == @y && n.z == (@z+1) % 4 }.first
    @right.left = self
    return @right
  end
  def right=(val)
    @right = val
  end

  def neighbours
    [ self.forward, self.left, self.right ].select { |p|  p }
  end
  
  def cost_to(to)
    return (@x-to.x).abs + (@y-to.y).abs + ((@z-to.z) != 0 ? 1000 : 0)
  end

  def self.next
    Position.unvisited.sort_by { |n| n.cost }.first
  end
  def self.unvisited
    $nodes.select { |n| n.visited == false }
  end
  
  def to_s
    "(#{@x}, #{@y}, #{@z}): Cost: #{@cost}"
  end

  def initialize(x, y, z = nil, cost = nil, from = [], char = nil, visited = [nil])
    @x = x
    @y = y
    @z = z
    @cost = cost
    @from = from
    @char = char
    @visited = visited
    
    @forward = nil
    @left = nil
    @right = nil
    
  end
end

# Read input
ARGF.each do |line|
  $matrix << line.chomp.chars
end

## Initialise visited and unvisited
(0...$matrix.size).each do |y|
  (0...$matrix[y].size).each do |x|
    if $matrix[y][x] != '#'
      $nodes << Position.new(x, y, 0, INF, nil, $matrix[y][x], false)
      $nodes << Position.new(x, y, 1, INF, nil, $matrix[y][x], false)
      $nodes << Position.new(x, y, 2, INF, nil, $matrix[y][x], false)
      $nodes << Position.new(x, y, 3, INF, nil, $matrix[y][x], false)
    end
  end
end

puts "Nodes: #{$nodes.size}"

current = $nodes.select { |u| u.z == 1 && u.char == 'S' }.first
current.cost = 0

pq = PQueue.new( [] ){ |a,b| a.cost < b.cost }
pq.push(current)

while !pq.empty?
  current = pq.pop
  current.neighbours.each do |n|
    cost = current.cost + current.cost_to(n)
    if cost == n.cost
      n.from << current
    end
    if cost < n.cost
      n.cost = current.cost + current.cost_to(n)
      n.from = [ current ]
      pq.push(n)
    end
  end
  current.visited = true
end


es = $nodes.select { |u| u.char == 'E' }.min { |n| n.cost }
puts es

used = []
def backtrack(pos, used)
  used << [pos.x, pos.y]
  
  return used if pos.from.nil?

  pos.from.each do |f|
    backtrack(f, used)
  end
  
  return used
end

backtrack(es, used)
puts used.uniq.size

