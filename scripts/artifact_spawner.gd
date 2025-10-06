class_name ArtifactSpawner extends Area3D

# Constants
@onready var pocket_watch_scene: PackedScene = preload("res://assets/models/pocket_watch/pocket_watch.tscn")
@onready var gold_ring: PackedScene = preload("res://scenes/ring.tscn")
@onready var doll: PackedScene = preload("res://scenes/doll.tscn")
@onready var gauntlet: PackedScene = preload("res://scenes/gauntlet.tscn")
@onready var rat: PackedScene = preload("res://scenes/rat.tscn")

# Children
@onready var artifact_name_label: Label3D = $ArtifactNameLabel
@onready var quantity_label: Label3D = $QuantityLabel

# Exports
@export var artifact_type: Global.ArtifactName

# Properties
var spawn_artifact_scene: PackedScene
var artifact: Artifact
var stock: int = 0

func _ready() -> void:
	match artifact_type:
		Global.ArtifactName.POCKET_WATCH:
			spawn_artifact_scene = pocket_watch_scene
			artifact_name_label.text = "Pocket Watch"
		Global.ArtifactName.GOLD_RING:
			spawn_artifact_scene = gold_ring
			artifact_name_label.text = "Gold Ring"
		Global.ArtifactName.DOLL:
			spawn_artifact_scene = doll
			artifact_name_label.text = "Doll"
		Global.ArtifactName.SILVER_GAUNTLET:
			spawn_artifact_scene = gauntlet
			artifact_name_label.text = "Silver Gauntlet"
		Global.ArtifactName.RAT:
			spawn_artifact_scene = rat
			artifact_name_label.text = "Dirty Rat"
	
	quantity_label.text = str(stock) + "x"
	
func _process(delta: float) -> void:
	if artifact and artifact.dragging:
		stock -= 1
		quantity_label.text = str(stock) + "x"
		artifact = null
	if not artifact and stock > 0:
		var new_artifact: Artifact = spawn_artifact_scene.instantiate()
		self.add_child(new_artifact)
		artifact = new_artifact

func _physics_process(delta: float) -> void:
	if artifact:
		artifact.global_position = self.global_position
		artifact.rotate_y(delta)

func increment_stock() -> void:
	stock += 1
	quantity_label.text = str(stock) + "x"
