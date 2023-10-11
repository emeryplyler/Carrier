extends Node3D

@export var dialog_file_path = "res://assets/dialogue.json"
var dialog: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog = getDialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_text(speechbubble, text_id: String): # NOTE: char by char is broken
#	speechbubble.text = "" # clear previous message
#	var current_text: String = ""
#	for char in new_text:
#		current_text += char
#		speechbubble.text = current_text
	
	speechbubble.text = dialog.get(text_id)
#	pass

func getDialogue() -> Dictionary:
	if not FileAccess.file_exists(dialog_file_path):
		print("Error: dialogue file missing")
		return {}
	
	var f = FileAccess.open(dialog_file_path, FileAccess.READ)
	var json_dict = JSON.parse_string(f.get_as_text())
	if not json_dict:
		print("Error: dictionary was not created")
		return {}
	else:
		return json_dict[0]
