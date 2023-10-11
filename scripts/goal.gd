extends StaticBody3D

@onready var player = $"../Player"
@onready var speechbubble = $Speech
@onready var timer = $Speech/Timer

@export var waiting_for_mail: bool = true # is this character expecting mail?
@onready var dialogue_manager = $"../DialogueManager"

var id: int

func _ready():
	randomize() # init rng
	id = randi() % 3 # 0 1 or 2
	speechbubble.text = ""

func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	if waiting_for_mail:
		if body is RigidBody3D:
			var cargo_id = body.get_cargo_id()
			if cargo_id == id: # correct package has been delivered
				dialogue_manager.display_text(speechbubble, "goal_success")
				player.get_node("Inventory").add_subtract_money(5)
				waiting_for_mail = false
			else:
				dialogue_manager.display_text(speechbubble, "goal_mismatch") # incorrect package

#func display_text(new_text: String): # NOTE: char by char is broken
#	speechbubble.text = "" # clear previous message
#	var current_text: String = ""
#	for char in new_text:
#		timer.start()
#		current_text += char
#		speechbubble.text = current_text
#		await _on_timer_timeout()

func _on_timer_timeout():
	pass # Replace with function body.
