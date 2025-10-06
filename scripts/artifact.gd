class_name Artifact extends RigidBody3D

# Constants
var UP_FORCE = 2.5 # The constant number used for the y axis when being dragged so that the artifact goes up
var Y_CAP = 1 # The max Y position to apply the upward force to
var SIDEWAYS_VELOCITY_LIMIT = 10

# Properties
var dragging = false

# Exports
@export var artifact_type: Global.ArtifactName

# Data properties
var artifact_name: String
var value: float
var rarity: Global.Rarity
var effect: String #for hud only

func _ready() -> void:
	artifact_name = Global.ARTIFACT_DATA[artifact_type].name
	value = Global.ARTIFACT_DATA[artifact_type].value
	rarity = Global.ARTIFACT_DATA[artifact_type].rarity
	effect = Global.ARTIFACT_DATA[artifact_type].effect

func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and dragging:
		dragging = false

func _physics_process(delta: float) -> void:
	if not dragging:
		return
	
	var grave_camera = get_viewport().get_camera_3d()
	
	# if the object's y position is near the Y cap, set it to the Y Cap
	var mouse_pos = get_viewport().get_mouse_position()
	var camera_origin = grave_camera.project_ray_origin(mouse_pos)
	var ray_dir = grave_camera.project_ray_normal(mouse_pos)
	var t = (Y_CAP - camera_origin.y) / ray_dir.y
	var target_pos = camera_origin + ray_dir * t

	global_position = global_position.lerp(target_pos, 0.2)
	
	if global_position.y > Y_CAP - 0.2:
		global_position.y = Y_CAP
