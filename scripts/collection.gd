extends Node3D

# Children
@onready var collection_camera: Camera3D = $Camera3D

# Properties
var collection_active: bool = true

# Constants
const RAY_LENGTH = 500

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and collection_active:
		pickup_item()

# TODO get this working
func _unhandled_input(event: InputEvent) -> void:
	if collection_active and event is InputEventMouseMotion:
		# Casting the ray
		var result = shoot_ray()
		# Checking for a match with an artifact
		if result:
			if result.collider.is_in_group("artifact"):
				var artifact: Artifact = result.collider
				if artifact.dragging:
					#move_artifact_label_to_cursor.emit(null)
					return
				#move_artifact_label_to_cursor.emit(artifact)
			#else:
				#move_artifact_label_to_cursor.emit(null)
		#else:
				#move_artifact_label_to_cursor.emit(null)
				

func shoot_ray() -> Dictionary:
	# Determine what a raycast vector pointing straight down should be on top of the cursor
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = collection_camera.project_ray_origin(mouse_position)
	var ray_target = ray_origin + collection_camera.project_ray_normal(mouse_position) * RAY_LENGTH
	# Creating the raycast
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, 2)
	# Casting the ray
	var result = space.intersect_ray(query)
	return result
	
func pickup_item():
	# Casting the ray
	var result = shoot_ray()
	# Checking for a match with an artifact
	if result:
		if result.collider.is_in_group("artifact"):
			var artifact: Artifact = result.collider
			artifact.dragging = true
