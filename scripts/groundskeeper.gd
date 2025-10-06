extends CharacterBody3D

# Enums
enum Mode {
	IDLING, # standing in place
	PATROLLING, # walking between patrol nodes
	CHASING, # chasing the player
}

# Exports
@export var patrol_route: Array[Node3D]
@export var player: Player

# Children
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var idle_timer: Timer = $IdleTimer
@onready var footstep_sounds: Node3D = $FootstepSounds
@onready var footstep_animation_player: AnimationPlayer = $FootstepAnimationPlayer
@onready var you_there_stop_sound: AudioStreamPlayer3D = $YouThereStop
@onready var humming_sound: AudioStreamPlayer3D = $Humming

# Properties
var current_mode: Mode = Mode.PATROLLING
var patrol_node_index: int = 0

# Constants
var BASE_SPEED = 1.5
var RUN_MULTIPLIER = 4.0

func _ready() -> void:
	animation_player.play("Walk")
	footstep_animation_player.play("walk_slow")

func _physics_process(delta: float) -> void:
	if current_mode == Mode.IDLING:
		return
	
	var new_velocity: Vector3 = Vector3.ZERO
	if current_mode == Mode.PATROLLING:
		var direction = patrol_route[patrol_node_index].global_position - global_position
		direction.y = 0
		if direction.length() < 0.01:
			current_mode = Mode.IDLING
			idle_timer.start()
			animation_player.play("Idle")
			footstep_animation_player.stop()
			return
		direction = direction.normalized()
		footstep_animation_player.play("walk_slow")
		new_velocity = direction * BASE_SPEED
	elif current_mode == Mode.CHASING:
		var direction = (player.global_position - global_position)
		direction.y = 0
		direction = direction.normalized()
		new_velocity = direction * RUN_MULTIPLIER
		footstep_animation_player.play("walk")
		animation_player.play("Run")
		
	self.velocity = new_velocity
	look_at(self.global_position + velocity)
	move_and_slide()
	
func _on_idle_timer_timeout() -> void:
	patrol_node_index = (patrol_node_index + 1) % patrol_route.size()
	current_mode = Mode.PATROLLING
	animation_player.play("Walk")
	footstep_animation_player.play("walk_slow")
	idle_timer.stop()

func play_random_footstep():
	var footstep_sounds_list = footstep_sounds.get_children()
	var random_sound = footstep_sounds_list[randi_range(0, footstep_sounds_list.size()-1)]
	random_sound.play()

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if current_mode != Mode.CHASING and body.is_in_group("player"):
		current_mode = Mode.CHASING
		you_there_stop_sound.play()
		humming_sound.stop()
		idle_timer.stop()
