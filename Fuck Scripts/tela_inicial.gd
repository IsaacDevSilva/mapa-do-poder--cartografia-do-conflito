extends Node2D

func _ready() -> void:
	$tutorial_panel_01.visible = false
	$tutorial_panel_02.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/Mundo.tscn")

func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/creditos.tscn")

func _on_tutorial_pressed() -> void:
	$painel_principal.visible = false
	$tutorial_panel_01.visible = true
func _on_configuraçoes_pressed() -> void:
	pass
func _on_proxima_pag_pressed() -> void:
	$tutorial_panel_01.visible = false
	$painel_principal.visible = false
	$tutorial_panel_02.visible = true

func _on_voltar_principal_01_pressed() -> void:
	$tutorial_panel_01.visible = false
	$painel_principal.visible = true
	$tutorial_panel_02.visible = false
func _on_voltar_catalogo_pressed() -> void:
	$tutorial_panel_01.visible = true
	$painel_principal.visible = false
	$tutorial_panel_02.visible = false
func _on_voltar_principal_02_pressed() -> void:
	$tutorial_panel_01.visible = false
	$painel_principal.visible = true
	$tutorial_panel_02.visible = false
	
