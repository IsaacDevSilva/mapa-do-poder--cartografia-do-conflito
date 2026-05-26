extends Node2D
var pagina_escolhida = ""
var tutorial_rodando = false
func _ready() -> void:
	$tutorial_panel_01.visible = false
	$tutorial_panel_02.visible = false
	$tutorial_panel_03.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	escolher_texto_do_pergaminho()


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/Mundo.tscn")

func _on_creditos_pressed() -> void:

	pagina_escolhida = "creditos"
func _on_tutorial_pressed() -> void:

	pagina_escolhida = "tutorial"
	$tutorial_panel_01.visible = true
	
func _on_configuraçoes_pressed() -> void:
	pass
func _on_proxima_pag_pressed() -> void:
	$tutorial_panel_01.visible = false
	$painel_principal.visible = false
	$tutorial_panel_02.visible = true

func _on_voltar_principal_01_pressed() -> void:
	
	$painel_principal.visible = true

	$"animaçao pergaminho".play_backwards("animaçao tutorial")

	
func _on_voltar_principal_02_pressed() -> void:
	$"animaçao pergaminho".play_backwards("animaçao tutorial")
	
	tutorial_rodando = false
	
	$painel_principal.visible = true


	
func escolher_texto_do_pergaminho():
	if pagina_escolhida == "":
		pass
	elif pagina_escolhida == "tutorial" and not tutorial_rodando:
		$"animaçao pergaminho".play("animaçao tutorial")
		tutorial_rodando = true
	elif pagina_escolhida == "creditos":
		$"animaçao pergaminho".play()


func _on_voltar_catalogo_pressed() -> void:
	$tutorial_panel_02.visible = false
	$tutorial_panel_01.visible = true
	


func _on_animaçao_pergaminho_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animaçao tutorial":
	#linha six seven favor não mexer
		pagina_escolhida = ""
		tutorial_rodando = false
		
		


func _on_proxima_pag_02_pressed() -> void:
	$tutorial_panel_02.visible = false
	$tutorial_panel_03.visible = true




























































































#adoro crianças ass:gabriel temponi e companhia
