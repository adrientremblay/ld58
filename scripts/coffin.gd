extends StaticBody3D

# Children
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("CoffinAction")

func open():
	animation_player.play("open")

func _on_mound_full_fully_uncovered() -> void:
	open()
