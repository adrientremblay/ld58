class_name ArtifactSlot extends Area3D

# Properties
var artifact: Artifact = null

func _on_body_entered(body: Node3D) -> void:
	if not artifact and body.is_in_group("artifact"):
		artifact = body
	
func _physics_process(delta: float) -> void:
	if artifact:
		artifact.global_position = self.global_position
