class_name Player extends CharacterBody3D

# Constants
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_MAX_ANGLE = 80
const CAMERA_MIN_ANGLE = -80

# Children
@onready var camera: Camera3D = $Camera3D
@onready var player_interaction_area: Area3D = $PlayerInteractionArea
@onready var footstep_sounds: Node = $FootstepSounds
@onready var footstep_animation_player: AnimationPlayer = $FootstepAnimationPlayer

# Properties
var looking_in_grave # indicates that the player is actively looking into a grave

func _unhandled_input(event: InputEvent):
	if looking_in_grave:
		return
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion and not looking_in_grave:
		self.rotate_y(-event.relative.x * 0.01)
		camera.rotate_x(-event.relative.y * 0.01)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(CAMERA_MIN_ANGLE), deg_to_rad(CAMERA_MAX_ANGLE))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# TODO As good practice, you should replace UI actions with custom gameplay actions.
	if not looking_in_grave:	
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			footstep_animation_player.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var areas: Array[Area3D] = player_interaction_area.get_overlapping_areas()
		for area in areas:
			if area.is_in_group("grave"):
				var grave_interaction_area: GraveInteractionArea = area
				toggle_looking_in_grave(grave_interaction_area.grave)

func toggle_looking_in_grave(grave: Grave) -> void:
	looking_in_grave = not looking_in_grave
	if looking_in_grave:
		camera.current = false
		grave.activate()
		
	else:
		camera.current = true
		grave.disactivate()
		
func play_random_footstep():
	var footstep_sounds_list = footstep_sounds.get_children()
	var random_sound = footstep_sounds_list[randi_range(0, footstep_sounds_list.size()-1)]
	random_sound.play()
