extends StaticBody3D

func _ready() -> void:
	self.rotate(Vector3.UP, randf_range(0, 360))
	var random_scale = randf_range(0.9, 1.1)
	self.scale = Vector3(random_scale,random_scale,random_scale)
