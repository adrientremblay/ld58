extends Node3D

# Children
@onready var hud = $HUD

# Properties
var money = 20

func _ready() -> void:
	$groundskeeper/AnimationPlayer.play("Idle")

func _on_grave_collect_artifact(artifact: Artifact) -> void:
	var value = artifact.value
	money += value
	hud.update_money_label(money)
