@tool
extends RichTextEffect
class_name RichTextGhost

# Syntax: [ghost freq=5.0 span=10.0][/ghost]

# Define the tag name.
var bbcode = "ghost"

# Timing parameters
const WAVE_DURATION = 6  # Time for the wave to run before stopping
#const STOP_DURATION = 2.0  # Time for the wave to be inactive
const WAVE_FREQUENCY = 5.4 # Speed of the wave oscillation
const INITIAL_AMPLITUDE = 54.0 # Maximum amplitude of the wave
const DAMPING_FACTOR = 2.5 # Controls how fast the wave dies out
var STOP_DURATION = 5
func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	#seed(12345) 
	
	var time = Time.get_ticks_msec() / 1000.0  # Convert to seconds
	var cycle_time = WAVE_DURATION + STOP_DURATION  # Total cycle length
	var phase = fmod(time, cycle_time)  # Get the time position in the cycle

	if phase < STOP_DURATION:
		# During stop phase, reset position
		char_fx.offset = Vector2.ZERO
	else:
		var wave_time = phase - STOP_DURATION  # Time elapsed in wave phase
		
		# Rising effect using a sigmoid-like smooth growth
		var rise_factor = sin((wave_time / WAVE_DURATION) * PI)  # Smooth increase and decrease
		
		# Damping effect as the wave progresses
		var damping = exp(-DAMPING_FACTOR * (wave_time / WAVE_DURATION))  # Exponential decay
		
		# Combined wave effect with rising and damping
		var amplitude = INITIAL_AMPLITUDE * rise_factor * damping
		var offset = sin(wave_time * WAVE_FREQUENCY + char_fx.relative_index * 0.5) * amplitude
		
		char_fx.offset = Vector2(0, offset)

	return true  # Effect applied
