class Place
	attr_accessor :x, :y, :parent, :weight
	def initialize(x, y, parent, *args)
		@x = x
		@y = y
		@parent = parent
		@weight = args[0]
	end
	def <=> (other)
		@weight<=>other.weight
	end
	#may need to remove not sure if will break any other code
	def == (other)
		if other.class == self.class
			return @x == other.x && @y == other.y
		else
			false
		end
	end

	def eql? (other)
		if other.class == self.class
			return @x == other.x && @y == other.y && @weight==other.weight
		else
			false
		end
	end
	#using this I can use set operations but places are now effecitvely arrays of their x,y coordinates
	def hash
		[@x,@y].hash
	end
end