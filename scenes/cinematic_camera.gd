extends Camera3D

# Constants
const RADIUS: float = 7.0

const SCRIPT = [
	[0.0, PI/6],
	[PI/2, PI/6]
]

# Properties

# Angles in radians
var theta: float = 0.0  # horizontal rotation
var phi: float = 0.0    # vertical rotation

# Rotation speed
var speed_theta: float = 0.5
var speed_phi: float = 0.2

var script_index: int = 0

func _ready() -> void:
	theta = SCRIPT[0][0]
	phi = SCRIPT[0][1]

func _process(delta: float) -> void:
	# Increment angles
	theta = lerp(theta, SCRIPT[script_index][0], delta)
	phi = lerp(phi, SCRIPT[script_index][1], delta)

	# Clamp phi to avoid flipping at poles
	phi = clamp(phi, -PI/2 + 0.01, PI/2 - 0.01)

	# Convert spherical coordinates to Cartesian
	var x = RADIUS * cos(phi) * cos(theta)
	var y = RADIUS * sin(phi)
	var z = RADIUS * cos(phi) * sin(theta)

	global_transform.origin = Vector3(x, y, z)
	look_at(Vector3.ZERO, Vector3.UP)  # Always look at origin
	
	# Go to next script index
	if abs(theta -SCRIPT[script_index][0]) < 0.05 and abs(phi -SCRIPT[script_index][1]) < 0.05 :
		script_index = (script_index+1) % SCRIPT.size()
