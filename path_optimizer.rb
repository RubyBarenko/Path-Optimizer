$LOAD_PATH << './lib'
require 'green_shoes'
require 'matrix'
require 'route'
require 'ant'
require 'civilization'
require 'path_optimizer_helper'


module Menu
	def show_menu()
		flow  width:140, height:600 do
			background black
			flow height:25 do
				para fg('Iterations: ',white), 		width:90, height:20
				@menu_interations = edit_line 		width:50, height:20
        #@menu_interations.text = '1'
				
				button 'Start!',									width:1.0, height:20 do
					start(@menu_interations.text.to_i)
				end
				para
				@menu_turn = para fg(strong('Turn: '),white), 						width:90, height:20
				@menu_population = para fg(strong('Pop.: '),white), 			width:90, height:20
				@menu_food_collected = para fg(strong('Food:  '),white), 	width:90, height:20
			end
		end
	end
end

module Interation
	def enable_interation
		click do |b,x,y|
			add_node_event(x,y) if b==1 and x > 140
		end
	end
	
	private

	def add_node_event(x, y)
		@begin_route = nil
		node = Node.new(self, x, y)
		node.node.click do |b,x,y|
			if b==3 then
				add_route_event(node)
			elsif b==2 then
				change_status_event(node)
			end
		end
		if @nodes.empty? then
			node.change_status 
			@nest = node
		end
		@nodes << node
	end

	def add_route_event(node)
		if @begin_route and @begin_route != node then
		  route = Route.new(self, @begin_route, node)
			@routes << route
			route.update_gui
			@begin_route = nil
		else
			@begin_route = node
		end
	end

	def change_status_event(node)
		node.change_status
		@food = (node.current_status == :food ? node : nil)
	end
end


Shoes.app title:'Route Optimizer (v 0.0.1)', width:800, height:600 do
	extend Menu
	extend Civilization
	extend Interation

	background '#753' .. '#420'
	show_menu
	load_environment
	enable_interation
end
