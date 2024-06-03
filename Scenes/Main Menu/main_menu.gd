class_name MainMenu
extends Control

@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@export var starting_level = preload("res://Scenes/main.tscn") as PackedScene

func _ready():
	handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(starting_level)

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	start.button_down.connect(on_start_pressed)
	options.button_down.connect(on_options_pressed)
	exit.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
