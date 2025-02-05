extends Control
@onready var yippe = $yippe
@onready var ohno = $ohno
@onready var good = $VBoxContainer/Good 
@onready var bad = $VBoxContainer/Bad
@onready var res = $VBoxContainer/Result
# Called when the node enters the scene tree for the first time.
func save_to_file(content):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(content+"\n")
	
func _ready() -> void:
	good.text="Teisingi: "+str(Global.correct_ans)
	#good.add_theme_color_override("font_color")
	bad.text="Blogi: "+str(Global.bad_answ)
	var tot=(Global.correct_ans*100/(Global.bad_answ+Global.correct_ans))
	res.text="Pazimis "+str(tot)+"%"
	if tot > 80:
		yippe.play()
	if tot < 50:
		ohno.play()
	#save_to_file(str(Time.get_time_dict_from_system()," ",tot," ",Global.correct_ans," ",Global.bad_answ))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
