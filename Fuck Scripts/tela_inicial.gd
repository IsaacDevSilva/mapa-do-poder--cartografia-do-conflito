extends Node2D

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/Mundo.tscn")


func _on_catalogo_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/catalogo.tscn")
