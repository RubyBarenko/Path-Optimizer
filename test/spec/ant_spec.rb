$LOAD_PATH << './../../lib'
require 'ant'

describe Ant do
  before :all do
    srand(1)
    
    @anthill = Node.new(0,0)
    @anthill.current_status.should be :source
    
    @node1 = Node.new(20,0)
    @node2 = Node.new(0,10)
    @food = Node.new(10,10)
    @food.change_status
    
    @anthill_to_node1 = Route.new(@anthill, @node1)
    @anthill_to_node2 = Route.new(@anthill, @node2)
    @node2_to_food = Route.new(@node2, @food)
  end
  
  it "Ant must be into the anthill without food" do
    ant = Ant.new(@anthill)
    ant.target_node.should be @anthill
    ant.food_collected.should be 0
    ant.lost_counter.should be 0
    ant.on_the_road?.should_not be true
    ant.carrying_food?.should_not be true
  end
  
  it "Ant must carrying food when pick food" do
    ant = Ant.new(@anthill)
    ant.pick_food()
    ant.carrying_food?.should be true
  end
  
  it "Ant must increment the food collected when returns with food" do
    ant = Ant.new(@anthill)
    ant.leave_food()
    ant.food_collected.should be 1
    ant.carrying_food?.should_not be true
  end
  
  it "Ant must choose a valid route when is on a node and put pheromone on it" do
    ant = Ant.new(@anthill)
    ant.next_route
    ant.target_node.should be @node2
    @anthill_to_node2.pheromone.should be > 30
    ant.on_the_road?.should be true
  end
  
  it "Ant must decrease the distance on a route" do
    ant = Ant.new(@anthill)
    
  end
end