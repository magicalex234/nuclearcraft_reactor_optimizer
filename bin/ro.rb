#! /usr/bin/env ruby

require_relative "../lib/reactor"

BLOCK_TYPE = [ :reactor, :moderator, :water, :redstone, :quartz, :gold, :glowstone, :lapis, :diamond, :helium, :enderium, :cryotheum, :iron, :emerald, :copper, :magnesium, :tin]

def brute_force_build(i,m)
    dx,dy,dz = m.dimensions

    100000.times do |n|
        x = Random.rand(dx)
        y = Random.rand(dy)
        z = Random.rand(dz)
        block = BLOCK_TYPE[Random.rand(BLOCK_TYPE.size)]

        m.set(x,y,z,block)
        STDOUT.write("#{i}:#{n}:#{m.cell_count}\r")
        break if m.full?
    end
end

pb = 60
hb = 18


mmax = nil
mmax_power = 0
mmax_heat = 0
total_score = 0
total_punishment = 0
iterations = 10000

iterations.times do |i|

    start = Time.now

    while true
        m = Reactor.new(3,3,3,:tbu)
        brute_force_build(i,m)
        p,h = m.evaluate()
        next if h > 0
        break
    end
    duration = Time.now - start
    score = Reactor.score(p,h,duration)
    total_punishment += score if score < 0
    total_score += score
    next if h > 0

    if mmax.nil? || p > mmax_power || ( p == mmax_power && h < mmax_heat )
    
        puts "Iterations: #{i}"
        puts "Power: #{p} from #{mmax_power}"
        puts "Heat : #{h}"

        mmax_power = p
        mmax_heat = h
        mmax = m
        puts mmax.to_s
    end
end

puts
puts
puts "Optimal design tested:"
puts "Power: #{mmax_power}"
        puts "Heat : #{mmax_heat}"
puts
puts mmax.to_s
puts
puts "Score/ms/iteration: #{(total_score/iterations).to_i}"

puts "Done."
