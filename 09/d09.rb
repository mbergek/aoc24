#!/usr/bin/env ruby

fat = Array.new

id = 0
ARGF.read.chars.map { |c| Integer(c) }.each_slice(2) do |a, b|
  fat += Array.new(a, id)
  fat += Array.new(b, nil) unless b.nil?
  id += 1
end

head = 0
tail = fat.size - 1

while tail > head
  while ! fat[head].nil? && tail > head
    head += 1
  end  
  while fat[tail].nil? && tail > head
    tail -= 1
  end
  fat[head] = fat[tail]
  fat[tail] = nil  
end

sum = 0
(0...fat.size).each do |i|
  sum += i * fat[i] unless fat[i].nil?
end

puts sum
