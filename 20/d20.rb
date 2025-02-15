#!/usr/bin/env ruby

require 'pqueue'

INF = (2**(0.size * 8 -2) -1)
BIG = INF/2

$map = []

def display
  (0...$map.size).each do |y|
    puts $map[y].map { |x| x[2] > BIG ? '#' : '.' }.join 
  end
end

def dijkstra(start, finish)
  max_y = $map.size
  max_x = $map[0].size
  
  # Reset cost and from
  (1...$map.size-1).each do |y|
    (1...$map[y].size-1).each do |x|
      if $map[y][x][2] < INF
        $map[y][x] = [x, y, BIG, nil]
      end
    end
  end
  
  # Update start position
  $map[start[1]][start[0]][2] = 0
  
  pq = PQueue.new( {} ){ |a,b| a[2] < b[2] }
  pq.push($map[start[1]][start[0]])

  while !pq.empty?
    current = pq.pop
    
    # Find neighbours
    ns = []
    [ [0,-1], [1,0], [0,1], [-1,0] ].each do |n|
      next if current[0] + n[0] < 0 || current[0] + n[0] > max_x
      next if current[1] + n[1] < 0 || current[1] + n[1] > max_y
      next if $map[current[1] + n[1]][current[0] + n[0]][2] == INF
      ns << $map[current[1] + n[1]][current[0] + n[0]]
    end
    
    ns.each do |n|
      if current[2] + 1 < n[2]
        n[2] = current[2] + 1
        n[3] = [current[0], current[1]]
        pq.push(n)
      end
    end
  end
  return $map[finish[1]][finish[0]][2]
end

ARGF.each do |line|
  $map << line.chomp.chars
end

(0...$map.size).each do |y|
  (0...$map[y].size).each do |x|
    if $map[y][x] == 'S'
      $start = [x, y]
    end
    if $map[y][x] == 'E'
      $finish = [x, y]
    end

    if $map[y][x] == '#'
      $map[y][x] = [x, y, INF, nil]
    else
      $map[y][x] = [x, y, BIG, nil]
    end
  end
end

display

pp $start
pp $finish

base = dijkstra($start, $finish)

puts "Base time: #{base}"

path=[]
f=$finish
while f
  path << f
  f = $map[f[1]][f[0]][3]
end
path.reverse!

def get_cheats(path, radius, minimum)
  cheats = []
  
  path.each do |c|

    cx = c[0]
    cy = c[1]
    walls = []

    (-radius..radius).each do |dy|
      (-radius+dy.abs..radius-dy.abs).each do |dx|
        next if [dx,dy] == [0,0]
        next if cy+dy < 0 || cy+dy >= $map.size
        next if cx+dx < 0 || cx+dx >= $map[cy+dy].size

        d = dx.abs + dy.abs
        
        next if $map[cy+dy][cx+dx][2] == INF
        
        gain = $map[cy+dy][cx+dx][2] - $map[cy][cx][2] - d
        
        if gain > minimum
          #puts "(#{cx}, #{cy}) -> (#{cx+dx}, #{cy+dy}): #{gain}"
          cheats << [ [cx, cy, cx+dx, cy+dy], gain ]
        end
      end
    end
  end
  return cheats
end


cheats = get_cheats(path, 2, 0)
puts "Total number of cheats        : #{cheats.size}"
puts "Total number of cheats >= 100 : #{cheats.select { |c| c[1] >= 100}.size}"

# Part 2
puts
puts "Part 2"
cheats = get_cheats(path, 20, 0)
puts "Total number of cheats        : #{cheats.size}"
puts "Total number of cheats >= 100 : #{cheats.select { |c| c[1] >= 100}.size}"
