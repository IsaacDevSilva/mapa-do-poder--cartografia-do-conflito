extends Node2D

var tutorial_rodando = false
var painel_tutorial_ativo = null

func _ready() -> void:
	$tutorial_panel_01.visible = false
	$tutorial_panel_02.visible = false
	$tutorial_panel_03.visible = false
	$tutorial_panel_04.visible = false



func _on_jogar_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	get_tree().change_scene_to_file("res://Cenas +69/Mundo.tscn")

func _on_creditos_pressed() -> void:
	$"animaçao pergaminho".play()

func _on_tutorial_pressed() -> void:
	$tutorial_panel_01.visible = true
	$"animaçao pergaminho".play("animaçao tutorial")
	tutorial_rodando = true

func _on_configuraçoes_pressed() -> void:
	pass


func _on_proxima_pag_pressed() -> void:
	_slide_entre_paineis($tutorial_panel_01, $tutorial_panel_02, false)

func _on_proxima_pag_02_pressed() -> void:
	_slide_entre_paineis($tutorial_panel_02, $tutorial_panel_03, false)

func _on_proxima_pag_03_pressed() -> void:
	_slide_entre_paineis($tutorial_panel_03, $tutorial_panel_04, false)

func _on_voltar_catalogo_pressed() -> void:
	_slide_entre_paineis($tutorial_panel_02, $tutorial_panel_01, true)

func _on_voltar_catalogo_02_pressed() -> void:
	_slide_entre_paineis($tutorial_panel_03, $tutorial_panel_02, true)

func _on_voltar_catalogo_03_pressed() -> void:
	_slide_entre_paineis($tutorial_panel_04, $tutorial_panel_03, true)



func _on_voltar_principal_01_pressed() -> void:
	voltar_ao_principal($tutorial_panel_01)

func _on_voltar_principal_02_pressed() -> void:
	voltar_ao_principal($tutorial_panel_02)

func _on_voltar_principal_03_pressed() -> void:
	voltar_ao_principal($tutorial_panel_03)

func _on_voltar_principal_04_pressed() -> void:
	voltar_ao_principal($tutorial_panel_04)

func voltar_ao_principal(painel: Node) -> void:
	painel_tutorial_ativo = painel
	tutorial_rodando = false
	$"animaçao pergaminho".play_backwards("animaçao tutorial")


func _slide_entre_paineis(saindo: Panel, entrando: Panel, voltar: bool) -> void:
	var largura = 1152.0


	entrando.position.x = -largura if voltar else largura
	entrando.visible = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)


	tween.tween_property(entrando, "position:x", 0.0, 0.35)

	tween.tween_property(saindo, "position:x", largura if voltar else -largura, 0.35)


	tween.set_parallel(false)
	tween.tween_callback(func(): saindo.visible = false; saindo.position.x = 0.0)

func _on_animaçao_pergaminho_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animaçao tutorial":
		tutorial_rodando = false
		if painel_tutorial_ativo != null:
			painel_tutorial_ativo.visible = false
			painel_tutorial_ativo = null
		$painel_principal.visible = true
