#!/usr/bin/env ruby

$matrix = Array.new

class Plot 
  attr_accessor :x, :y, :borders, :sides, :plant
  def initialize(x, y, plant)
    @plant = plant
    @x = x
    @y = y

    # Calculate borders according to first definition
    @borders = 0
    @borders += 1 if char(x+1, y).upcase != @plant
    @borders += 1 if char(x, y+1).upcase != @plant
    @borders += 1 if char(x-1, y).upcase != @plant
    @borders += 1 if char(x, y-1).upcase != @plant

    # Calculate sides according to second definition
    @sides = 0

    (0..3).each do |d|
      if dchar(x, y, 1, 0, d).upcase != @plant
        while true
          break if dchar(x, y, 0, -1, d).upcase == @plant && dchar(x, y, 1, -1, d).upcase != @plant
          @sides += 1
          break
        end
      end
    end
  end
end

class Region
  attr_accessor :plots, :plant
  
  def add_plots(x, y)
    return if char(x, y) != @plant

    @plots << Plot.new(x, y, @plant)
    $matrix[y][x] = @plant.downcase

    add_plots(x+1, y) if char(x+1, y) == @plant
    add_plots(x, y+1) if char(x, y+1) == @plant
    add_plots(x-1, y) if char(x-1, y) == @plant
    add_plots(x, y-1) if char(x, y-1) == @plant
  end
  
  def price
    @plots.inject(0) { |s, v| s + @plots.size * v.borders}
  end
  def price2
    @plots.inject(0) { |s, v| s + @plots.size * v.sides}
  end

  def initialize(x, y)
    @plant = char(x, y)
    @plots = Array.new
    add_plots(x, y)
  end
end

def dchar(x, y, forward, right, direction)
  case direction
  when 0
    return char(x+right, y-forward)
  when 1
    return char(x+forward, y+right)
  when 2
    return char(x-right, y+forward)
  when 3
    return char(x-forward, y-right)
  else
    return nil
  end
end

def char(x, y)
  return "-" if y < 0 || y >= $matrix.size
  return "-" if x < 0 || x >= $matrix[y].size
  $matrix[y][x]
end

ARGF.each do |line|
  $matrix << line.scan(/\w/)
end

regions = Array.new

(0...$matrix.size).each do |y|
  (0...$matrix[y].size).each do |x|
    next if char(x, y) == char(x, y).downcase
    r = Region.new(x, y)
    regions << r
  end
end

total = 0
total2 = 0
regions.each do |r|
  puts "Region    : #{r.plant}"
  puts "  Size    : #{r.plots.size}"
  puts "  Borders : #{r.plots.inject(0) { |s, v| s+v.borders }}"
  puts "  Sides   : #{r.plots.inject(0) { |s, v| s+v.sides }}"
  puts "  Price1  : #{r.price}"
  puts "  Price2  : #{r.price2}"
  total += r.price
  total2 += r.price2
end

puts total
puts total2