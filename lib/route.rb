require 'green_shoes'
require 'matrix'
require 'node'

class Route
  attr_accessor :pheromone
  attr_reader :length, :nodes
  
  def initialize(context, from, to)
    @nodes = [from, to]
    @nodes.each{|n| n.add_route self}

    context.strokewidth 3; context.stroke context.black
    @route = context.line @nodes[0].pos[0], @nodes[0].pos[1], @nodes[1].pos[0], @nodes[1].pos[1]
    @length = (@nodes[0].pos - @nodes[1].pos)[0] + (@nodes[0].pos - @nodes[1].pos)[1]

    textX = @nodes[0].pos[0] + (@nodes[1].pos[0] - @nodes[0].pos[0])/2
    textY = @nodes[0].pos[1] + (@nodes[1].pos[1] - @nodes[0].pos[1])/2
    @level = context.para '', width:100, height:20, left:textX, top:textY

    @pheromone = 30
  end

  def pheromone_evaporation()
    @pheromone -= 1
  end
  
  def update_gui()
    @level.text = @pheromone
  end
  
  def to_s()
   "Route(#{object_id}){Length:#{length}, Pheromone:#{@pheromone}, Nodes:#{@nodes.inject(''){|x0,x| "#{x0}#{x.object_id}, "}}}"
  end
end