extends Control


var master_bus = AudioServer.get_bus_index("Master")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/options_menu.tscn")
	


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main_menu.tscn")


func _on_audio_pressed() -> void:
	$Panel2.visible = true


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30 :
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)




func _on_check_button_toggled(toggled_on: bool) -> void:
	var MasterSound = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(MasterSound, toggled_on)
