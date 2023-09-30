extends Node3D

var cargo_scene: PackedScene = preload("res://prefabs/cargo.tscn")
var num_boxes = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if num_boxes < 3:
		var cargo_instance = cargo_scene.instantiate()
		owner.add_child(cargo_instance)
		cargo_instance.transform = self.global_transform
		num_boxes += 1
