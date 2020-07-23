extends Node2D

var grid = {} 
var width = Globals.width
var height = Globals.height
var cell_size = 32
var spawn_rate = Globals.spawn_rate
var cell =  preload("res://Scenes/Cell.tscn")
const MSPEED = 40

func _ready():
	VisualServer.set_default_clear_color("black")
	randomize()
	init_grid()
	randomize_grid()

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x += MSPEED
	elif Input.is_action_pressed("ui_right"):
		position.x += -MSPEED
	elif Input.is_action_pressed("ui_up"):
		position.y += MSPEED
	elif Input.is_action_pressed("ui_down"):
		position.y += -MSPEED

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				$Tween.interpolate_property(self, "scale", scale, Vector2(scale.x*1.5 , scale.y*1.5), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
			if event.button_index == BUTTON_WHEEL_DOWN:
				$Tween.interpolate_property(self, "scale", scale, Vector2(scale.x/1.5, scale.y/1.5), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()

func init_grid():
	for y in height:
		for x in width:
			var new_cell = cell.instance()
			new_cell.initalize_tile(x, y)
			new_cell.rect_position = (Vector2($StartPos.position.x + x*cell_size, $StartPos.position.y + y*cell_size))
			add_child(new_cell)
			grid[Vector2(x,y)] = new_cell

func randomize_grid():
	for y in height:
		for x in width:
			var cell = grid[Vector2(x,y)]
			if rand_range(1,101) <= spawn_rate:
				cell.set_type(0)
			else:
				cell.set_type(1)
		
func get_living_neighbors(cell):
	var living_neighbors = 0
	for i in range(-1,2):
		for j in range(-1,2):
			var x = cell.x+i
			var y = cell.y+j
			if i == 0 and j == 0:
				pass
			elif x >= 0 and x <= width - 1 and y >= 0 and y <= height - 1:
				if grid[Vector2(x,y)].get_type() == 0:
					living_neighbors += 1
					
	return living_neighbors

func turn():
	var types = []
	for y in height:
		for x in width:
			cell = grid[Vector2(x,y)]
			var living_neighbors = get_living_neighbors(cell)
			
			if cell.get_type() == 0:
				if living_neighbors < 2 or living_neighbors > 3:
					types.append(1)
				elif living_neighbors == 2 or living_neighbors == 3:
					types.append(0)
				else:
					types.append(1)
			
			elif living_neighbors == 3:
				types.append(0)
			else:
				types.append(1)
				
	var i = 0
	for y in height:
		for x in width:
			grid[Vector2(x,y)].set_type(types[i])
			i += 1


func _on_TurnTimer_timeout():
	turn()

func _on_Resetter_pressed():
	randomize_grid()
