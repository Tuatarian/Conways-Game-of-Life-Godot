extends Control

var tile_type
var x
var y
onready var anim = $AnimationPlayer

func initalize_tile(x, y):
	self.x = x
	self.y = y

func set_type(type):
	tile_type = type
	if tile_type == 0:
		$AnimationPlayer.play("Living")
	else:
		$AnimationPlayer.play("Dead")

func get_type():
	return tile_type
