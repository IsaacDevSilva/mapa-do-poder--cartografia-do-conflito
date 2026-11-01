extends Node2D
var som = 0


@onready var paginas_tutorial = [
	$tutorial_panel_01,
	$tutorial_panel_02,
	$tutorial_panel_03,
	$tutorial_panel_04,
	$tutorial_panel_05,
	$tutorial_panel_06,
	$tutorial_panel_07,
	$tutorial_panel_08,
]
const LARGURA_TELA = 1152.0
const DURACAO_SLIDE = 0.35  # segundos que a página leva para deslizar

var pagina_atual = 0
var fechando_tutorial = false
var tween_pagina: Tween = null  # animação de troca de página em andamento


func _ready() -> void:
	for pagina in paginas_tutorial:
		if pagina != null:
			pagina.visible = false

func _physics_process(delta: float) -> void:
	$AudioStreamPlayer2D2.pitch_scale = som
	som = $ColorRect2/HSlider.value
	$AudioStreamPlayer2D2.volume_db = $"ColorRect2/67".value
	$AudioStreamPlayer2D2.volume_linear = $"ColorRect2/68".value
func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas +69/Mundo.tscn")

func _on_creditos_pressed() -> void:
	$"animaçao pergaminho".play()

func _on_configuraçoes_pressed() -> void:
	pass




func _on_tutorial_pressed() -> void:
	pagina_atual = 0
	paginas_tutorial[0].visible = true
	$"animaçao pergaminho".play("animaçao tutorial")

func _on_proxima_pagina_pressed() -> void:
	if pagina_atual < paginas_tutorial.size() - 1:
		trocar_pagina(pagina_atual + 1)

func _on_pagina_anterior_pressed() -> void:
	if pagina_atual > 0:
		trocar_pagina(pagina_atual - 1)

func _on_fechar_tutorial_pressed() -> void:
	fechando_tutorial = true
	$"animaçao pergaminho".play_backwards("animaçao tutorial")


func trocar_pagina(nova_pagina: int) -> void:
	if tween_pagina != null and tween_pagina.is_running():
		return

	var saindo = paginas_tutorial[pagina_atual]
	var entrando = paginas_tutorial[nova_pagina]
	var indo_para_tras = nova_pagina < pagina_atual


	entrando.position.x = -LARGURA_TELA if indo_para_tras else LARGURA_TELA
	entrando.visible = true

	tween_pagina = create_tween()
	tween_pagina.set_trans(Tween.TRANS_SINE)
	tween_pagina.set_ease(Tween.EASE_OUT)
	tween_pagina.set_parallel(true)
	tween_pagina.tween_property(entrando, "position:x", 0.0, DURACAO_SLIDE)
	tween_pagina.tween_property(saindo, "position:x", LARGURA_TELA if indo_para_tras else -LARGURA_TELA, DURACAO_SLIDE)


	tween_pagina.set_parallel(false)
	tween_pagina.tween_callback(func():
		saindo.visible = false
		saindo.position.x = 0.0
	)

	pagina_atual = nova_pagina


func _on_animaçao_pergaminho_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animaçao tutorial":

		if fechando_tutorial:
			paginas_tutorial[pagina_atual].visible = false
			fechando_tutorial = false
		$painel_principal.visible = true


func _on_jogar_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()


func _on_tutorial_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()


func _on_creditos_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()


func _on_button_pressed() -> void:
	$ColorRect2.visible = true
	$AudioStreamPlayer2D2.play()
