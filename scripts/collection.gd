class_name Collection extends Node3D

# Children
@onready var collection_camera: Camera3D = $Camera3D
@onready var artifact_spawners: Array[Node] = $ArtifactSpawners.get_children()

# Properties
var collection_active: bool = false

# Constants
const RAY_LENGTH = 500

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and collection_active:
		pickup_item()
	if event.is_action_pressed("collection"):
		if collection_active:
			collection_active = false
			collection_camera.current = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			collection_active = true
			collection_camera.current = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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

func add_to_collection(artifact_type: Artifact.ArtifactName):
	for artifact_spawner: ArtifactSpawner in artifact_spawners:
		if artifact_spawner.artifact_type == artifact_type:
			artifact_spawner.increment_stock()
