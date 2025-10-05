class_name ArtifactSpawner extends Area3D

# Exports
@export var spawn_artifact_scene: PackedScene

# Properties
var artifact: Artifact
	
func _process(delta: float) -> void:
	if artifact and artifact.dragging:
		artifact = null
	if not artifact:
		var new_artifact: Artifact = spawn_artifact_scene.instantiate()
		self.add_child(new_artifact)
		artifact = new_artifact

func _physics_process(delta: float) -> void:
	if artifact:
		artifact.global_position = self.global_position
