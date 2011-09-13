$LOAD_PATH << './../../lib'
require 'node'
require 'matrix'

describe Node do
  before(:all) do
    class Node; @@number = 0; end
    @source ||= Node.new(0, 0)
  end
  
  it "first node must be a source" do
    @source.current_status.should be :source
    Node.total.should be 1
  end
  
  it "next node must be a normal" do
    node = Node.new(0, 0)
    node.current_status.should be :normal
    Node.total.should be > 1
  end
  
  it "New node must be on [10,15] position" do
    node = Node.new(10,15)
    node.pos.should eql Vector[10,15]
  end
  
  it "New node must be no route" do
    node = Node.new(0,0)
    node.routes.should be nil
  end
  
  it "First node must always be a source" do
    @source.current_status.should be :source
    @source.change_status
    @source.current_status.should be :source
  end
  
  it "Node normal must be a food when status changed" do
    node = Node.new(0,0)
    node.current_status.should be :normal
    node.change_status
    node.current_status.should be :food
  end  
  
  it "Node food must be a normal when status changed" do
    node = Node.new(0,0)
    node.change_status
    node.current_status.should be :food
    node.change_status
    node.current_status.should be :normal
  end
end