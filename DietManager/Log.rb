require './LogItem'

class Log
  attr_accessor :size
  
  #filename is the name of the Log file to be used
  def initialize(filename)
    @log = Hash.new
    @size = 0
    
    
	@logFile = File.new(filename) #Open the log file
    
    #Read in the Log file
    @logFile.each{|line|
      values = line.split(',') #Split the line at the commas
      dateParts = values[0].split('/') #Split the date field up at the slashes
      
      date = Date.parse("#{dateParts[2]}-#{dateParts[0]}-#{dateParts[1]}") #Parse the date string into a valid Date object
      
      add_logItem(values[1].chomp!, date)
    }
  end
  
  #Adds a LogItem to the Log for the given date and name, returns true if successful, false otherwise
  def add_logItem(name, date)
	  dateItem = date.to_s.split("-")
	  if dateItem.length == 3
		  year = dateItem[0]
		  month = dateItem[1]
		  if month[0] == "0"
			  month = month[1]
		  end
		  day = dateItem[2]
		  dateItem = "#{month}/#{day}/#{year}"
	  elsif dateItem.length == 1
		  dateItem = dateItem[0]
	  end

	  item = LogItem.new(name, dateItem)
	  if @log[date] == nil
		  @log[date] = []
	  end
	  @log[date].push(item)
	  @size += 1
	  return true
   
  end
  
  #Removes a LogItem from the Log for the given date and name
  def remove_logItem(name, date)
	  if @log[date] == nil
		  return nil
	  elsif @log[date].size == 1
		  temp = @log[date][0]
		  @log.delete(date)
		  return temp
	  else
		  @log[date].each do |logItem|
			  if logItem.name == name
				  temp = logItem
				  @log[date].delete(logItem)
				  return logItem
			  end
		  end
	  end
	nil
  end
  
  #Returns true if there is an entry for this date with the given name, false otherwise
  def contains?(name, date)
	  if @log[date] == nil
		  return false
	  else
		  @log[date].each do |logItem|
			  if logItem.name == name
				  return true
			  end
		  end
	  end
  end
  
  #Returns an Array of LogItems for the given date, nil if there are no entries for the date
  #If no date is passed, returns all entries in the Log
  def get_entries(date = nil)
	  entries = []
	  if date == nil
		  @log.each do |key, value|
			  entries.push(value)
		  end
		  return entries
	  end
	  if @log[date] == nil
		  return nil
	  else
		  @log[date].each do |logItem|
			  entries.push(logItem)
		  end
		  return entries
	  end
  end
  
  #Saves the log to @logFile
  def save
    #Write all save data to the log file
    File.open(@logFile, "w+"){|fOut|
      get_entries.flatten.each{|logItem|
        fOut.write(logItem.to_s)
        fOut.write("\n")
      }
    }
  end
end

