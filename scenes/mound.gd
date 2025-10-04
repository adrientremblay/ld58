class_name Mound extends Node3D

# Children
@onready var mound_top = $MoundTop
@onready var mound_mid = $MoundMid
@onready var mound_bottom = $MoundBottom

@onready var area_top: Area3D = $TopArea
@onready var area_mid: Area3D  = $MidArea
@onready var area_bottom: Area3D  = $BottomArea

@onready var unearth_sound: AudioStreamPlayer = $Unearth

# Signals
signal fully_uncovered

# Properties
var uncovered_top = false
var uncovered_mid = false
var uncovered_bottom = false


func _on_top_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("tool") and mound_top:
		mound_top.queue_free()
		area_top.monitoring = false
		unearth_sound.play()
		uncovered_top = true
		check_if_uncovered()

func _on_mid_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("tool") and mound_mid:
		mound_mid.queue_free()
		area_mid.monitoring = false
		unearth_sound.play()
		uncovered_mid = true
		check_if_uncovered()

func _on_bottom_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("tool") and mound_bottom:
		mound_bottom.queue_free()
		area_bottom.monitoring = false
		unearth_sound.play()
		uncovered_bottom = true
		check_if_uncovered()

func check_if_uncovered() -> void:
	if uncovered_top and uncovered_mid and uncovered_bottom:
		fully_uncovered.emit()
