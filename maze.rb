class Point
	attr_accessor :x, :y, :parent
	def initialize(x, y, parent)
		@x = x
		@y = y
		@parent = parent
	end
end
class Maze
	attr_accessor :maze
	def initialize(n ,m)
		@n = n
		@m = m
		@string_maze = "1"*(m*n)
		@maze = Array.new(m){Array.new(n){1}}
	end

	def get_position(x, y)
		return maze[y][x]
	end
	#make sure the string is the correct length 
	#to be split and inserted in the array
	def check_string(s)
		return s.length == @m*@n
	end

	def load(s)
		if check_string(s)
			@string_maze
			#s_arr= s.split("").map!{|i| i.to_i}
			s_arr= s.split("").map!{|i| i.to_i}.each_index{|i| @maze[i/@n][i% @n] =s[i]}
		end
			#insert(s_arr)
		end
	end

	#def insert(a)
	#	a.each do |i|
	#		@maze[a.index(i)/@n}[a.index(i)% @n)] = i
	#	end
	#end

	def display(*args)
		m = args[0]
		m ||= @maze
		maze.each do |ar|
			ar.each do |space|
				print space
			end
			puts ""
		end
	end

	def solve(s_x, s_y, e_x, e_y, *args)
		#mass initialization
		queue, found, temp_maze, start = [], false, @maze.clone, Point(s_x, s_y, nil)
		finish
		queue << start
		while !queue.empty?  && !found
			#use .shift to remove and return first element arrays are linked lists
			position = queue.shift
			x, y = position.x, position.y
			if x = e_x && y = e_y
				found = true
				finish = position
			else
				#2 marks positions already visited
				temp_maze[x][y] = 2
				if check_position(x+1, y, temp_maze) then queue << Point.new(x+1, y, position) 
				if check_position(x-1, y, temp_maze) then queue << Point.new(x-1, y, position) 
				if check_position(x, y+1, temp_maze) then queue << Point.new(x, y+1, position) 	
				if check_position(x, y-1, temp_maze) then queue << Point.new(x, y-1, position) 
			end
		end
		args[0].nil? ? found : [found, finish]
	end

	def check_position(x, y, temp_maze)
		return (temp_maze[y][x]==0)
	end

	def trace (s_x, s_y, e_w, e_y)
		found, solution = solve(s_x, s_y, e_w, e_y, true)
		if found
			stack, temp_maze, position = [], @maze.clone, solution
			while !position.parent.nil?
				temp_maze[position.y][position.x] =" "
				stack.push position
			end
			stack.map{|pos| puts "move to :#{pos.x}, #{pos.y}"}

end

