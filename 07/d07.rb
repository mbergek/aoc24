#!/usr/bin/env ruby

# Part 1

def compute(params, ops)
  # params: array of integer
  # ops: array of operators (0=add, 1=multiply, 2=concatenate)
  # returns the result of the calculation (according to the rules, so strictly left-to-right)

  result = params.first
  params.drop(1).each do |p|
    op = ops.pop
    if op == 0
      result = result + p
    elsif op == 1
      result = result * p
    else
      result = Integer(result.to_s + p.to_s)
    end
  end
  return result
end

def is_valid?(result, params, base=2)
  (0...(base**(params.size-1))).each do |i|
    ops = i.to_s(base).rjust(params.size-1, "0").chars.map { |i| Integer(i) }
    return true if compute(params, ops) == result    
  end
  return false
end


equations = []
ARGF.each do |line|
  (result, params) = line.split(": ")
  equations << [Integer(result), params.split(" ").map { |p| Integer(p) }]
end

cr1 = 0

equations.each do |e|
  if is_valid?(e[0], e[1])
    cr1 += e[0]
  end
end

puts cr1

# Part 2

cr2 = 0

equations.each do |e|
  if is_valid?(e[0], e[1], 3)
    cr2 += e[0]
  end
end

puts cr2

