require 'green_shoes'
require 'matrix'
require 'route'
require 'ant'
require 'path_optimizer_helper'


module Civilization
  SELECTION_EPOCH_TO_EACH = 30
  def load_environment
    @food_collected, @delivered_time, @epoch = 0, 0, 0
    @nodes  ||= []; @routes ||= []; @colony ||= []
  end

  def restart()
    @colony.each {|ant| ant.teleport_to_nest}
    @routes.each {|r| r.pheromone = 30}
  end

  def start(interactions)
    load_environment
    (rand(10)+5).times {@colony << Ant.new(@nest)}

    @animation = animate do
      @thread = Thread.new{next_turn} unless @thread and @thread.alive?
      update_gui
      if @epoch >= interactions then
        @animation.stop
        sleep 0.001 while @thread.alive?
        update_gui true
      end
    end
  end

  def next_turn
    @epoch += 1
    natural_selection if (@epoch % SELECTION_EPOCH_TO_EACH).zero?

    @colony.each do |ant|
      if ant.on_the_road? then
        p ant.to_s + 'on the road'
        ant.walk
      elsif ant.target_node == @nest and ant.carrying_food? then
        p ant.to_s + 'in nest with food'
        ant.leave_food
        @food_collected += 1
        delivered_time = @epoch
      elsif ant.target_node == @food and not ant.carrying_food? then
        p ant.to_s + 'in food without food'
        ant.pick_food
      elsif ant.carrying_food? then
        p ant.to_s + 'with food'
        ant.back_to_nest
      else
        p ant.to_s + 'choose route'
        ant.next_route
      end
    end

    evaporate
  end

  def update_gui(all=false)
    @menu_turn.text = fg(stroke('Turn: ') + fg(@epoch, yellow),white)
    @menu_population.text = fg(stroke('Pop.: ') + fg(@colony.size, yellow),white)
    @menu_food_collected.text = fg(stroke('Food: ') + fg(@food_collected, yellow),white)

    @routes.each{|r| r.update_gui} if (@epoch % 10).zero? or all
  end

  private

  def evaporate()
    @routes.each {|r| r.pheromone_evaporation}
  end

  def natural_selection()
    @colony << Ant.new(@nest, best_explorers)
    @colony << Ant.new(@nest, best_workers)
    kill_losers
    migration
  end

  def best_ants(&condition_blk)
    male = @colony.inject &condition_blk
    females = @colony.dup
    females.delete(male)
    female = females.inject &condition_blk
    [male, female]
  end

  def best_explorers()
    best_ants {|a1,a2| (a1.lost_counter <= a2.lost_counter)? a1 : a2}
  end

  def best_workers()
    best_ants {|a1,a2| (a1.food_collected > a2.food_collected)? a1 : a2}
  end

  def kill_losers()
    @colony.each{|ant| @colony.delete ant if ant.lost_counter > 5}
  end

  def migration()
    Ant.new(@nest)
  end
end
