extends Control

var final_score: int = 0

@onready var final_score_label: Label = $VBoxContainer/Score

func _ready() -> void:
	final_score_label.text = "Final Score: " + str(final_score)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main_menu.tscn")
