#require './BasicFood'
require './Recipe'

class FoodDB
  attr_reader :size, :basicFoods, :recipes
  
  #filename is the name of the FoodDB file to be used, ex: "FoodDB.txt"
  def initialize(filename)
    @size = 1
  
    @dbFile = File.new(filename) #Open the database file
    
    @basicFoods = []
    @recipes = []
    
    #Read in the FoodDB file
    @dbFile.each{|line|
      values = line.split(',') #Split the line up at the commas
      
      if values[1] == 'b' #BasicFood case
        add_basicFood(values[0], values[2].to_i) #Add the new food to our list
      elsif values[1] == 'r' #Recipe case
        values[2..values.length].each{|ingredient| ingredient.chomp!} #Remove newline characters
        add_recipe(values[0], values[2..values.length]) #Add the new Recipe to the recipes list
      else #The entry is invalid
        values[0].chomp.eql?("") ? nil : puts("Invalid food type found in FoodDB.txt")
      end
    }
  end
  
  #Returns true if a BasicFood with the name foodName exists in the database
  def contains_food?(foodName)
    contains = false
    @basicFoods.each do |basicFood|
	    if basicFood.name == foodName
		    contains = true
	    end
    end
	
    contains
  end
  
  #Returns true if a Recipe with the name recipeName exists in the database
  def contains_recipe?(recipeName)
    contains = false
    @recipes.each do |recipe|
	    if recipe.name == recipeName
		    contains = true
	    end
    end
	
    contains
  end
  
  #Returns true if there exists some entry in the database with the name itemName
  def contains?(itemName)
	  if self.contains_food?(itemName) || self.contains_recipe?(itemName)
		  return true
	  end
	  return false	
  end
  
  #Returns the BasicFood of the given name if it exists within the database, nil otherwise
  def get_food(foodName)
 	@basicFoods.each do |food|
		if food.name == foodName
			return food
		end

	end
	nil
  end
  
  #Returns the Recipe of the given name if it exists within the database, nil otherwise
  def get_recipe(recipeName)
	@recipes.each do |recipe|
		if recipe.name == recipeName
			return recipe
		end
	end
	nil
  end
  
  #Returns the item of the given name if it exists within the database, nil otherwise
  def get(itemName)
    #If the item is a BasicFood and is in the database, return it
    #Else, if the item is a Recipe and is in the database, return it
    #Return nil otherwise
	if self.contains_food?(itemName)
		return get_food(itemName)
	elsif self.contains_recipe?(itemName)
		return get_recipe(itemName)
	else
		return nil
	end
  end
  
  #Returns a list of all items in the database that begin with the given prefix
  def find_matches(prefix)
    matches = []	
    @basicFoods.each{ |food|
	    if food.name[0] == prefix[0]
		    matches.push(food)
	    end
    }
    @recipes.each{ |recipe|
	    if recipe.name[0] == prefix[0]
		    matches.push(recipe)
	    end
    }
    i = 1
    while i < prefix.length
	    matches.each do |food|
		    if food.name[i] != prefix[i]
			    matches.delete(food)
		    end
	    end
	    i += 1
    end
    return matches	
  end
  
  #Constructs a new BasicFood and adds it to the database, returns true if successful, false otherwise
  def add_basicFood(name, calories)
    #Don't add if it is already in the database
    new_food = BasicFood.new(name, calories)
    if @basicFoods.include?(new_food)
	    return false
    else
	  @basicFoods.push(new_food)
	  return true;
    end	
  end
  
  #Constructs a new Recipe and adds it to the database, returns true if successful, false otherwise
  def add_recipe(name, ingredientNames)
    #Don't add if it is already in the database
	ingredientList = []
	ingredientNames.each do |name|
		if contains?(name)
			ingredientList.push(get(name))
		end
	end

    new_recipe = Recipe.new(name, ingredientList)
    if contains_recipe?(new_recipe)
	    return false
    else
	    @recipes.push(new_recipe)
	    return true
    end
  end
  
  #Saves the database to @dbFile
  def save
    File.open(@dbFile, "w+"){|fOut|
      #Write all BasicFoods to the database
      @basicFoods.each{|food| fOut.write("#{food.name},b,#{food.calories}\n")}
      fOut.write("\n")
      
      #Write all Recipes to the database
      @recipes.each{|recipe|
        fOut.write("#{recipe.name},r")
        
        #List the ingredients after the recipe name
        recipe.ingredients.each{|ingredient| fOut.write(",#{ingredient.name}")}
        fOut.write("\n")
      }
    }
  end
end
