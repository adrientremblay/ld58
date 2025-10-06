extends Node3D

func _ready() -> void:
	$Groundskeeper/AnimationPlayer.play("Idle")
	$Coffin/AnimationPlayer.play("open")
