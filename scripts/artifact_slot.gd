class_name ArtifactSlot extends Area3D

# Signals
signal should_update_global_equipped_artifacts_list

# Properties
var artifact: Artifact = null

func _on_body_entered(body: Node3D) -> void:
	if not artifact and body.is_in_group("artifact"):
		# Add an artifact
		artifact = body
		should_update_global_equipped_artifacts_list.emit()
	
func _process(delta: float) -> void:
	if artifact and artifact.dragging:
		# Remove an artifact
		artifact = null
		should_update_global_equipped_artifacts_list.emit()

func _physics_process(delta: float) -> void:
	if artifact:
		artifact.global_position = self.global_position
