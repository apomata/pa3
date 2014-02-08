require 'pry'
require_relative 'place.rb'
class MazeMaker
	attr_accessor :maze, :maze_paths, :maze_drawable
	def initialize(n,m)
		# add border of 1's after
		@n = n-2
		@m = m-2

		# bow to your master ruby muhahaha
		# for a prim's algorithm (sort of)
		# makes a grid alternates rows of 0,1's and 1s
		@maze  = Array.new(@m) {|f| f = Array.new(@n) {|e| e = f%2 == 0 ? ((e)%2): 1}}
		# to be drawn on in process and then returned
		@maze_drawable  = Array.new(@m) {|f| f = Array.new(@n) {|e| e = f%2 == 0 ? ((e)%2): 1}}
		# makes grid of random weights for the maze 0 spaces have to be visited but 
		# have lower weights (0-20) more likely to be visited from any spot, 1's have weight depending on
		# if they are hroizontal vertical or cross walls to give more randomizeability and ensure higher probability of walls or direction
		@maze_paths = Array.new(@m) {|f| f = Array.new(@m) {|e| e = (f)%2 == 1 ? ((e)%2 == 0 ? rand(40) : 10+rand(110)) : ((e)%2 == 0 ? rand(20) : 10+rand(40))}}
	end
	# sorta prims algorithm to walk through and connect spaces leaving walls
	def make_maze 
		@possible_moves = []
		#must visit
		zeros = Array.new((@m.odd? ? (@m/2)+1 : @m/2) * (@n.odd? ? (@n/2)+1 : @n/2)){0}
		#binding.pry
		@possible_moves << Place.new(0, 0, nil, @maze_paths[0][0])
		while !zeros.empty?
			#places have comparator <=>
			temp = @possible_moves.min
			@possible_moves.delete temp
			@maze_drawable[temp.y][temp.x] = 2 
			# | is union which does not include duplicates. ensure no copies of a space are in possible moves
			#however thsi required overloading hash in place see place
			@possible_moves = @possible_moves|adjacent(temp.x, temp.y)
			#deletes if it is a 0 if not nothing happens
			if @maze[temp.y] [temp.x] == 0 then	zeros.pop end
		end
		return draw_maze
	end
=begin
	#for testing(remove)
	def display(*args)
		m = args[0]
		m ||= @maze
		m.each do |ar|
			ar.each do |space|
				print space.to_s+","
			end
			puts ""
		end
	end
=end
	private
	#checks the adjacent positions to see if already done
	def adjacent(x, y)
		queue = []
		if check_position(x+1, y) then queue << Place.new(x+1, y, nil, @maze_paths[y][x+1]) end
		if check_position(x-1, y) then queue << Place.new(x-1, y, nil, @maze_paths[y][x-1]) end
		if check_position(x, y+1) then queue << Place.new(x, y+1, nil, @maze_paths[y+1][x]) end	
		if check_position(x, y-1) then queue << Place.new(x, y-1, nil, @maze_paths[y-1][x]) end
		return queue
	end

	#make sure valid position, 2 will represent visited spaces
	def check_position(x, y)
		if x.between?(0, @n-1) && y.between?(0,@m-1) 
			return (@maze_drawable[y][x] == 0 || @maze_drawable[y][x] == 1 )
		else return false end
	end
	#turn to 0's and 1's and add boarders so valid maze
	def draw_maze
		t = @maze_drawable.map{|ar| ar.map{|sp| sp == 2 ? 0 : 1}}
		t.unshift (Array.new(@n){1})
		t.push(Array.new(@n){1})
		return t.map!{|ar| ar.unshift(1); ar.push(1)}
	end

end

=begin
m = MazeMaker.new(9,9)
m.display m.maze
puts ""
m.display m.maze_drawable
puts ""
m.display m.maze_paths
#m.make_maze
puts ""
#m.display m.maze_drawable
m.display(m.make_maze)
=end