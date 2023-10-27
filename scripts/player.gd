extends CharacterBody3D

@onready var camera_target = $CamTarget
@onready var character_body = $CharacterBody
@onready var cam_arm = $CamTarget/CamArm

@export var SPEED = 5.0
@export var rotate_speed = 0.5
const JUMP_VELOCITY = 4.5
const MAX_UP_VELOCITY = 8
var onGround: bool = false # used to detect landing

@onready var object_hold_position = $ObjectHoldPosition
var objects_in_range = []
var held_object: RigidBody3D
@onready var inventory = $Inventory

signal money_changed(amount: int)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Get the mouse

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if is_on_floor():
#			camera_target.rotation.y = 0 # NOTE: FIX THIS
			rotate_y(-event.relative.x * 0.005) # rotate cam side to side
			character_body.rotate_y(event.relative.x * 0.005) # keep character from spinning
			camera_target.rotate_x(-event.relative.y * 0.005) # rotate cam up and down
			camera_target.rotation.x = clamp(camera_target.rotation.x, -PI/2, PI/2)
			
			# using other arms
#			rotate_y(-event.relative.x * 0.005) # rotate cam side to side
##			character_body.rotate_y(event.relative.x * 0.005) # keep character from spinning
#			cam_arm.rotate_x(-event.relative.y * 0.005) # rotate cam up and down
#			cam_arm.rotation.x = clamp(cam_arm.rotation.x, -PI/2, PI/2)
		else:
			camera_target.rotate_y(-event.relative.x * 0.005)
			cam_arm.rotate_x(-event.relative.y * 0.005)
			cam_arm.rotation.x = clamp(cam_arm.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
#	print("full: ", rotation, " camtarget: ", camera_target.rotation, " camarm: ", cam_arm.rotation)
	# Add the gravity.
	if not is_on_floor():
#		velocity.y -= gravity * delta
		velocity.y -= (gravity * delta)
#		velocity.z = SPEED
		onGround = false
	else:
		if not onGround:
			landing() # player has just landed on the ground
		onGround = true

	# DEBUG
	if Input.is_action_just_pressed("debug"):
		print("\nSelf Rotation: ", rotation.y)
		print("CameraTarget Rotation: ", camera_target.rotation.y)

	# Handle held objects
	if Input.is_action_just_pressed("interact"):
		if objects_in_range.size() > 0 and not held_object: # only hold one thing at a time
			for object in objects_in_range:
				if object.is_in_group("Grabbable"):
					held_object = object
					held_object.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
					break
			
		elif held_object:
			held_object.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
			held_object = null

	if held_object:
		held_object.global_transform.origin = object_hold_position.global_transform.origin

	# Handle Jump.
	if Input.is_action_pressed("jump"):
		if velocity.y < MAX_UP_VELOCITY:
			velocity.y += JUMP_VELOCITY
		else:
			velocity.y = MAX_UP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	if is_on_floor():
#		rotation.y = 0 # reset rotation from flying
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			character_body.look_at(position + direction)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	# attempt at tank controls (for flying only)
	else:
		character_body.rotation.y = 0 # face forward in the air
		# calculate braking
			# check Brake control
			
		# calculate rotation amount
			# check input_dir.x
		rotate_y(-input_dir.x * rotate_speed)
			
		# always move forward
		var direction = (transform.basis * Vector3(0, 0, -1)).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

	move_and_slide()

func landing():
	# set player rotation equal to camera_target.y rotation, then reset camera target y rotation to 0
	var old_rotation = rotation.y
	var new_rotation_vec = camera_target.global_transform.basis.get_euler() # get current camera rotation
	rotation.y = new_rotation_vec.y # rotate character to where camera was facing
	character_body.rotate_y(old_rotation - rotation.y) # make it so char body doesn't spin
	camera_target.rotation.y = 0 # reset cam target y rotation for next takeoff
	

func _on_item_detection_body_entered(body):
	if body != self:
		objects_in_range.append(body)
	# NOTE: give these objects an outline later?

func _on_item_detection_body_exited(body):
	objects_in_range.erase(body)

func _on_inventory_money_changed(amount):
	money_changed.emit(amount)
