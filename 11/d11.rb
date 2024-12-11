#!/usr/bin/env ruby

def blink(input)
  output = Hash.new
  output.default = 0
  input.each do |k, v|
    if k == 0
      output[1] = output[1] + v
      next
    end

    ks = k.to_s
    if ks.size % 2 == 0
      l = Integer(ks[0, ks.size / 2])
      r = Integer(ks[ks.size / 2, ks.size / 2].gsub(/^0*([0-9]+)/, '\1'))
      output[l] = output[l] + v
      output[r] = output[r] + v
      next
    end

    output[k*2024] = output[k*2024] + v

  end
  return output
end

ARGF.each do |line|
  h = Hash.new
  line.scan(/\w+/).map { |v| h[Integer(v)] = 1 }

  (1..75).each do |i|
    h = blink(h)
    puts h.inject(0) { |s, (k, v)| s + v} if i==25
  end

  puts h.inject(0) { |s, (k, v)| s + v}
end
