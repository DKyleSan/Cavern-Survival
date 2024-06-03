extends Area2D

@onready var main = get_node("/root/Main")
@onready var lives_label = get_node("/root/Main/HUD/LivesLabel")

var item_type : int # 0: speed, 1: med, 2: cherry

var speed_box = preload("res://Assets/Items/speed_up.png")
var med_box = preload("res://Assets/Items/Med Kit.png")
var cherry_box = preload("res://Assets/Items/cherry.png")
var textures = [speed_box, med_box, cherry_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(body):
	#Speed
	if item_type == 0:
		body.boost()
	#Health
	elif item_type == 1:
		main.lives += 1
		lives_label.text = "X " + str(main.lives)
	#Cherry
	elif item_type == 2:
		body.quick_fire()
	#Delete item
	queue_free()
