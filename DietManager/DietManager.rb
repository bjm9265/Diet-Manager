require './FoodDB'
require './Log'

class DietManager
  def initialize()
    @dbFile = "FoodDB.txt"
    @logFile = "DietLog.txt"
    @database = FoodDB.new(@dbFile)
    @log = Log.new(@logFile)
    @dbChanged = false
    @logChanged = false

  end


  
  #Handles the 'quit' command which exits the DietManager
  def command_quit
	  exit!
  
  end
  
  #Handles the 'save' command which saves the FoodDB and Log if necessary
  def command_save
	  if @dbChanged 
	  	@database.save
	  elsif @logChanged
		  @log.save
	  end
 
  end

  #Handles the 'new food' command which adds a new BasicFood to the FoodDB
  def command_newFood(name, calories)
	  puts
	  if @database.contains_food?(name)
		  puts "Food already in Database"
  	  else
		  @database.add_basicFood(name, calories)
		  puts "#{name} was added to the Database"
		  @dbChanged = true
	  end
 	puts
  end

  #Handles the 'new recipe' command which adds a new Recipe to the FoodDB
  def command_newRecipe(name, ingredients)
	  puts
	  if @database.contains_recipe?(name)
		  puts "Recipe already in Database"
	  else
		  ingredients.each do |ingredient|
			  if !@database.contains_food?(ingredient)
				  puts "#{ingredient} not found in Database"
				  return nil
			  end
		  end
		  @database.add_recipe(name, ingredients)
		  puts "#{name} added to the Database"
		  @dbChanged = true
	  end
	  puts
  end

  #Handles the 'print' command which prints a single item from the FoodDB
  def command_print(name)
	  puts
	  if @database.contains?(name)
		  puts @database.get(name)
	  else
		  puts "Food does not exist in Database"
	
	  end
	puts
  end

  #Handles the 'print all' command which prints all items in the FoodDB
  def command_printAll
	  puts
	  @database.basicFoods.each do |food|
		  puts food
	  end
	  puts
	  @database.recipes.each do |recipe|
		  puts recipe
	  end
	  puts
  end

  #Handles the 'find' command which prints information on all items in the FoodDB matching a certain prefix
  def command_find(prefix)
	  puts
	  matches = @database.find_matches(prefix)
	  if matches.size == 0
		  puts "No food with this prefix"
		  nil
	  end
	  matches.each do |food| 
		  puts food
	  end
	  puts
  end

  #Handles both forms of the 'log' command which adds a unit of the named item to the log for a certain date
  def command_log(name, date = Date.today)
	  puts
	  if !@database.contains?(name)
		  puts "#{name} not in Database"
		  return nil
	  end
	  @log.add_logItem(name, date)
	  puts "#{name} added to log for #{date}"
	  @logChanged = true
	  puts

  end

  #Handles the 'delete' command which removes one unit of the named item from the log for a certain date
  def command_delete(name, date)
	  puts
	  if !@database.contains?(name)
		  puts "#{name} not in Database"
		  return nil
	  end
	  @log.remove_logItem(name, date)
	  puts "#{name} removed from log for #{date}"
	  @logChanged = true
	  puts
 
  end

  #Handles both forms of the 'show' command which displays the log of items for a certain date
  def command_show(date = Date.today)
	  puts
	  entries = @log.get_entries(date)
	  if entries == nil
		  puts "No entries for #{date}"
		  return nil
	  end
	  entries.each do |entry|
		  puts entry
	  end
 	puts
  end

  #Handles the 'show all' command which displays the entire log of items
  def command_showAll
	  puts
	  entries = @log.get_entries
	  entries.each do |entry|
		  puts entry
	  end
	  puts
  end
  
end #end DietManager class


#MAIN

dietManager = DietManager.new

puts "Input a command > "

#Read commands from the user through the command prompt
$stdin.each{|line|
	line = line.chomp!.to_s
	line = line.split(" ")
	command = line[0]
	
	# Backend setup for when commands are called

	if command == "print" || command == "find"
		i = 1
		food = ""

		while i < line.length
			if i < (line.length - 1)
				food.concat("#{line[i]} " )
			else
				food.concat("#{line[i]}")
			end
			i += 1
		end

	elsif command == "new"
		if line[1] == "food" || line[1] == "recipe"
			command.concat(" #{line[1]}")
			i = 2 
			info = ""
			while i < line.length
				if i < (line.length - 1)
					info.concat("#{line[i] } ")
				else
					info.concat("#{line[i]}")
				end
				i += 1
			end
		end
		food = info.split(",")
		if command == "new food"
			name = food[0].to_s
			calories = food[1].to_s
		elsif command == "new recipe"
			name = food[0]
			i = 1
			ingredients = []
			while i < food.length
				ingredients.push(food[i])
				i += 1
			end
		end

	elsif command == "log"
		i = 1
		entry = ""
		while i < line.length
			if i < (line.length - 1)
				entry.concat("#{line[i]} ")
			else
				entry.concat("#{line[i]}")
			end
			i += 1
		end
		entry = entry.split(",")
		if entry.length == 1
			name = entry[0]
			givenLog = false
		elsif entry.length == 2
			name = entry[0]
			date = entry[1]
			givenLog = true
		else 
			command = ""
		end

	elsif command == "show"
		date = nil
		if line[1] == "all"
		       command = "show all"
		elsif line[1] != nil
			date = Date.parse(line[1].to_s)
		end

	elsif command == "delete"
		i =1
		entry = ""
		while i < line.length
			if i < (line.length - 1)
				entry.concat("#{line[i]} ")
			else 
				entry.concat("#{line[i]}")
			end
			i += 1
		end
		entry = entry.split(",")
		name = entry[0]
		date = Date.parse(entry[1].to_s)
	end	

	# where the actual commands get called

	if command == "quit" 
		dietManager.command_quit

	elsif command == "print"
		if line[1] == "all"
			dietManager.command_printAll
		else
			dietManager.command_print(food)
		end

	elsif command == "find"
		dietManager.command_find(food)

	elsif command == "new food"
		dietManager.command_newFood(name, calories)

	elsif command == "new recipe"
		dietManager.command_newRecipe(name, ingredients)

	elsif command == "save"
		dietManager.command_save

	elsif command == "log"
		if !givenLog
			dietManager.command_log(name)
		else
			dietManager.command_log(name,date)
		end

	elsif command == "show all"
		dietManager.command_showAll

	elsif command == "show"
	       if date == nil
	       	     dietManager.command_show
	       else	       
		     dietManager.command_show(date)
	       end

	elsif command == "delete"
		dietManager.command_delete(name,date)

	else
		puts "Command not found try again."
	end


#Handle the input
  
 } #closes each iterator

#end MAIN
