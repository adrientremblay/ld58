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
@onready var footstep_sounds: Node3D = $FootstepSounds
@onready var footstep_animation_player: AnimationPlayer = $FootstepAnimationPlayer

# Properties
var current_mode: Mode = Mode.PATROLLING

func _ready() -> void:
	animation_player.play("Walk")
	footstep_animation_player.play("walk_slow")

func _physics_process(delta: float) -> void:
	if current_mode == Mode.PATROLLING:
		var direction = (patrol_node.global_position - global_position)
		direction.y = 0
		
		if direction.length() < 0.01:
			current_mode = Mode.IDLING
			idle_timer.start()
			animation_player.play("Idle")
			footstep_animation_player.stop()
			return
		
		self.velocity = direction.normalized()
		look_at(self.global_position + direction)
		move_and_slide()
		footstep_animation_player.play("walk_slow")
	

func _on_idle_timer_timeout() -> void:
	patrol_node = patrol_node.next
	current_mode = Mode.PATROLLING
	animation_player.play("Walk")
	footstep_animation_player.play("walk_slow")
	idle_timer.stop()

		
func play_random_footstep():
	var footstep_sounds_list = footstep_sounds.get_children()
	var random_sound = footstep_sounds_list[randi_range(0, footstep_sounds_list.size()-1)]
	random_sound.play()
