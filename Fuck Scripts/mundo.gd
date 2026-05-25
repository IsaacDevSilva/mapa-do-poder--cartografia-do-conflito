extends Node2D
var botao
var vbox
var pais = null
var estatisticas_aberto = false
var data
var dia_atual 
var mes_atual
var ano_atual = 2025

func _ready() -> void:
	for vbox in $escolha.get_children():
		if vbox is VBoxContainer:
			for botao in vbox.get_children():
				if botao is Button:
					botao.pressed.connect(_botao_clicado.bind(botao))
	

func _process(delta: float) -> void:
	if pais != null:
		$pais_nome.text = pais
		
func _botao_clicado(botao):
	pais = botao.name
	$escolha.visible = false
	print(botao)
	print(pais)


func _on_estatisticas_pressed() -> void:
	if estatisticas_aberto == false:
		$"animaçoes_geral".play("estatisticas")
		estatisticas_aberto = true
		var texto = ""
		for chave in paises.paises[pais]:
			var valor = paises.paises[pais][chave]
			if chave == "pib":
				valor = str(valor) + " T"
			elif chave == "populacao":
				valor = str(valor) + " M"
			texto += str(chave) + ": " + str(valor) + "\n"
		$"estatisticas_informaçoes".text = texto
	elif estatisticas_aberto:
		$"animaçoes_geral".play_backwards("estatisticas")
		estatisticas_aberto = false
		
func _turnos(dia_atual,mes_atual,ano_atual):
	var meses = [
		"janeiro", "fevereiro", "março", "abril",
		"maio", "junho", "julho", "agosto",
		"setembro", "outubro", "novembro", "dezembro"
		]
	mes_atual = meses[mes_atual - 1]
	
	$dia.text = str(dia_atual)
	$mes.text = str(mes_atual)
	$ano.text = str(ano_atual)

func _on_conflitar_pressed() -> void:
	dia_atual = int(randi_range(1,30))
	mes_atual = int(randi_range(1,12))
	ano_atual = int(ano_atual+ 1)
	_turnos(dia_atual,mes_atual,ano_atual)
	
