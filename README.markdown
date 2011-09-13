Path Optimizer
==============

This project has developed during the Ruby with Shoes 8th Batch course of RubyLearning.org.

I was inspired this week and made a prototype of a system that tries to find the shortest path between two points.

The program was heavily inspired by the article (and source-code) of Danilo Benzatti [Emergent Intelligence](http://ai-depot.com/CollectiveIntelligence/Ant.html).

I tried to do something using Ruby and Green Shoes instead of C++.

I think what I did, is quite interesting (although there are still many bugs).


How to use (mouse-based, sorry Mac users)
-----------------------------------------

* Creating Nodes: click with the left mouse button on the panel brown. The first Node always is the anthill (blue).
 
* Create routes: click with right mouse button on both nodes to connect them.
 
* Activate Food Node: click with the middle mouse button (Node food is red)
 

Start simulation
----------------

Enter the amount of interaction you want (I recommend a minimum of 50) and click Start!
 
Must be only a Food Node before to start the simulation.


For developers - Debug Mode
---------------------------

Now, to enable debugging you must call the program with *debug* as the parameter:

> ruby debug path_optimizer.rb


