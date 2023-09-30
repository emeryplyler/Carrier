extends StaticBody3D

@onready var player = $"../CharacterBody3D"

var id: int
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # init rng
	id = randi() % 3 # 0 1 or 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body is RigidBody3D:
		var cargo_id = body.get_cargo_id()
		if cargo_id == null:
			print("This isn't a package is it")
		else:
			if cargo_id == id:
				print("yay thanks :3")
				player.get_node("Inventory").add_subtract_money(5)
			else:
				print("i dont think this is mine")
