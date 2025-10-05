extends CharacterBody3D

# Enums
enum Mode {
	IDLING,
	PATROLLING,
}

# Exports
@export var patrol_node: PatrolNode

# Children
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Walk")

func _physics_process(delta: float) -> void:
	var direction = (patrol_node.global_position - global_position)
	direction.y = 0
	self.velocity = direction.normalized()
	look_at(self.global_position + direction)
	move_and_slide()
	
