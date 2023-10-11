class_name ProfanityCensor

var lines = null
var words = null

var censor_chars = '@#$%!'

var word_list_path = "res://Resources/wordlist.text"

var censor_pool : PackedStringArray

func get_words() -> PackedStringArray:
	if words == null:
		return load_words()
	else:
		return words
		
#
# Loads and caches the profanity word list. Input file (if provided)
# should be a flat text file with one profanity entry per line.
#
func load_words(wordlist = null) -> PackedStringArray:
	if wordlist == null:
		wordlist = PackedStringArray([])
		var f = FileAccess.open("res://Resources/wordlist.txt", FileAccess.READ)
		
		while not f.eof_reached():
			wordlist.append(f.get_line())
	
	return wordlist

func list(string : String) -> PackedStringArray:
	var array : PackedStringArray = PackedStringArray([])
	
	for character in string:
		array.append(character)	
		
	return array

#
# Plucks a letter out of the censor_pool. If the censor_pool is empty,
# replenishes it. This is done to ensure all censor chars are used before
# grabbing more (avoids ugly duplicates).
#
func get_censor_char():
	if censor_pool.is_empty():
		censor_pool = list(censor_chars)
		
	var index = randi_range(0, censor_pool.size() - 1)
	return censor_pool[index]
	
# Sets the pool of censor characters. Input should be a single string
# containing all the censor charcters you'd like to use.
# Example: "@#$%^
func set_censor_characters(new_characters : String):
	censor_chars = new_characters

# Checks the input_text for any profanity and returns True if it does.
# Otherwise, returns False.
func contains_profanity(input_text : String):
	print(input_text != censor(input_text))
	return input_text != censor(input_text)	

# Returns the input string with profanity replaced with a random string
# of characters plucked from the censor_characters pool
func censor(input_text : String) -> String:
	var return_text = input_text
	var search_text = input_text.replace(" ", "")
	print(search_text)
	words = get_words()
	
	var re = RegEx.new()
	
	var pattern = ("(?i)" + "|".join(words)).trim_suffix("|")
	
	var error = re.compile(pattern)
	if error != OK:
		print(error)
	else:
		var results = re.search_all(input_text)
		
		if results.size() > 0:
			for result in results:								
				var new_text = result.get_string()				
				for c in new_text:
					new_text = new_text.replace(c, get_censor_char())
				return_text = return_text.replace(result.get_string(), new_text)				
#
	return return_text
