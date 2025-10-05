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
@onready var idle_timer: Timer = $IdleTimer

# Properties
var current_mode: Mode = Mode.PATROLLING

func _ready() -> void:
	animation_player.play("Walk")

func _physics_process(delta: float) -> void:
	if current_mode == Mode.PATROLLING:
		var direction = (patrol_node.global_position - global_position)
		direction.y = 0
		
		if direction.length() < 0.01:
			current_mode = Mode.IDLING
			idle_timer.start()
			animation_player.play("Idle")
		
		self.velocity = direction.normalized()
		look_at(self.global_position + direction)
		move_and_slide()
	

func _on_idle_timer_timeout() -> void:
	patrol_node = patrol_node.next
	current_mode = Mode.PATROLLING
	animation_player.play("Walk")
	idle_timer.stop()
