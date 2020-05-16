require "test/unit"
require_relative '../lib/cube'
require_relative '../lib/reactor'

class CubeTest < Test::Unit::TestCase

    def test_corners
    m = Cube.new(3,3,3)
    assert_true m.corner?(0,0,0)
    assert_false m.corner?(0,0,1)
    end

  def test_sides
    m = Cube.new(3,3,3)
    3.times do |x|
        3.times do |y|
            3.times do |z|
                next if x ==1 && y == 1 && z == 1
                assert_true m.side?(x,y,z)
            end
        end
    end
    assert_false m.side?(1,1,1)
  end 

  def test_out_of_bounds_errors
    m = Cube.new(3,3,3)
    assert_raise { m.n(3,3,3) }
    assert_nothing_raised { m.n(1,1,1) }
    assert_raise { m.n(-1,-1,-1) }
  end

  def test_nnn
    do_cube_test(3,3,3)
    do_cube_test(3,5,3)
    do_cube_test(5,3,6)
  end


    def test_eval_empty_reactor
        pb = 60
        hb = 18
        m = Reactor.new(3,3,3,pb,hb)
        p,h = m.evaluate()
        assert_equal(0,p)
        assert_equal(0,h)    
    end   

 def test_eval1
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    assert_true m.set(0,0,0,:reactor)
    p,h = m.evaluate()
    assert_equal(pb,p)
    assert_equal(hb,h)
    assert_false m.full?
    assert_equal(1,m.cell_count)
 end    
 def test_eval2
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(1,0,0,:reactor)
    p,h = m.evaluate()
    assert_equal(240,p)
    assert_equal(108,h)
 end   

 def test_eval3
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(1,0,0,:reactor)
    assert_true m.set(0,1,0,:reactor)
    p,h = m.evaluate()
    assert_equal(420,p)
    assert_equal(216,h)
 end   
 
 def test_eval4
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(1,0,0,:reactor)
    assert_true m.set(0,1,0,:reactor)
    assert_true m.set(0,0,1,:reactor)
    p,h = m.evaluate()
    assert_equal(600,p)
    assert_equal(342,h)
 end    

 def test_water
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add water to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(1,0,0,:water)
    p,h = m.evaluate()
    assert_equal(60,p)
    assert_equal(-42,h)
 end

 def test_bad_water
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add water to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_false m.set(1,1,1,:water)
    assert_true m.set(0,1,0,:water)
 end

 def test_bad_redstone
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add water to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_false m.set(1,1,1,:redstone)
    assert_true m.set(0,0,1,:redstone)
 end

 def test_redstone
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add water to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(1,0,0,:redstone)
    p,h = m.evaluate()
    assert_equal(60,p)
    assert_equal(-72,h)
 end

 def test_bad_moderator
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add mdoerator to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_false m.set(1,1,1,:moderator)
    assert_true m.set(0,0,1,:moderator)
 end

 def test_moderator1
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add water to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(1,0,0,:moderator)
    p,h = m.evaluate()
    assert_equal(70,p)
    assert_equal(24,h)
 end

 def test_moderator2
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    # We can't add water to this location because there is no reactor adjacent
    assert_true m.set(0,0,0,:reactor)
    assert_true m.set(0,1,0,:reactor)
    assert_true m.set(1,0,0,:moderator)
    p,h = m.evaluate()
    assert_equal 260,p
    assert_equal 120,h
    assert_false m.full?
    assert_equal 3,m.cell_count
 end


 def do_cube_test(a,b,c)
    m = Cube.new(a,b,c)
    ck = Array.new(a*b*c,false)
    3.times do |x|
        3.times do |y|
            3.times do |z|
            n = m.n(x,y,z)
            assert (n >= 0)
            assert (n < a*b*c)
            assert_false ck[n]
            ck[n] = true
        end
    end
end
end

def test_random_reactor_and_water
    pb = 60
    hb = 18
    1000.times do 
        m = Reactor.new(3,3,3,pb,hb)
        x = Random.rand(3)
        y = Random.rand(3)
        z = Random.rand(3)
        assert_true m.set(x,y,z,:reactor)

        x = true
        while x
            x = Random.rand(3)
            y = Random.rand(3)
            z = Random.rand(3)
            x = false if m.set(x,y,z,:water)
        end 

        p,h = m.evaluate()
        assert_equal(60,p)
        assert_equal(-42,h)
    end
end



=begin
def test_eval5
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    assert_true m.set(1,0,0,:reactor)
    assert_true m.set(1,1,0,:reactor)
    assert_true m.set(2,0,2,:reactor)
    assert_true m.set(2,2,0,:reactor)
    assert_true m.set(0,1,0,:moderator)
    assert_true m.set(2,1,0,:moderator)
    assert_true m.set(0,0,0,:redstone)
    assert_true m.set(1,2,0,:redstone)
    assert_true m.set(0,2,0,:water)
    assert_true m.set(2,0,0,:quartz)
    assert_true m.set(2,2,1,:moderator)
    assert_true m.set(0,0,1,:reactor)
    assert_true m.set(1,0,1,:redstone)
    assert_true m.set(2,0,1,:redstone)
    assert_true m.set(0,1,1,:quartz)
    assert_true m.set(1,1,1,:water)
    assert_true m.set(2,1,1,:quartz)
    assert_true m.set(0,2,1,:reactor)
    assert_true m.set(1,2,1,:quartz)

    #TODO alex fix this
    #p,h = m.evaluate()
    #assert_equal(840,p)
    #assert_equal(-732,h)
    assert_true m.full?
    assert_equal(27,m.cell_count)
 end  
=end


def test_full
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)

    3.times do |x|
        3.times do |y|
            3.times do |z|
                assert_true m.set(x,y,z,:reactor)
            end
        end
    end

    
    assert_true m.full?
    assert_equal(27,m.cell_count)
end


def test_eval7
    pb = 60
    hb = 18
    m = Reactor.new(3,3,3,pb,hb)
    assert_true m.set(0,1,0,:reactor)
    assert_true m.set(0,1,2,:reactor)
    assert_true m.set(0,0,0,:lapis)
    assert_true m.set(0,0,2,:lapis)
    assert_true m.set(0,0,1,:tin)
    assert_true m.adj_on_axis?(0,0,1,:lapis)
    assert_true m.adj_on_axis?(0,1,1,:reactor)
    assert_false m.adj_on_axis?(0,0,1,:reactor)
end

end


