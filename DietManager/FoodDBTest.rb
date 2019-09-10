require 'minitest/autorun'          #We need Ruby's unit testing library
require './FoodDB'

class FoodDBTest < MiniTest::Test
  def setup							#setup method is run automatically before each test_xxx
    @fdb = FoodDB.new("FoodDB.txt")
  end
  
  #Tests if there are entries in the DB after FoodDB.txt is read
  def test_DB_initialization
    assert(@fdb.size > 0, "Database entries not correctly read in")
  end
  
  #Tests the 'contains_food?' method of FoodDB
  def test_contains_food
 
  end
  
  #Tests the 'contains_recipe?' method of FoodDB
  def test_contains_recipe
  
  end
  
  #Tests the 'contains?' method of FoodDB
  def test_contains
 
  end
  
  #Tests the 'get_food' method of FoodDB
  def test_get_food
 
  end
  
  #Tests the 'get_recipe' method of FoodDB
  def test_get_recipe

  end
  
  #Tests the 'get' method of FoodDB
  def test_get
 
  end
  
  #Tests the 'find_matches' method of FoodDB
  def test_find_matches
 
  end
  
  #Tests the 'add_basicFood' method
  def test_add_food
 
  end
  
  #Tests the 'add_recipe' method
  def test_add_recipe
  
  end
  
  #Tests the addition of a Recipe with a Recipe as one of its ingredients
  def test_recipe_within_recipe
  
  end
end