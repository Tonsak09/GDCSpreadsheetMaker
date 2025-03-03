@tool
extends Node

@export var csvPath : String
@export var savePath : String 

@export var title : RichTextLabel
@export var room : Label
@export var day : Label
@export var time : Label
@export var speakers : RichTextLabel
@export var counter : Label

@export_category("Debug")
@export var LoadFile: bool:
	set(value):
		LoadCSV()
		LoadLine(1)

@export var inputData : Array[PackedStringArray]
@export var completedData : Array[PackedStringArray]

var currLine = 1

var state : States
enum States
{
	IDLE,
	LOADING,
	CHOOSING,
	RESULTS 
}

func _init() -> void:
	state = States.IDLE
	
	#LoadCSV()

func _input(event: InputEvent) -> void:
	
	if currLine >= inputData.size():
		return
	
	var hasInput = false 
	var choice : String
	if event.is_action_pressed("Mandatory"):
		hasInput = true 
		choice = "Mandatory"
	elif  event.is_action_pressed("Interested"):
		hasInput = true 
		choice = "Interested"
	elif  event.is_action_pressed("Partial"):
		hasInput = true 
		choice = "Partial"
	elif  event.is_action_pressed("Not"):
		hasInput = true 
		choice = "Not"
	
	if event.is_action_pressed("Save"):
		
		var stringOutput = "";
		for arr in completedData:
			stringOutput += ",".join(arr) + "\n"
		
		print_debug(stringOutput)
		WriteFile(stringOutput)
	
	# Has input been read? 
	if hasInput == true :
		completedData.push_back(inputData[currLine])
		completedData[completedData.size() - 1].append(choice)
		
		currLine += 1
		print_debug(choice)
		
		if currLine < inputData.size():
			LoadLine(currLine)
		else:
			pass
			# Report that end of file reached 

func _process(delta: float) -> void:
	counter.text =str(currLine)

# Loads in the CSV file and stores it in memory
func LoadCSV():
	inputData = ReadFile()

# Loads in the given line to the labels 
func LoadLine(index : int):
	#print_debug(inputData[index]) 
	
	var line = inputData[index]
	
	title.text =  "[center]" + line[1] +  "[/center]"
	room.text = line[2]
	day.text = line[4]
	time.text = line[6]
	speakers.text = "[center]" + line[3] +  "[/center]"


# Writes a string to the desired file 
func WriteFile(content):
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_string(content)

# Get the data stored  
func ReadFile():
	
	var input : Array[PackedStringArray]
	var file = FileAccess.open(csvPath, FileAccess.READ)
	
	print_debug("Loading data...")
	while !file.eof_reached():
		var content = file.get_csv_line()
		input.push_back(content)
		#print_debug(content)
	
	return input 
