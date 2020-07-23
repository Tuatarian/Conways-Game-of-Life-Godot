extends Node2D

func _on_Button_pressed():
	Globals.height = int($LineEdit.text)
	Globals.width = int($LineEdit2.text)
	Globals.spawn_rate = int($LineEdit3.text)
	get_tree().change_scene("res://Scenes/CellularAutomata.tscn")
