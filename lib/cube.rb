class Cube
  
  def initialize(x,y,z)
    @dim_x = x
    @dim_y = y
    @dim_z = z
    @dx = @dim_x - 1
    @dy = @dim_y - 1
    @dz = @dim_z - 1 
    @data=Array.new(@dim_x*@dim_y*@dim_z)
  end

  def dimensions
    [@dim_x,@dim_y,@dim_z]
  end
  
  def get(x,y,z)
    @data[n(x,y,z)]
  end
  
  def set(x,y,z,v)
    @data[n(x,y,z)] = v
  end
  
  def side?(x,y,z)
    return true if x == 0 || x == @dx
    return true if y == 0 || y == @dy
    return true if z == 0 || z == @dz
    false
  end
  
  def corner?(x,y,z)
    return true if x == 0 && y == 0 && z == 0 
    return true if x == @dx && y == 0 && z == 0
    return true if x == 0 && y == @dy && z == 0 
    return true if x == @dx && y == @dy && z == 0
    return true if x == 0 && y == 0 && z == @dx 
    return true if x == @dx && y == 0 && z == @dx
    return true if x == 0 && y == @dy && z == @dx 
    return true if x == @dx && y == @dy && z == @dx
    false
  end
  
  def n(x,y,z)
    raise "bad x" if x > @dx || x < 0
    raise "bad y" if y > @dy || y < 0
    raise "bad z" if z > @dz || z < 0
    x + @dim_x * y + @dim_x*@dim_y * z
  end


  def to_s
    s = ""
    s += "-"*37 + "\n"
    @dim_z.times do |z|
        @dim_y.times do |y|
          s += "| "
            @dim_x.times do |x|
                s += "#{get(x,y,z).to_s.ljust(9)} | "
            end
            s += "\n"
        end
        s += "-"*37 + "\n"
    end

    s
end

end