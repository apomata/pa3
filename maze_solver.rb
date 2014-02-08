require_relative 'place.rb'
require 'pry'
class MazeSolver
	def initialize(n, m, maze, start, end_p)
		@maze = maze
		@n, @m = n, m
		if check_position(start.x, start.y, @maze)
			@start = start
		else puts "invalis start" end 
		if check_position(start.x, start.y, @maze)
			@end = end_p
		else puts"invalid end" end
	end
	#determins if it can solve a maze and returns the end place if asked for and found (for trace)
	def solve(*args)
		queue, found, finish  = [], false, nil
		#ruby always pass by reference even if dupe and clone are used 
		#this serializes string of complex objext then deserializes it to break the chain of reference
		temp_maze =  Marshal.load(Marshal.dump(@maze))
		queue << @start 
		#standard bredth first search
		while !queue.empty?  && !found
			#use .shift to remove and return first element arrays are linked lists
			position = queue.shift
			x, y = position.x, position.y
			#if x == @end.x && y == @end.y
			if position == @end
				found, finish = true, position
			else
				#2 marks positions already visited
				temp_maze[y][x] = 2
				children(x,y,temp_maze, position).each{|pl|queue<<pl}
			end
		end
		args[0].nil? ? found : [found, finish]
	end

	#figure out spaces can move to
	def children(x, y, temp_maze, parent)
		queue = []
		if check_position(x+1, y, temp_maze) then queue << Place.new(x+1, y, parent) end
		if check_position(x-1, y, temp_maze) then queue << Place.new(x-1, y, parent) end
		if check_position(x, y+1, temp_maze) then queue << Place.new(x, y+1, parent) end	
		if check_position(x, y-1, temp_maze) then queue << Place.new(x, y-1, parent) end
		return queue
	end

	#make sure valid position
	def check_position(x, y, temp_maze)
		if x.between?(0, @n-1) && y.between?(0,@m-1)
			return (temp_maze[y][x]== 0)
		else return false end
	end

	#solves puzzle and prints steps with maze 
	def trace
		found, solution = solve(true)
		if found
			stack, temp_maze, position = [], Marshal.load(Marshal.dump(@maze)), solution
			#print steps
			while !position.nil?
				temp_maze[position.y][position.x] =" "
				stack.push position
				position = position.parent
			end
			stack.reverse.map{|pos| puts "move to :#{pos.x}, #{pos.y}"}
			puts ""
			#print maze with path and start  and end indicated
			temp_maze[@start.y][@start.x] = "s"
			temp_maze[@end.y][@end.x] = "e"
			return temp_maze
		end
	end
end