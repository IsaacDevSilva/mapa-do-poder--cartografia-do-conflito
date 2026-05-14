extends Node2D

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/Mundo.tscn")

func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/creditos.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/catalogo.tscn")


func _on_configuraçoes_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/configuraçao.tscn")
