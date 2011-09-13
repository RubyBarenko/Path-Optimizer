$LOAD_PATH << './../../lib'
require 'ant'

describe Ant do
  before :all do
    srand(4)
    class Node; @@number=0; end
    @anthill = Node.new(0,0)
    @anthill.current_status.should be :source
    
    @node1 = Node.new(10,0)
    @node2 = Node.new(0,10)
    @food = Node.new(10,10)
    @food.change_status
    
    @anthill_to_node1 = Route.new(@anthill, @node1)
    @anthill_to_node2 = Route.new(@anthill, @node2)
    @node2_to_food = Route.new(@node2, @food)
  end
  
  it "must be into the anthill without food" do
    ant = Ant.new(@anthill)
    ant.target_node.should be @anthill
    ant.food_collected.should be 0
    ant.lost_counter.should be 0
    ant.on_the_road?.should_not be true
    ant.carrying_food?.should_not be true
  end
  
  it "must carrying food when pick food" do
    ant = Ant.new(@anthill)
    ant.pick_food()
    ant.carrying_food?.should be true
  end
  
  it "must increment the food collected when returns with food" do
    ant = Ant.new(@anthill)
    ant.leave_food()
    ant.food_collected.should be 1
    ant.carrying_food?.should_not be true
  end
  
  it "must choose a valid route when is on a node and put pheromone on the road" do
    ant = Ant.new(@anthill)
    ant.next_route
    ant.target_node.should be @node2
    @anthill_to_node2.pheromone.should be > 30
    ant.on_the_road?.should be true
  end
  
  it "In food, must pick food and return to anthill putting a lot of pheromone on the road" do
    ant = Ant.new(@anthill)
    ant.next_route
    ant.target_node.should be @node2
    @anthill_to_node2.pheromone.should be > 30
    ant.on_the_road?.should be true
    ant.walk
    ant.on_the_road?.should_not be true
    ant.next_route
    ant.target_node.should be @food
    @node2_to_food.pheromone.should be > 30
    ant.walk
    ant.on_the_road?.should_not be true
    ant.pick_food
    ant.carrying_food?.should be true
    ant.back_to_nest
    ant.target_node.should be @node2
    @node2_to_food.pheromone.should be > 130
    ant.walk
    ant.back_to_nest
    ant.target_node.should be @anthill
    @anthill_to_node2.pheromone.should be > 130
    ant.walk
    ant.on_the_road?.should_not be true
    ant.leave_food
    ant.food_collected.should be 1
    ant.lost_counter.should be 0
  end
  
  it "has parent characteristics randomly" do
    mother = Ant.new(@anthill)
    father = Ant.new(@anthill)

    child = Ant.new(@anthill, mother, father)
    genes = child.genes
    genes[0].should be mother.genes[0]
    genes[1].should be father.genes[1]
    genes[2].should be father.genes[2]
    genes[3].should be mother.genes[3]
  end
end