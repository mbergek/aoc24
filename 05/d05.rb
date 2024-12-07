#!/usr/bin/env ruby

rules = Array.new
updates = Array.new
rules_complete = false

def is_ok?(updates, rules)
  rules.each do |r|
    next unless updates.include? r[0]
    next unless updates.include? r[1]

    pr1 = updates.find_index(r[0])
    pr2 = updates.find_index(r[1])

    return false if pr1 > pr2
  end

  return true
end

def correct(updates, rules)
  c = Array.new(updates)

  (0...updates.size).each do |i|
    rules.each do |r|
      next unless c.include? r[0]
      next unless c.include? r[1]

      pr1 = c.find_index(r[0])
      pr2 = c.find_index(r[1])

      if pr1 > pr2
        c[pr1] = r[1]
        c[pr2] = r[0]
      end
    end
  end

  return c
end

sum1 = 0
sum2 = 0

ARGF.each do |line|
  line.chomp!

  if line.size == 0
    rules_complete = true
    next
  end

  if rules_complete
    updates = line.split(",").map { |x| Integer(x) }
    if is_ok?(updates, rules)
      sum1 += updates[(updates.size-1)/2]
    else
      corrected = correct(updates,rules)
      sum2 += corrected[(corrected.size-1)/2]
    end
  else
    rules << line.split("|").map { |x, y| Integer(x, y)}
  end
end

puts sum1
puts sum2
