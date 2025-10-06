extends StaticBody3D

func _ready() -> void:
	self.rotate(Vector3.UP, randf_range(0, 360))
