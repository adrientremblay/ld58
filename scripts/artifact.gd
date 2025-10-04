class_name Artifact extends RigidBody3D

# Properties
var dragging = false

func _physics_process(delta: float) -> void:
	if not dragging:
		return
	
	# Determine vector to apply force 
	var grave_camera = get_viewport().get_camera_3d()
	var obj_screen_pos = grave_camera.unproject_position(self.global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var direction_vector_screen = mouse_pos - obj_screen_pos
	var direction_vector_world = Vector3(direction_vector_screen.x, 0, direction_vector_screen.y)
	
	# Apply the force
	apply_central_impulse(direction_vector_world.normalized())
	#Screen.print(linear_velocity.x)
