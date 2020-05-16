require_relative "cube"

class Reactor
    def initialize(x,y,z,pb,hb)
        @cube = Cube.new(x,y,z)
        @pb = pb
        @hb = hb
        @count = 0
    end

    def set(x,y,z,v)

        raise "can't set cell to nil" if v.nil?

        # One set it can not be changed
        return false if @cube.get(x,y,z) != nil

        case v
        when :reactor
            # always valid
        when :water 
            return false unless adj?(x,y,z,:reactor) || adj?(x,y,z,:moderator) 
        when :redstone, :moderator
            return false unless adj?(x,y,z,:reactor)  
        when :quartz           
            return false unless adj?(x,y,z,:moderator) 
        when :gold
            return false unless adj?(x,y,z,:water) && adj?(x,y,z,:redstone)
        when :glowstone
            return false unless adj_count(x,y,z,:moderator) >= 2
        when :lapis
            return false unless adj?(x,y,z,:reactor) && @cube.side?(x,y,z)
        when :diamond
            return false unless adj?(x,y,z,:water) && adj?(x,y,z,:quartz)
        when :helium
            return false unless adj_count(x,y,z,:redstone) == 1 && @cube.side?(x,y,z)
        when :enderium
            return false unless @cube.corner?(x,y,z)
        when :cryotheum
            return false unless adj_count(x,y,z,:reactor) >= 2
        when :iron
            return false unless adj?(x,y,z,:gold)
        when :emerald
            return false unless adj?(x,y,z,:moderator) && adj?(x,y,z,:reactor)
        when :copper
            return false unless adj?(x,y,z,:glowstone)
        when :magnesium
            return false unless adj?(x,y,z,:moderator) && @cube.side?(x,y,z)
        when :tin 
            return false unless adj_on_axis?(x,y,z,:lapis)
        else
            raise "This cube is a valid reactor cell 'v''"
        end

        @cube.set(x,y,z,v)
        @count += 1
        true
    end

    def get(x,y,z)
        return :casing if x < 0
        return :casing if y < 0
        return :casing if z < 0

        dx,dy,dz = @cube.dimensions

        return :casing if x > dx-1
        return :casing if y > dy-1
        return :casing if z > dz-1

        @cube.get(x,y,z)
    end

    def adj?(x,y,z,type)
        # was dad's good idea
        adj_count(x,y,z,type) != 0
    end

    def adj_on_axis?(x,y,z,type)
        #alex did this on his own
        if adj_count(x,y,z,type) >= 2 || ((get(x+1,y,z) == type && get(x-1,y,z) == type) || (get(x,y+1,z) == type && get(x,y-1,z) == type) || (get(x,y,z+1) == type && get(x,y,z-1) == type))
            true
        else
            false
        end
    end


    def to_s
        @cube.to_s
    end

    def cell_count
        @count
    end

    def full?
        dx,dy,dz = @cube.dimensions
        cell_count == dx*dy*dz
    end

    def dimensions
        @cube.dimensions
    end

    def adj_count(x,y,z,type)
        # was alex's good idea
        c = 0
        c += 1 if get(x+1,y,z) == type
        c += 1 if get(x-1,y,z) == type
        c += 1 if get(x,y+1,z) == type
        c += 1 if get(x,y-1,z) == type
        c += 1 if get(x,y,z+1) == type
        c += 1 if get(x,y,z-1) == type
        c
    end

    def reactor_data(x,y,z)
        v = get(x,y,z)

        return [0,0] unless v == :reactor

        adj_reactors = adj_count(x,y,z,:reactor)

        p = @pb * ( 1 + adj_reactors)
        h = @hb * ( 1 + adj_reactors) * ( 2 + adj_reactors) / 2

        [p,h]
    end

    def modifier_calc(x,y,z,p,h)
        pr,hr = reactor_data(x,y,z)
        e = pr / @pb
        p +=  @pb * e / 6
        h +=  @hb * e / 3

        #puts "p=#{p} h=#{h} e=#{e}"

        [p,h]
    end

    def evaluate()
        p = 0
        h = 0

        dx,dy,dz = @cube.dimensions
    
        dx.times do |x|
          dy.times do |y|
            dz.times do |z|
              case get(x,y,z)
              when :reactor

                pr,hr = reactor_data(x,y,z)
                #puts "pr=#{pr} hr=#{hr}"

                p += pr
                h += hr

              when :moderator
                p,h = modifier_calc(x+1,y,z,p,h)
                p,h = modifier_calc(x-1,y,z,p,h)
                p,h = modifier_calc(x,y+1,z,p,h)
                p,h = modifier_calc(x,y-1,z,p,h)
                p,h = modifier_calc(x,y,z+1,p,h)
                p,h = modifier_calc(x,y,z-1,p,h)    
              when :water
                h -= 60
              when :redstone
                h -= 90
            when :quartz
                h -= 90
            when :gold
                h -= 120
            when :glowstone
                h -= 130
            when :lapis
                h -= 120
            when :diamond
                h -= 150
            when :helium   
                h -= 140
            when :enderium
                h -= 120
            when :cryotheum
                h -= 160
            when :iron
                h -= 80
            when :emerald
                h -= 160
            when :copper
                h -= 80
            when :magnesium
                h -= 110
            when :tin
                h -= 120

              when nil
                ## Do Nothing as this is empty
              else
                raise "This cube as a block has I don't undestand what to do '#{get(x,y,z)}''"
              end
            end
        end
        end
    return [p,h]
    end
end