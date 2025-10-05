extends CharacterBody3D

# Children
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Idle")
