extends Control
#var random_pairs = [1, 2,3,12,13,14,15,16]
var opr=["+"]
#var opr=["+","-","×","÷"]
#var opr=["÷"]
#var opr=["×"]
var combos=20 # Note 0 - pick all, N - how much u want
var random_pairs = [11,90,1]
#var random_pairs = [3]
var random_pairs0 = [11,90,1]
#var random_pairs = [21,22,23,24,25,26,27,28,29]
# Variables for the numbers and answer

var correct_answer = 0
var answe_inut=""
var max
# Nodes for UI elements
@onready var corr = $Correct

@onready var shader = $shader
@onready var bg_music = $bg_music
@onready var rich = $test
@onready var label_num1 = $"Container/Operation/2Values/Label"
@onready var label_num2 = $"Container/Operation/2Values/Label2"
@onready var label_num3 = $"Container/Label3"
@onready var oper = $Container/Operation/oper
@onready var level = $Level
@onready var bg = $PanelContainer
@onready var pipefall = $pipefall
@onready var del = $pop
@onready var press = $press
@onready var skip_cont = $HBoxContainer/skip_count
@onready var huh = $huh
@onready var line = $"Container/Operation/2Values/line"
var unblock=true

var viewport_size
var temp=0
var skips=1
func _ready():
	viewport_size = DisplayServer.screen_get_size()
	center_y=viewport_size.y
	center_x=viewport_size.x/2

	#draw_circular()
	init()
	skip_cont.text=str(skips)
	generate_problem()
	#$Line2D.points = [Vector2(0, 0), Vector2(100, 100)]

func _on_back_pressed() -> void:
	if skips >0:
		skips-=1
		unblock=true
		skip_cont.text = str(skips) if skips > 0 else ""
		reset()
	else:
		skip_cont.text=""
var numbers = []
var count = 10  # Number of numbers to display
var a = 560 # Horizontal radius (Width)
var b = 300  # Vertical radius (Height)

var center_y 
var center_x
#var center_y = DisplayServer.screen_get_size()[1] -100
#var center_x = DisplayServer.screen_get_size()[0]/3
#var center_y =  DisplayServer.screen_get_size()[1]/2
#var center_x = DisplayServer.screen_get_size()[0]/5


var selected_index = 0
var tween_duration = 0.3  # Smooth transition speed
func draw_circular():
	var custom_font = FontVariation.new()
	custom_font.base_font = load("res://fonts/MinecraftRegular-Bmg3.otf") 
	#print( DisplayServer.screen_get_size()[1]/2)
 # Generate labels for numbers
	for i in range(count):
		var label = Label.new()
		label.text = str(i)
		label.add_theme_font_override("font",custom_font)
		label.add_theme_font_size_override("font_size", 70)
		add_child(label)
		numbers.append(label)
	
	update_positions(false)  # Default `animated` value will be False here
var last_press_time = 0
var debounce_time = 0.2  # Adjust delay as needed (in seconds)
func update_positions(animated = true):  # Default value is set here
	for i in range(count):
		var index_offset = (i - selected_index) % count  # Adjusted offset
		var angle = deg_to_rad(-90 + (360 / (count)) * index_offset)  # Distribute angles
		var pos_x = a * cos(angle) + center_x
		var pos_y = b * sin(angle) + center_y  # Adjust y to position lower on screen
		
		var target_position = Vector2(pos_x + 0, pos_y)  # Offset to screen center

		if animated:
			var tween = get_tree().create_tween()
			tween.tween_property(numbers[i], "position", target_position, tween_duration)
		else:
			numbers[i].position = target_position
	
	highlight_selected()
func timer():
	if current_time - last_press_time > debounce_time:
		last_press_time = current_time
		return true
var current_time
func highlight_selected():
	for i in range(count):
		numbers[i].modulate = Color(1, 1, 1, 0.5)  # Dim all numbers
	numbers[selected_index].modulate = Color(1, 1, 1, 1)  # Highlight selected one
func _input(event):
		#if event is InputEventKey:
			#print(event.as_text())
		
		var text = event.as_text()
	
		current_time = Time.get_ticks_msec() / 1000.0
		#print(text)
		if Input.get_joy_axis(0, JOY_AXIS_LEFT_X) > 0.8 and timer():
			selected_index = (selected_index + 1) % count
			update_positions()
		#if Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT) and timer():
			#selected_index = (selected_index + 1) % count
			#update_positions()
		elif Input.get_joy_axis(0, JOY_AXIS_LEFT_X) < -0.8 and timer():
			selected_index = (selected_index - 1) % count
			update_positions()
			
		elif Input.is_joy_button_pressed(0, JOY_BUTTON_Y) and timer() and (answe_inut).length() <= max+1 :
			
			answe_inut=str(abs(count+selected_index)%count)+answe_inut
			#label_num3.text = str(answe_inut) if answe_inut != 0 else ""
			label_num3.text = answe_inut

			
		elif Input.is_joy_button_pressed(0, JOY_BUTTON_B) and timer():
			answe_inut = answe_inut.substr(1)
			del.play()
			#label_num3.text = str(answe_inut) if answe_inut != 0 else ""
			label_num3.text = (answe_inut)

		if event is InputEventKey and event.pressed and event.keycode == KEY_M:
			if bg_music.is_playing():
				temp=bg_music.get_playback_position()
				bg_music.stop()
			else:
				bg_music.play(temp)
			
			
		if event is InputEventKey and ((event.keycode == KEY_BACKSPACE or event.keycode == 4194322))and event.pressed and unblock :	
			#answe_inut=answe_inut/10

			answe_inut = answe_inut.substr(1)

			del.play()
			#label_num3.text = str(answe_inut) if answe_inut != 0 else ""
			label_num3.text = (answe_inut)
		if event is InputEventKey and unblock and (answe_inut).length() <= max+1  and event.pressed:	
			if text.begins_with("Kp "):
				press.play()
				#answe_inut=answe_inut*10+ text.substr(3).to_int()
				answe_inut=text.substr(3)+answe_inut
				label_num3.text = str(answe_inut)
				
			elif text.is_valid_int():
				press.play()
				#answe_inut=answe_inut*10+ text.to_int()
				answe_inut=text+answe_inut
			#label_num3.text = str(answe_inut) if answe_inut != 0 else ""
				label_num3.text = answe_inut
				
		if (Input.is_joy_button_pressed(0, JOY_BUTTON_BACK) and timer()) or event is InputEventKey and event.keycode == KEY_ENTER and label_num3.text != "" and event.pressed:
			if unblock:
				unblock=false
				check_answer()
				
			else:
				unblock=true
				reset()
	
# Generate a new math problem


func generate_nums():
	var combinations = []
	#for i in range(random_pairs.size()):
	for i in range(random_pairs[0],random_pairs[1], random_pairs[2]):
		for j in range(random_pairs0[0],random_pairs0[1], random_pairs0[2]):
			if i+j <=99:
				combinations.append([i ,j])
			#if i > j or picked_oper != "×":
			#	combinations.append([i, j])
			
	return combinations
			
#var random_pair=[]

var random_pair
func init():
	random_pairs=generate_nums()
	random_pairs.shuffle()
	if combos != 0 and random_pairs.size() > combos:
		random_pairs=random_pairs.slice(0, combos)
var picked_oper
var colors=["2e222f", "625565","966c6c","694f62","7f708a"]
func generate_problem():
	#print(random_pairs)
	#print("size: " + str(random_pairs.size()))
	
	#var size=random_pairs.size()
	if (random_pairs.size() % 10 == 0):
		var stylebox = StyleBoxFlat.new()
	
	# Set the background color
		stylebox.bg_color = colors[random_pairs.size()/10 % colors.size()]  # RGB values in the range [0, 1]
		#bg.add_theme_color_override("panel","blue")
		bg.add_theme_stylebox_override("panel",stylebox)

	level.text="lygis: "+str(random_pairs.size())
	#if size != :
	random_pair=random_pairs[0]
	max=str(max(random_pair[0],random_pair[1])).length()
	picked_oper=opr.pick_random()
	oper.text=picked_oper
	#line.text="─"
	match  picked_oper:
		"+":
			oper.add_theme_color_override("font_outline_color", "4d65b4")
			#oper.add_theme_color_override("font_color", "blue")
			correct_answer = random_pair[0] + random_pair[1]
		"-":
			oper.add_theme_color_override("font_outline_color", "f79617")
			#oper.add_theme_color_override("font_color", "orange")
			correct_answer = random_pair[0] - random_pair[1]
		"×":
			oper.add_theme_color_override("font_outline_color", "fbff86")
			correct_answer = random_pair[0] * random_pair[1]
		"÷":
			oper.add_theme_color_override("font_outline_color", "4c3e24")
			correct_answer = random_pair[0] / random_pair[1]
	
	#label_num1.set_text("[tornado radius=10.0 freq=1.0 connected=1] "+str(random_pair[0]))
	label_num1.text="[ghost amp=100.0 freq=4.0 connected=1]"+str(random_pair[0])
	label_num2.text = "[ghost amp=100.0 freq=4.0 connected=1]"+str(random_pair[1])
	

func reset():
	answe_inut=""
	label_num3.text = ""
	corr.text=""
		#label_num3.text = "Try again!"
	label_num3.add_theme_color_override("font_color","white")
	level.add_theme_color_override("font_color","white")

	random_pairs.erase(random_pair)
	if random_pairs.size() != 0:
		#shader.material.set_shader_param("onoff",1)
		#shader.material.set
		generate_problem() # Generate a new problem
	else:
		get_tree().change_scene_to_file("res://end_screen.tscn")
# Check the player's answer
func check_answer():

	if answe_inut == str(correct_answer):
		
		

		#label_num3.text = "Correct!"
		label_num3.add_theme_color_override("font_color","1ebc73")
		level.add_theme_color_override("font_color","1ebc73")
		pipefall.play()
		Global.correct_ans+=1

		
		

		
		
	else:
		label_num3.add_theme_color_override("font_color","c32454")
		level.add_theme_color_override("font_color","c32454")
		huh.pitch_scale=(1.0-(((Global.bad_answ+1.0)/50.0)))
		corr.text=str(correct_answer)
		huh.play()
		Global.bad_answ+=1	
