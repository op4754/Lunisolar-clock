extends Node2D

@export var sun_texture: Texture2D
@export var moon_texture: Texture2D
@onready var needle: Sprite2D = $Needle
@onready var target: Sprite2D = $Target
@onready var score_label: Label = $CanvasLayer/VBoxContainer/"Score label"
@onready var timer_label: Label = $CanvasLayer/VBoxContainer/Timer

var speed: float = 3.0
var score: int = 0
var time_left: float = 10.0
var is_game_over: bool = false

func _ready() -> void:
	var center_point = get_viewport_rect().size / 2.0
	$ClockBackground.position = center_point
	needle.position = center_point
	relocate_target()
	update_ui()

func _process(delta: float) -> void:
	if is_game_over:
		return

	needle.rotation += speed * delta
	
	time_left -= delta
	if time_left <= 0.0:
		time_left = 0.0
		game_over()
	
	update_ui()

func _unhandled_input(event: InputEvent) -> void:
	if is_game_over:
		if event.is_action_pressed("Input"):
			restart_game()
		return

	if event.is_action_pressed("Input") and not event.is_echo():
		check_hit()

func check_hit() -> void:
	var target_angle = (target.position - needle.position).angle()
	var current_angle = wrapf(needle.rotation, -PI, PI)
	var angle_diff = abs(angle_difference(current_angle, target_angle))
	
	if angle_diff < 0.4:
		score += 1
		time_left += 1.5
		speed += 0.2
		
		flash_target(Color.GREEN)
		relocate_target()
	else:
		time_left -= 2.0
		flash_target(Color.RED)

func flash_target(color: Color) -> void:
	var tween = create_tween()
	target.modulate = color
	tween.tween_property(target, "modulate", Color.WHITE, 0.2)

func relocate_target() -> void:
	if randf() > 0.5:
		target.texture = sun_texture
	else:
		target.texture = moon_texture
		
	var random_angle = randf_range(0, TAU)
	var radius: float = 230.0 
	
	target.position = needle.position + Vector2(cos(random_angle), sin(random_angle)) * radius
	

func update_ui() -> void:
	score_label.text = "Score: " + str(score)
	timer_label.text = "Time: " + str(snapped(time_left, 0.1))

func game_over() -> void:
	is_game_over = true
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(needle, "position:y", needle.position.y + 300.0, 0.6)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
		
	tween.tween_property(needle, "rotation", needle.rotation + 1.5, 0.6)
	
	tween.tween_property(target, "modulate:a", 0.0, 0.3)
	await tween.finished
	var game_over_scene = preload("res://assets/scenes/game_over.tscn")
	var game_over_instance = game_over_scene.instantiate()
	game_over_instance.final_score = score
	
	get_tree().root.add_child(game_over_instance)
	get_tree().current_scene = game_over_instance
	queue_free()

func restart_game() -> void:
	score = 0
	time_left = 10.0
	speed = 3.0
	is_game_over = false
	relocate_target()
	update_ui()
