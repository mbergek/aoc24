#!/usr/bin/env ruby

# Part 1

def char(matrix, x, y)
  return "-" if y < 0 || y >= matrix.size
  return "-" if x < 0 || x >= matrix[y].size
  matrix[y][x]
end

def find_start(matrix)
  (0...matrix.size).each do |y|
    (0...matrix[y].size).each do |x|
      if char(matrix, x, y) == '^'
        return [x, y]
      end
    end
  end
end

def is_on_board?(matrix, x, y)
  return false if x<0
  return false if y<0
  return false if y>=matrix.size
  return false if x>=matrix[y].size
  return true
end

def is_blocked?(matrix, x, y, dir)
  case dir
  when 0
    x2 = x
    y2 = y-1
  when 90
    x2 = x+1
    y2 = y
  when 180
    x2 = x
    y2 = y + 1
  when 270
    x2 = x-1
    y2 = y
  else
    puts "ERROR"
  end
  return true if char(matrix, x2, y2) == '#'
  return false
end

def count_visited(matrix)
  visited = 0
  (0...matrix.size).each do |y|
    (0...matrix[y].size).each do |x|
      if char(matrix, x, y) == '+'
        visited += 1
      end
    end
  end
  visited
end
  
matrix = []
ARGF.each do |line|
  matrix << line.chomp.chars
end

matrix_orig = Marshal.load( Marshal.dump(matrix) )

(x, y) = find_start(matrix)
d = 0

while is_on_board?(matrix, x, y) do
  matrix[y][x] = "+"
  
  if is_blocked?(matrix, x, y, d)
    d = (d + 90) % 360
  else
    case d
    when 0
      y -= 1
    when 90
      x += 1
    when 180
      y += 1
    when 270
      x -= 1
    else
      puts "ERROR"
    end
  end
    
end

puts count_visited(matrix)

# Part 2

loop = 0

(0...matrix_orig.size).each do |y0|
  (0...matrix_orig[y0].size).each do |x0|

    m = Marshal.load( Marshal.dump(matrix_orig) )

    next if char(m, x0, y0) == '^'
    next if char(m, x0, y0) == '#'
    
    (x, y) = find_start(m)
    d = 0
    
    m[y0][x0] = '#'
    moves = 0
    
    while is_on_board?(m, x, y) do
      moves += 1

      if moves > 6000
        loop += 1
        break
      end

      if is_blocked?(m, x, y, d)
        d = (d + 90) % 360
      else
        case d
        when 0
          y -= 1
        when 90
          x += 1
        when 180
          y += 1
        when 270
          x -= 1
        else
          puts "ERROR"
        end
      end
      
    end    
  end
end

puts loop

