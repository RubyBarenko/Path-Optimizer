$LOAD_PATH << './lib'

require 'green_shoes'
require 'civilization'
require 'shoes_gui'

Shoes.app title:'Route Optimizer (v 0.0.1)', width:800, height:600 do
	extend Civilization
	extend GUI
end

