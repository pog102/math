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
func send_score_to_analytics(score: int):
	if OS.has_feature("HTML5"):
		# Send the score to Google Analytics as a custom event
		JavaScriptBridge.eval("""
			gtag('event', 'game_score', {
				'event_category': 'Gameplay',
				'event_label': 'Final Score',
				'value': """ + str(score) + """
			});
		""")
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
	if OS.has_feature("HTML5"):
		JavaScriptBridge.eval("""
		var script = document.createElement("script");
		script.src = "https://www.googletagmanager.com/gtag/js?id=G-TWSVN3T2KT";
		script.async = true;
		document.head.appendChild(script);

		window.dataLayer = window.dataLayer || [];
		function gtag(){dataLayer.push(arguments);}
		gtag('js', new Date());
		gtag('config', 'G-TWSVN3T2KT');""")
	send_score_to_analytics(tot)
	#save_to_file(str(Time.get_time_dict_from_system()," ",tot," ",Global.correct_ans," ",Global.bad_answ))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
