extends CharacterBody3D

@onready var camera_target = $CamTarget
@onready var character_body = $MeshInstance3D

@export var SPEED = 5.0
#const JUMP_VELOCITY = 4.5

@onready var object_hold_position = $ObjectHoldPosition
var objects_in_range = []
var held_object

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Get the mouse

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005) # rotate cam side to side
		character_body.rotate_y(event.relative.x * 0.005) # keep character from spinning
		camera_target.rotate_x(-event.relative.y * 0.005) # rotate cam up and down
		camera_target.rotation.x = clamp(camera_target.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta

	# Handle held objects
	if Input.is_action_just_pressed("interact"):
		if objects_in_range.size() > 0 and not held_object: # only hold one thing at a time
			held_object = objects_in_range[0] # NOTE: change later?
			held_object.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC

	if held_object:
		held_object.global_transform.origin = object_hold_position.global_transform.origin

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
	var vertical_dir = Input.get_action_strength("jump") - Input.get_action_strength("descend")
	if vertical_dir != 0:
		velocity.y = vertical_dir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_item_detection_body_entered(body):
	if body != self:
		objects_in_range.append(body)
	# NOTE: give these objects an outline later?

func _on_item_detection_body_exited(body):
	objects_in_range.erase(body)
