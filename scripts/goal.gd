extends StaticBody3D

@onready var player = $"../Player"
@onready var speechbubble = $Speech
@onready var timer = $Speech/Timer

@export var waiting_for_mail: bool = true # is this character expecting mail

var id: int

@export var dialog_file_path = "res://assets/dialogue.json"
var dialog: String

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # init rng
	id = randi() % 3 # 0 1 or 2
	display_text("")
	var dialogue_dict = getDialogue()
	print(dialogue_dict)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	if waiting_for_mail:
		if body is RigidBody3D:
			if not body.is_in_group("Cargo"):
				display_text("This isn't a package is it")
			else:
				var cargo_id = body.get_cargo_id()
				if cargo_id == id:
					display_text("yay thanks :3")
					player.get_node("Inventory").add_subtract_money(5)
					waiting_for_mail = false
				else:
					display_text("i dont think this is mine")

func display_text(new_text: String): # NOTE: char by char is broken
	speechbubble.text = "" # clear previous message
	var current_text: String = ""
	for char in new_text:
		timer.start()
		current_text += char
		speechbubble.text = current_text
		await _on_timer_timeout()

func _on_timer_timeout():
	pass # Replace with function body.

func getDialogue() -> Dictionary:
	var json_text = FileAccess.get_file_as_string(dialog_file_path)
	var json_dicts = JSON.parse_string(json_text)
	if not json_dicts:
		print("Error: dialogue dictionary doesn't exist")
		return {}
	else:
		return json_dicts[0] # so for some reason parse_string returns an array with 1 element which is a dict
