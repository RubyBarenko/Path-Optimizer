$LOAD_PATH << './../../lib'
require 'node'
require 'route'
require 'matrix'

describe Route do
  def from
    return @from if @from
    @from = double('nodeFrom')
    @from.stub(:pos) { Vector[1,7] }
    @from.should_receive(:add_route).with(anything)
    @from
  end

  def to
    return @to if @to
    @to = double('nodeTo') 
    @to.stub(:pos) { Vector[5,10] }
    @to.should_receive(:add_route).with(anything)
    @to
  end
  
  it "Route must be 'from' and 'to' nodes when created" do
      expect{ Route.new(nil,nil) }.to raise_error "must be 'from' and 'to' nodes"
  end
  
  it "Route from node to another node" do
    route = Route.new(from,to)
    route.nodes[0].should eql from
    route.nodes[1].should eql to
  end
  
  it "Route length must be the from - to distance" do
    route = Route.new(from,to)
    route.length.should eql 5
  end
  
  it "Route pheromone must evaporate" do
    route = Route.new(from,to)
    before_value = route.pheromone
    route.pheromone_evaporation
    route.pheromone.should be < before_value
  end
  
  it "Route must be setted into nodes" do
    from_node, to_node = Node.new(0,0), Node.new(1,1)
    route = Route.new(from_node, to_node)
    route.nodes[0].should be from_node
    route.nodes[1].should be to_node
    
    from_node.routes[0].should be route
    to_node.routes[0].should be route
  end
end