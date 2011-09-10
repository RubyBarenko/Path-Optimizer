require 'matrix'
require 'route'
require 'node'
require 'path_optimizer_helper'


class Ant
  attr_accessor :genes
  attr_reader :lost_counter, :food_collected, :target_node

  def initialize(nest, *parents)
    @genes = [rand(11)-5,rand(11)-5,rand(11)-5, rand(11)-5]
    @genes.size.times {|g| @genes[g] = parents.flatten[rand(parents.size)].genes[g]} if parents.any?
    mutation if rand(20) == 0

    @food_collected, @lost_counter, @current_route, @explored_nodes = 0, 0, nil, []
    @nest = nest
    teleport_to_nest
  end
  
  def on_the_road?()
    !! @current_route
  end
  
  def walk()
    @distance_remaining -= 10 if @current_route
    if @distance_remaining <= 0 then
      @current_route, @distance_remaining = nil, 0
    end
  end

  def leave_food()
    @have_food, @explored_nodes = false, []
    @food_collected += 1
    remember @nest
  end
  
  def carrying_food?
    @have_food
  end
  
  def pick_food()
    @have_food = true
  end

  def next_route
    candidate_routes = []
    @target_node.routes.inject(-1000) do |max, r| 
      t = tendency(r)
      p "Tendency to Route #{r}: #{t}"
      if t > max then
        candidate_routes = [r]
        max = t
      elsif t == max then
        candidate_routes << r
      end
      max
    end
    chosen_route = candidate_routes.rotate(@genes[3]).first
    @current_route, @distance_remaining = chosen_route, chosen_route.length
    @target_node = (chosen_route.nodes - [@target_node]).first
    remember @target_node
    p "Route to #{@target_node}"
    put_pheromone
  end

  def to_s
   "Ant(#{object_id}){Genes#{@genes}, Food Collected:#{@food_collected}, Lost Counter:#{@lost_counter}, Target Node:#{@target_node}, Current Route:#{@current_route}, Remaining: #{@distance_remaining}, Have Food:#{@have_food}, Memory:{#{@explored_nodes}}}"
  end
  
  def back_to_nest()
    current_node = @explored_nodes.pop
    p @explored_nodes
    p "I'm in #{current_node}"
    p "I must return to #{@explored_nodes.last}"
    @current_route = nil
    while @current_route.nil?
      @target_node = @explored_nodes.last
      @current_route = route_between current_node, @target_node
      @explored_nodes.pop unless @current_route
    end

    @target_node = @explored_nodes.last
    @distance_remaining = @current_route.length
    put_pheromone
  end

  private

  def route_between(node1, node2)
    route = nil
    node1.routes.each {|r| route = r if r.nodes.include? node2}
    route
  end

  def tendency(route)
    @genes[0] * Math::sin(@genes[1] * route.pheromone + @genes[2])
  end

  def put_pheromone()
    if @have_food then
      p "I'm marking the road #{@current_route} with pheromone"
      @current_route.pheromone += 100 * (@food_collected + 1)
    else
      @current_route.pheromone += 1
    end
  end

  def mutation()
    @genes[rand(@genes.size)] = rand(11)-5;
  end

  def remember(node)
    if @explored_nodes.member? node then
      @lost_counter += 1
    else
      @explored_nodes << node
    end
  end
  
  def teleport_to_nest()
    @target_node = @nest
    remember @target_node
    @current_route, @distance_remaining = nil, 0
  end
end