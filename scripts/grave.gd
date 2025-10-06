class_name Grave extends CSGBox3D

# Children
@onready var grave_camera = $GraveCamera
@onready var sack_model = $SackModel
@onready var shovel = $Shovel
@onready var shovel_spawn = $ShovelSpawn
@onready var artifact_spawns_node: Node3D = $ArtifactSpawns
@onready var player_stand_position: Node3D = $PlayerStandPosition
@onready var grave_stone_variants: Array[Node] = $GravestoneVariants.get_children()

# Artifact scenes
@onready var pocket_watch_scene: PackedScene = preload("res://assets/models/pocket_watch/pocket_watch.tscn")
@onready var ring_scene: PackedScene = preload("res://scenes/ring.tscn")
@onready var doll_scene: PackedScene = preload("res://scenes/doll.tscn")
@onready var gauntlet_scene: PackedScene = preload("res://scenes/gauntlet.tscn")
@onready var rat_scene: PackedScene = preload("res://scenes/rat.tscn")
@onready var talisman_scene: PackedScene = preload("res://scenes/talisman.tscn")

# Properties
var grave_active = false

# Constants
const RAY_LENGTH = 500

# Signals
signal collect_artifact(artifact: Artifact)
signal move_artifact_label_to_cursor(artifact: Artifact)

func _ready() -> void:
	sack_model.visible = false
	shovel.visible = false
	
	# only show one of the gravestones
	var gravestone_to_show = randi_range(0, 2)
	for i in range(0, grave_stone_variants.size()):
		if i == gravestone_to_show:
			grave_stone_variants[i].visible = true
		else:
			grave_stone_variants[i].visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and grave_active:
		pickup_item()
	if event.is_action_pressed("interact"):
		if not grave_active:
			move_artifact_label_to_cursor.emit(null)

func _unhandled_input(event: InputEvent) -> void:
	if grave_active and event is InputEventMouseMotion:
		# Casting the ray
		var result = shoot_ray()
		# Checking for a match with an artifact
		if result:
			if result.collider.is_in_group("artifact"):
				var artifact: Artifact = result.collider
				if artifact.dragging:
					move_artifact_label_to_cursor.emit(null)
					return
				move_artifact_label_to_cursor.emit(artifact)
			else:
				move_artifact_label_to_cursor.emit(null)
		else:
				move_artifact_label_to_cursor.emit(null)

func pickup_item():
	# Casting the ray
	var result = shoot_ray()
	# Checking for a match with an artifact
	if result:
		if result.collider.is_in_group("artifact"):
			var artifact: Artifact = result.collider
			artifact.dragging = true
		elif result.collider.is_in_group("tool"):
			var tool: Tool = result.collider
			tool.dragging = true
 
func activate() -> void:
	grave_camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	grave_active = true
	sack_model.visible = true
	shovel.visible = true
	
	# Reset the position of the shovel
	shovel.sleeping = true
	shovel.freeze = true
	shovel.linear_velocity = Vector3.ZERO
	shovel.angular_velocity = Vector3.ZERO
	shovel.set_deferred("global_position", shovel_spawn.global_position)
	shovel.set_deferred("basis", Basis().looking_at(Vector3.FORWARD, Vector3.UP))
	shovel.sleeping = false
	shovel.freeze = false

func disactivate() -> void:
	grave_camera.current = false 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	grave_active = false
	sack_model.visible = false
	shovel.visible = false

func _on_sack_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("artifact"):
		var artifact: Artifact = body
		collect_artifact.emit(artifact)
		artifact.queue_free()

func shoot_ray() -> Dictionary:
	# Determine what a raycast vector pointing straight down should be on top of the cursor
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = grave_camera.project_ray_origin(mouse_position)
	var ray_target = ray_origin + grave_camera.project_ray_normal(mouse_position) * RAY_LENGTH
	# Creating the raycast
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, 2)
	# Casting the ray
	var result = space.intersect_ray(query)
	return result

func spawn_artifacts() -> void:
	var artifact_spawns: Array[Node] = artifact_spawns_node.get_children()
	var indexes_order = range(0, artifact_spawns.size()) # indexes to spawn stuff in
	indexes_order.shuffle() # randomize the list
	var current_index = 0
	
	# Detereming what the global spawn chance boost should be based on upgrades
	var spawn_chance_boost: float = 0.0
	for i in range(0, Global.active_upgrades.size()):
		var artifact_name = Global.active_upgrades[i]
		if artifact_name == Global.ArtifactName.GOLD_RING:
			spawn_chance_boost += 0.05
	#Screen.print("spawn chance boost=" + str(spawn_chance_boost))
	
	# try and spawn pocket watch
	if randf() <= Global.SPAWN_CHANCE_MAP[Global.ARTIFACT_DATA[Global.ArtifactName.POCKET_WATCH].rarity] + spawn_chance_boost:
		artifact_spawns[indexes_order[0]].add_child(pocket_watch_scene.instantiate())
	
	# try and spawn a doll
	if randf() <= Global.SPAWN_CHANCE_MAP[Global.ARTIFACT_DATA[Global.ArtifactName.DOLL].rarity] + spawn_chance_boost:
		artifact_spawns[indexes_order[1]].add_child(doll_scene.instantiate())
	
	# try and spawn a ring
	if randf() <= Global.SPAWN_CHANCE_MAP[Global.ARTIFACT_DATA[Global.ArtifactName.GOLD_RING].rarity] + spawn_chance_boost:
		artifact_spawns[indexes_order[2]].add_child(ring_scene.instantiate())
	
	# try and spawn a silver gauntlet
	if randf() <= Global.SPAWN_CHANCE_MAP[Global.ARTIFACT_DATA[Global.ArtifactName.SILVER_GAUNTLET].rarity] + spawn_chance_boost:
		artifact_spawns[indexes_order[3]].add_child(gauntlet_scene.instantiate())
	
	# try and spawn a rat
	if randf() <= Global.SPAWN_CHANCE_MAP[Global.ARTIFACT_DATA[Global.ArtifactName.RAT].rarity] + spawn_chance_boost:
		artifact_spawns[indexes_order[4]].add_child(rat_scene.instantiate())
	
	# try and spawn a talisman
	if randf() <= Global.SPAWN_CHANCE_MAP[Global.ARTIFACT_DATA[Global.ArtifactName.TALISMAN].rarity] + spawn_chance_boost:
		artifact_spawns[indexes_order[5]].add_child(talisman_scene.instantiate())

func _on_mound_full_fully_uncovered() -> void:
	spawn_artifacts()
