class_name Tool extends RigidBody3D

# TODO A lot of copied code here from the artifact class
# TODO This should probably be refactored into a dragabble component

# Children
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Constants
var UP_FORCE = 2.5 # The constant number used for the y axis when being dragged so that the artifact goes up
var Y_CAP = 1 # The max Y position to apply the upward force to

# Properties
var dragging = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and dragging:
		dragging = false
		dig()

func _physics_process(delta: float) -> void:
	if not dragging:
		return
		
	# Tools should always points forward when being held
	#look_at(Vector3.FORWARD)
	
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

func dig() -> void:
	# determine what the speed scale should be based on the equipped artifacts
	var speed_scale: float = 1.0
	for i in range(0, Global.active_upgrades.size()):
		var artifact_name = Global.active_upgrades[i]
		if artifact_name == Global.ArtifactName.POCKET_WATCH:
			speed_scale += Global.ARTIFACT_DATA[Global.ArtifactName.POCKET_WATCH].number
		elif artifact_name == Global.ArtifactName.SILVER_GAUNTLET:
			speed_scale *= Global.ARTIFACT_DATA[Global.ArtifactName.SILVER_GAUNTLET].number
	Screen.print("Speed scale=" + str(speed_scale))
	
	animation_player.speed_scale = speed_scale
	animation_player.play("dig")
