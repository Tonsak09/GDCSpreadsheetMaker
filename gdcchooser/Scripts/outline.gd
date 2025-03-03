extends ColorRect

@export var manCol : Color
@export var intCol : Color
@export var parCol : Color
@export var notCol : Color
@export var speed : float 

var outlineCol : Color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate = lerp(modulate, outlineCol, delta * speed)


func _input(event: InputEvent) -> void:
	
	var hasInput = false 
	var choice : String
	if event.is_action_pressed("Mandatory"):
		outlineCol = manCol
	elif  event.is_action_pressed("Interested"):
		outlineCol = intCol
	elif  event.is_action_pressed("Partial"):
		outlineCol = parCol
	elif  event.is_action_pressed("Not"):
		outlineCol = notCol
