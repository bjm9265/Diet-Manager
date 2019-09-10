require './BasicFood'

class Recipe
  attr_accessor :name, :ingredients, :calories

  #recipeName is the name of this recipe and ingredientsList is the list of BasicFood objects in this recipe
  def initialize(recipeName, ingredientsList)
    @name = recipeName
    @ingredients = ingredientsList.sort{|x, y| x.name <=> y.name} #Sorts the list by ingredient name
    @calories = 0
    
    #Calculate the total calories in this Recipe
  
    @ingredients.each do |item|
	    @calories += item.calories
    end
	
  end
  
  #Returns a string representation of this Recipe formatted for printing
  def to_s
    result = ""
    
    #Build the string we are going to print

    result = name + " " + calories.to_s + "\n"
    @ingredients.each do |item|
	    result += "\t" + item.to_s + "\n"
    end
	
    return result
  end
end
