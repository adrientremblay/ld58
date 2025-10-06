extends Camera3D

# Constants
const RADIUS: float = 10.0

# Properties
# Angles in radians
var theta: float = 0.0  # horizontal rotation
var phi: float = 0.0    # vertical rotation
# Rotation speed
var speed_theta: float = 0.5
var speed_phi: float = 0.2

func _process(delta: float) -> void:
	# Increment angles
	theta += speed_theta * delta
	phi += speed_phi * delta

	# Clamp phi to avoid flipping at poles
	phi = clamp(phi, -PI/2 + 0.01, PI/2 - 0.01)

	# Convert spherical coordinates to Cartesian
	var x = RADIUS * cos(phi) * cos(theta)
	var y = RADIUS * sin(phi)
	var z = RADIUS * cos(phi) * sin(theta)

	global_transform.origin = Vector3(x, y, z)
	look_at(Vector3.ZERO, Vector3.UP)  # Always look at origin
