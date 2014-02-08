require_relative 'maze_solver.rb'
require_relative 'place.rb'
require_relative 'maze_maker.rb'
require 'pry'
class Maze
	attr_accessor :maze
	def initialize(n ,m)
		@n = n
		@m = m
		@maze = Array.new(m){Array.new(n){1}}
	end

	#return item at position x y
	def get_position(x, y)
		return maze[y][x]
	end

	#make sure the string is the correct length 
	#to be split and inserted in the array
	def check_string(s)
		return s.length == @m*@n
	end

	#take string insert into array
	def load(s)
		if check_string(s)
			s_arr= s.split("").each_index{|i| @maze[i/@n][i% @n] = s[i].to_i}
		end
	end

	#prints the maze
	def display(*args)
		m = args[0]
		m ||= @maze
		m.each do |ar|
			ar.each do |space|
				print space.to_s
			end
			puts ""
		end
	end
	
	#make sure a place is within the boundarys of a maze and a valid position
	#mazes should me made of 0's and 1s 
	def check_place(place)
		if place.x.between?(0, @n-1) && place.y.between?(0,@m-1)
			return (@maze[place.y][place.x]== 0)
		else return false end
	end

	#returns weather a maze can be solved or not
	def solve(s_x, s_y, e_x, e_y)
		start = Place.new( s_x, s_y, nil)
		end_p = Place.new(e_x, e_y, nil)
		if check_place(start)&&check_place(end_p)
			return MazeSolver.new(@n, @m, @maze, start, end_p).solve
		else puts "invalid start or end" end
	end

	#solzes the maze and produces a print out of steps along with a drawing of the maze and path
	def trace(s_x, s_y, e_x, e_y)
		start = Place.new( s_x, s_y, nil)
		end_p = Place.new(e_x, e_y, nil)
		if check_place(start)&&check_place(end_p)
			t = MazeSolver.new(@n, @m, @maze, start, end_p).trace
			display(t)
		else puts "invalid start or end" end
	end

	#makes a new random maze
	def redesign
		m = MazeMaker.new(@n,@m)
		@maze = m.make_maze
	end
end


m = Maze.new(9,9)
s = "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
m.load(s)
m.display
binding.pry
puts ""
a = m.solve(1,1,7,7)
puts ""
binding.pry
m.trace(1,1,7,7)
puts ""
binding.pry
m.redesign
m.display
binding.pry
m.trace(1,1,7,7)
