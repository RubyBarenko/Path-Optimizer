require 'green_shoes'

module GUI
  def self.context(); @context; end
  def self.extended(base)
    @context = base
    base.background '#753' .. '#420'
    base.extend GUI::Menu
    base.extend GUI::Interation
  end 
end
  
module GUI::Node
  attr_reader :node

  def update_gui()
    unless @node then
      @status_color ||= {normal:GUI.context.yellow, source:GUI.context.blue, food:GUI.context.red}
      @radius = 20
      GUI.context.nostroke
      @node = GUI.context.oval left:(pos[0]-@radius), top:(pos[1]-@radius), radius:@radius
      @name = GUI.context.para self.class.total, width:100, height:20, left:pos[0], top:pos[1]
    end

    @node.style fill: @status_color[current_status]
    @name.text = @name.text
  end
end

module GUI::Route
  attr_reader :route

  def update_gui()
    unless @route then
      GUI.context.strokewidth 3; GUI.context.stroke GUI.context.black
      @route = GUI.context.line @nodes[0].pos[0], @nodes[0].pos[1], @nodes[1].pos[0], @nodes[1].pos[1]
    
      textX = @nodes[0].pos[0] + (@nodes[1].pos[0] - @nodes[0].pos[0])/2
      textY = @nodes[0].pos[1] + (@nodes[1].pos[1] - @nodes[0].pos[1])/2
      @level = GUI.context.para '', width:100, height:20, left:textX, top:textY
    end
    @level.text = @pheromone
  end
end

module GUI::Civilization
  def update_gui(all=false)
    @menu_turn.text = GUI.context.fg(GUI.context.stroke('Turn: ') + GUI.context.fg(@epoch, GUI.context.yellow),GUI.context.white)
    @menu_population.text = GUI.context.fg(GUI.context.stroke('Pop.: ') + GUI.context.fg(@colony.size, GUI.context.yellow),GUI.context.white)
    @menu_food_collected.text = GUI.context.fg(GUI.context.stroke('Food: ') + GUI.context.fg(@food_collected, GUI.context.yellow),GUI.context.white)

    @routes.each{|r| r.update_gui} if (@epoch % 10).zero? or all
  end
end

module GUI::Menu
  def self.extended(base)
    base.show_menu()
  end
  
  def show_menu()
    flow  width:140, height:600 do
      background black
      flow height:25 do
        para fg('Iterations: ',white),     width:90, height:20
        @menu_interations = edit_line                width:50, height:20
        @menu_interations.text = '1000'
        
        button 'Start!',                             width:1.0, height:20 do
          start(@menu_interations.text.to_i)
        end
        para
        @menu_turn = para fg(strong('Turn: '),white),             width:90, height:20
        @menu_population = para fg(strong('Pop.: '),white),       width:90, height:20
        @menu_food_collected = para fg(strong('Food:  '),white),  width:90, height:20
      end
    end
  end
end

module GUI::Interation
  def self.extended(base)
    base.click do |b,x,y|
      base.add_node_event(x,y) if b==1 and x > 140
    end
  end
  
  def add_node_event(x, y)
    @begin_route = nil
    node = Node.new(x, y)
    node.node.click do |b,x,y|
      if b==3 then
        add_route_event(node)
      elsif b==2 then
        change_status_event(node)
      end
    end
    if @nodes.empty? then
      change_status_event(node) 
      @nest = node
    end
    @nodes << node
  end

  def add_route_event(node)
    if @begin_route and @begin_route != node then
      route = Route.new(@begin_route, node)
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

module Civilization
  include GUI::Civilization
end

class Node
  include GUI::Node
  
  alias_method :__change_status, :change_status
  def change_status(*args)
    __change_status(*args)
    update_gui
  end

  alias_method :__initialize, :initialize
  def initialize(*args)
    __initialize(*args)
    update_gui
  end
end

class Route
  include GUI::Route
  
  alias_method :__initialize, :initialize
  def initialize(*args)
    __initialize(*args)
    update_gui
  end
end
