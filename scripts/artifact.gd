class_name Artifact extends RigidBody3D

# Constants
var UP_FORCE = 2.5 # The constant number used for the y axis when being dragged so that the artifact goes up
var Y_CAP = 1 # The max Y position to apply the upward force to

# Properties
var dragging = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and dragging:
		dragging = false

func _physics_process(delta: float) -> void:
	if not dragging:
		return
	
	# Determine vector to apply force 
	var grave_camera = get_viewport().get_camera_3d()
	var obj_screen_pos = grave_camera.unproject_position(self.global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var direction_vector_screen = mouse_pos - obj_screen_pos
	var direction_vector_world = Vector3(direction_vector_screen.x, UP_FORCE if global_position.y < Y_CAP else 0, direction_vector_screen.y)
	
	# Apply the force
	apply_central_impulse(direction_vector_world.normalized())
	#Screen.print(linear_velocity.x)
