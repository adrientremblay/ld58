class_name Mound extends Node3D

# Children
@onready var mound_top = $MoundTop
@onready var mound_mid = $MoundMid
@onready var mound_bottom = $MoundBottom

@onready var area_top: Area3D = $TopArea
@onready var area_mid: Area3D  = $MidArea
@onready var area_bottom: Area3D  = $BottomArea

func _on_top_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("tool") and mound_top:
		mound_top.queue_free()
		area_top.monitoring = false

func _on_mid_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("tool") and mound_mid:
		mound_mid.queue_free()
		area_mid.monitoring = false

func _on_bottom_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("tool") and mound_top:
		mound_bottom.queue_free()
		area_bottom.monitoring = false
