extends Node3D

func _ready() -> void:
	$Groundskeeper/AnimationPlayer.play("Idle") # TODO fix this
	$Coffin/AnimationPlayer.play("open")
	
	hide_all()

func _on_lore_button_pressed() -> void:
	hide_all()
	$AnchorCenter/Lore.visible = true

func _on_instructions_button_pressed() -> void:
	hide_all()
	$AnchorCenter/Instructions.visible = true

func _on_controls_button_pressed() -> void:
	hide_all()
	$AnchorCenter/Controls.visible = true

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func hide_all():
	$AnchorCenter/Lore.visible = false
	$AnchorCenter/Instructions.visible = false
	$AnchorCenter/Controls.visible = false
