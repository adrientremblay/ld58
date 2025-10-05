class_name ArtifactSpawner extends Area3D

# Constants
@onready var pocket_watch_scene: PackedScene = preload("res://assets/models/pocket_watch/pocket_watch.tscn")

# Children
@onready var artifact_name_label: Label3D = $ArtifactNameLabel
@onready var quantity_label: Label3D = $QuantityLabel

# Exports
@export var artifact_type: Artifact.ArtifactName

# Properties
var spawn_artifact_scene: PackedScene
var artifact: Artifact
var stock: int = 100 # remaining stock BESIDES the one already in the chamber

func _ready() -> void:
	match artifact_type:
		Artifact.ArtifactName.POCKET_WATCH:
			spawn_artifact_scene = pocket_watch_scene
			artifact_name_label.text = "Pocket Watch"
	
	quantity_label.text = str(stock + 1) + "x"
	
func _process(delta: float) -> void:
	if artifact and artifact.dragging:
		artifact = null
	if not artifact:
		var new_artifact: Artifact = spawn_artifact_scene.instantiate()
		self.add_child(new_artifact)
		artifact = new_artifact
		stock -= 1
		quantity_label.text = str(stock + 1) + "x"

func _physics_process(delta: float) -> void:
	if artifact:
		artifact.global_position = self.global_position
