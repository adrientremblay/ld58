class_name Grave extends Area3D

# Children
@onready var grave_camera = $GraveCamera

# Properties
var grave_active = false

# Constants
var RAY_LENGTH = 500

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and grave_active:
		pickup_item()

func pickup_item():
	# Determine what a raycast vector pointing straight down should be on top of the cursor
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = grave_camera.project_ray_origin(mouse_position)
	var ray_target = ray_origin + grave_camera.project_ray_normal(mouse_position) * RAY_LENGTH
	# Creating the raycast
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, 2)
	# Casting the ray
	var result = space.intersect_ray(query)
	# Checking for a match with an artifact
	if result:
		if result.collider.is_in_group("artifact"):
			Screen.print("artifact hit")
			var artifact: Artifact = result.collider
			artifact.dragging = true
 
