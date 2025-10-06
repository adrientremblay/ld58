extends Camera3D

# Constants

# Theta, Phi, Radius
const SCRIPT = [
	[PI/2, PI/6, 5.0],
	[0.0, PI/4, 5.0],
	[PI/2, PI/4, 5.0],
	[0.0, PI/6, 5.0]
]

# Properties
var radius: float = 0.0

# Angles in radians
var theta: float = 0.0  # horizontal rotation
var phi: float = 0.0    # vertical rotation

# Rotation speed
var speed_theta: float = 0.5
var speed_phi: float = 0.5
var speed_radius: float = 0.5

var script_index: int = 0

func _ready() -> void:
	theta = SCRIPT[0][0]
	phi = SCRIPT[0][1]
	radius = SCRIPT[0][2]

func _process(delta: float) -> void:
	# Increment angles
	theta = lerp(theta, SCRIPT[script_index][0], delta * speed_theta)
	phi = lerp(phi, SCRIPT[script_index][1], delta * speed_phi)
	# Increment radius
	radius = lerp(radius, SCRIPT[script_index][2], delta * speed_radius)

	# Clamp phi to avoid flipping at poles
	phi = clamp(phi, -PI/2 + 0.01, PI/2 - 0.01)

	# Convert spherical coordinates to Cartesian
	var x = radius * cos(phi) * cos(theta)
	var y = radius * sin(phi)
	var z = radius * cos(phi) * sin(theta)

	global_transform.origin = Vector3(x, y, z)
	look_at(Vector3(0,0.5,0), Vector3.UP)  # Always look at origin
	
	# Go to next script index
	if abs(theta -SCRIPT[script_index][0]) < 0.05 and abs(phi -SCRIPT[script_index][1]) < 0.05 :
		script_index = (script_index+1) % SCRIPT.size()
		theta = SCRIPT[script_index][0]
		phi = SCRIPT[script_index][1]
		radius = SCRIPT[script_index][2]
		script_index = (script_index+1) % SCRIPT.size()
