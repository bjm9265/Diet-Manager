class BasicFood
  attr_accessor :name, :calories

  #foodName is the name of the BasicFood and calories is the number of calories in this BasicFood
  def initialize(foodName, calories)
	@name = foodName
	@calories = calories
  end
  
  #Returns a string representation of this BasicFood formatted for printing
  def to_s
    #Build the string we are going to print
 
	"#{@name} #{@calories}"
  end
end
