require 'matrix'
require 'route'

class Node
  @@number = 0
  @@status = [:normal, :source, :food]

  def self.total()
    @@number
  end
  
  attr_reader :current_status, :routes, :pos
  
  def initialize(x, y)
    @@number += 1
    @pos = Vector[x,y]
    change_status
  end
  
  def pos=(x, y)
    @pos = Vector[x, y]
  end

  def add_route(route)
    (@routes||=[]) << route
  end

  def change_status() 
    if @@number == 1 or @current_status == :source then
      @current_status = :source
    else
      allowed_status = @@status - [:source]
      @current_status = allowed_status.rotate[allowed_status.index(@current_status || :food)]
    end
  end

  def to_s()
   "Node(#{object_id}){Type:#{@current_status}, Position:#{@pos}, Routes:#{@routes.inject(''){|x0,x| "#{x0}#{x.object_id}, "}}}"
  end
end