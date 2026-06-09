extends Node2D
var botao
var vbox
var pais = null
var estatisticas_aberto = false
var demandas_aberto = false
var data
var dia_atual 
var mes_atual
var ano_atual = 2026
var turno = 1
var soma_pesos = 0
var pais_compra
var turno_atual = 0
#assasinar o gabriel temponi
func _ready() -> void:
	for vbox in $escolha.get_children():
		if vbox is VBoxContainer:
			for botao in vbox.get_children():
				if botao is Button:
					botao.pressed.connect(_botao_clicado.bind(botao))
	$dia.text = str(randi_range(1,30))
	$mes.text = str("janeiro")
	$ano.text = str(2026)
	

func _process(delta: float) -> void:
	if pais != null:
		$pais_nome.text = pais
		
func _botao_clicado(botao):
	pais = botao.name
	$escolha.visible = false
	print(pais)


func _on_estatisticas_pressed() -> void:
	if estatisticas_aberto == false:
		$"animaçoes_geral".play("estatisticas_animaçao")
		estatisticas_aberto = true
		var texto = ""
		for chave in paises.paises[pais]:
			var valor = paises.paises[pais][chave]
			if chave == "pib":
				valor = str(valor) + " T"
			elif chave == "populacao":
				valor = str(valor) + " M"
			texto += str(chave) + ": " + str(valor) + "\n"
		$info_estatisticas.text = texto
	elif estatisticas_aberto:
		$"animaçoes_geral".play_backwards("estatisticas_animaçao")
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
	turno += 1
	demandas(turno)
	
func _on_demandas_pressed() -> void:
	if not demandas_aberto:
		$"animaçoes_geral".play("demandas_animation")
		demandas_aberto = true
	elif demandas_aberto:
		$"animaçoes_geral".play_backwards("demandas_animation")
		demandas_aberto = false
		
func _on_botao_voltar_com_corrente_pressed() -> void:
	if demandas_aberto:
		$"animaçoes_geral".play_backwards("demandas_animation")
		demandas_aberto = false
		
func demandas(turno):
	if turno_atual != turno:
		turno_atual = turno
		var paises_compra_escolhidos = []
		while paises_compra_escolhidos.size() < 5:
			var acumulado = 0
			soma_pesos = 0
			# Soma os pesos dos países ainda não escolhidos
			for pais_compra in paises.paises:
				if not pais_compra in paises_compra_escolhidos:
					soma_pesos += paises.paises[pais_compra]["comodits"]
			var sorteio_compra = randf_range(0, soma_pesos)
			# Sorteio ponderado
			for pais_compra in paises.paises:
				if pais_compra in paises_compra_escolhidos:
					continue
				acumulado += paises.paises[pais_compra]["comodits"]
				if sorteio_compra <= acumulado:
					paises_compra_escolhidos.append(pais_compra)
					break
		$Control/label_qtd_compra.text = ""
		$Control/Label_paises_compra.text =  ""
		$Control/Label_preco_compra.text = ""
		# Gerar ofertas dos 5 países sorteados
		for pais_nome in paises_compra_escolhidos:
			var pib = paises.paises[pais_nome]["pib"]
			var comodits = paises.paises[pais_nome]["comodits"]
			# País rico vende menos
			var quantidade_base = (comodits * 1000) / max(pib, 1)
			var quantidade = int(quantidade_base * randf_range(0.7, 1.3))
			# País rico vende mais caro
			var preco_base = (pib * 10.0) / max(comodits, 1)
			var preco = snapped(preco_base * randf_range(0.9, 1.1),0.01)
			$Control/Label_paises_compra.text +=  pais_nome + "\n" 
			$Control/label_qtd_compra.text += str(quantidade) + "\n" 
			$Control/Label_preco_compra.text +=  "$" + str(preco) + "\n" 
			print(
				pais_nome,
				" | Quantidade: ",
				quantidade,
				" | Preço: ",
				preco
			)
