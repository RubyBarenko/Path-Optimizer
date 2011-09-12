require 'matrix'
require 'node'

class Route
  attr_accessor :pheromone
  attr_reader :length, :nodes
  
  def initialize(from, to)
    @nodes = [from, to]
    raise "must be 'from' and 'to' nodes" if @nodes.compact.size < 2
    @nodes.each{|n| n.add_route self}
    @length = Math::sqrt((@nodes[0].pos - @nodes[1].pos)[0] ** 2 + (@nodes[0].pos - @nodes[1].pos)[1] ** 2)
    @pheromone = 30
  end

  def pheromone_evaporation()
    @pheromone -= 1
  end
  
  def to_s()
   "Route(#{object_id}){Length:#{length}, Pheromone:#{@pheromone}, Nodes:#{@nodes.inject(''){|x0,x| "#{x0}#{x.object_id}, "}}}"
  end
end