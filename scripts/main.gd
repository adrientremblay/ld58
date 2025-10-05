extends Node3D

# Children
@onready var hud = $HUD

# Properties
var money = 20

func _ready() -> void:
	pass

func _on_grave_collect_artifact(artifact: Artifact) -> void:
	var value = artifact.value
	money += value
	hud.update_money_label(money)

func end_game() -> void:
	Global.score = money
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

func _on_player_die() -> void:
	end_game()
