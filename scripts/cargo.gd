extends RigidBody3D

@export var id: int : get = get_cargo_id, set = set_cargo_id
@onready var mesh: MeshInstance3D = $MeshInstance3D
#@export var red: Color # NOTE: replace these with textures later
#@export var yellow: Color
#@export var blue: Color
@export var red: StandardMaterial3D
@export var yellow: StandardMaterial3D
@export var blue: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # init rng
	id = randi() % 3 # 0 1 or 2
	if id == 0:
#		mesh.mesh.material.albedo_color = red
		mesh.mesh.material = red
		print("red")
	elif id == 1:
		mesh.mesh.material = yellow
		print("yellow")
	elif id == 2:
		mesh.mesh.material = blue
		print("blue")
	else:
		print("Error: id is " + str(id))

func set_cargo_id(new_id: int):
	id = new_id

func get_cargo_id():
	return id
