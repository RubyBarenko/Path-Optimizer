require 'green_shoes'
require 'matrix'
require 'route'

class Node
  @@number = 0
  
  attr_accessor :node
  attr_reader :radius, :current_status, :routes, :pos
  
  def initialize(context, x, y)
    @@number += 1
    @status = {normal:context.yellow, source:context.blue, food:context.red}
    @radius = 20
    
    context.nostroke
    @node = context.oval left:(x-@radius), top:(y-@radius), radius:@radius
    @pos = Vector[x,y]

    @name = context.para @@number, width:100, height:20, left:x, top:y
    change_status
  end
  
  def pos=(x, y)
    @node.left, @node.top = x - @node.width/2, y - @node.height/2
    @pos = Vector[@node.left+@node.width/2, @node.top+@node.height/2]
  end

  def add_route(route)
    (@routes||=[]) << route
  end

  def change_status() 
    if @@number == 1 or @current_status == :source then
      @current_status = :source
    else
      allowed_status = @status.keys - [:source]
      @current_status = allowed_status.rotate[allowed_status.index(@current_status || :food)]
    end
    @node.style fill:@status[@current_status]
    @name.text = @name.text # put text in front of the fill
  end

  def to_s()
   "Node(#{object_id}){Type:#{@current_status}, Position:#{@pos}, Routes:#{@routes.inject(''){|x0,x| "#{x0}#{x.object_id}, "}}}"
  end
end