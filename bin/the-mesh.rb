#!/usr/bin/env ruby
# The Mesh Solver
#
# $ echo '15 8 8 5 9 9 x2' | bin/the-mesh.rb
# -8 -8 -5 x2 9 9 => 15
#

def calc(op, arr)
  return op.to_i if arr.empty?

  right = calc(arr[0], arr[1..-1])
  return op.to_i unless right

  case op.to_s
  when /\A-?\d+\z/
    (op.to_i + right).abs
  when 'x2'
    right * 2
  when '/2'
    right.even? ? right / 2 : nil
  else
    raise "unexpected op #{op.inspect}"
  end
end

def trans(x)
  case x
  when /\A-?\d+\z/
    (-x.to_i).to_s
  when 'x2'
    '/2'
  when '/2'
    'x2'
  else
    raise "cannot trans #{x.inspect}"
  end
end

def dig(arr, expected)
  (1...arr.length).each do |i|
    (0...arr.length).to_a.combination(i).each do |pat|
      a = arr.dup
      pat.each do |idx|
        a[idx] = trans a[idx]
      end
      ans = calc a[0], a[1..-1]
      if ans == expected
        return a
      end
    end
  end
  nil
end

def dump(arr, ans)
  puts "#{arr.join(' ')} => #{ans}"
end

lines = ARGF.read.chomp.split(/\s+/)
expected = lines.shift.to_i
lines.permutation.each do |arr|
  comb = dig(arr, expected)
  if comb
    dump comb, expected
    exit 0
  end
end

puts "pattern not found"
