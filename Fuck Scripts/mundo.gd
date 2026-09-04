extends Node2D 

var pais = null 
var estatisticas_aberto = false 
var demandas_aberto = false 
var demanda_compra_aberto = false 
var demanda_venda_aberto = false 
var mapa_aberto = false 

var data 
var dia_atual  
var mes_atual 
var ano_atual = 2026 
var turno = 1 

var soma_pesos = 0 
var soma_pesos_venda = 0 

var pais_compra 
var pais_venda 
var turno_atual = 0 
var capital  
var ofertas = [] 

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
	$escolha.visible = true 


func _process(delta: float) -> void: 
	if pais != null: 
		$pais_nome.text = pais 
		$capital.text = formatar_dinheiro(capital)


func _botao_clicado(botao): 
	pais = botao.name 

	# PIB está em trilhões no dicionário
	# Aqui transformamos para bilhões
	capital = paises.paises[pais]["pib"] * 1000.0 

	$escolha.visible = false 

	print(pais) 
	print("Capital inicial: ", capital, " B") 

	$capital.text = formatar_dinheiro(capital)


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
	ano_atual = int(ano_atual + 1) 

	_turnos(dia_atual,mes_atual,ano_atual) 

	turno += 1 

	demandas(turno) 

	var texto = "" 

	for chave in paises.paises[pais]: 
		var valor = paises.paises[pais][chave] 

		if chave == "pib": 
			valor = str(valor) + " T" 

		elif chave == "populacao": 
			valor = str(valor) + " M" 

		texto += str(chave) + ": " + str(valor) + "\n" 

	$info_estatisticas.text = texto 


func demandas(turno): 
	if turno_atual != turno: 
		turno_atual = turno 
		ofertas.clear() 

		var paises_compra_escolhidos = [] 

		while paises_compra_escolhidos.size() < 5: 
			var acumulado = 0 
			soma_pesos = 0 

			for pais_compra in paises.paises: 
				if not pais_compra in paises_compra_escolhidos: 
					soma_pesos += paises.paises[pais_compra]["comodits"] 

			var sorteio_compra = randf_range(0, soma_pesos) 

			for pais_compra in paises.paises: 
				if pais_compra in paises_compra_escolhidos: 
					continue 

				acumulado += paises.paises[pais_compra]["comodits"] 

				if sorteio_compra <= acumulado: 
					paises_compra_escolhidos.append(pais_compra) 
					break 


		var labels_nome = [
			$compras_interface/Label_compra1,
			$compras_interface/Label_compra2,
			$compras_interface/Label_compra3,
			$compras_interface/Label_compra4,
			$compras_interface/Label_compra5
		]

		var labels_qtd = [
			$compras_interface/Label_compra_qtd1,
			$compras_interface/Label_compra_qtd2,
			$compras_interface/Label_compra_qtd3,
			$compras_interface/Label_compra_qtd4,
			$compras_interface/Label_compra_qtd5
		]

		var labels_preco = [
			$compras_interface/Label_compra_pais1,
			$compras_interface/Label_compra_pais2,
			$compras_interface/Label_compra_pais3,
			$compras_interface/Label_compra_pais4,
			$compras_interface/Label_compra_pais5
		]


		for i in range(paises_compra_escolhidos.size()): 
			var pais_nome = paises_compra_escolhidos[i] 

			var pib = paises.paises[pais_nome]["pib"] 

			var comodits = paises.paises[pais_nome]["comodits"] 

			var quantidade_base = comodits / 2 

			var quantidade = max(
				int(quantidade_base * randf_range(1, 2)),
				0.5
			) 

			# PIB está em trilhões.
			# Transformamos para bilhões antes de calcular o preço.
			var pib_bilhoes = pib * 1000.0 

			var preco_base = (pib_bilhoes * 10) / 2 

			var preco = max(
				snapped(preco_base * randf_range(1,1), 0.01),
				0.5
			) 

			ofertas.append({
				"pais": pais_nome, 
				"qtd": quantidade, 
				"preco": preco
			}) 

			labels_nome[i].text = pais_nome 
			labels_qtd[i].text = str(quantidade) 
			labels_preco[i].text = formatar_dinheiro(preco)


		var paises_venda_escolhidos = [] 

		while paises_venda_escolhidos.size() < 5: 
			var acumulado_vendas = 0.0 
			soma_pesos_venda = 0.0 

			for pais_venda in paises.paises: 
				if pais_venda in paises_venda_escolhidos: 
					continue 

				if pais_venda in paises_compra_escolhidos: 
					continue 

				var comodits_vendas = paises.paises[pais_venda]["comodits"] 

				if comodits_vendas > 0: 
					soma_pesos_venda += 1.0 / comodits_vendas 

			var sorteio_venda = randf_range(0, soma_pesos_venda) 

			for pais_venda in paises.paises: 
				if pais_venda in paises_venda_escolhidos: 
					continue 

				if pais_venda in paises_compra_escolhidos: 
					continue 

				var comodits_vendas = paises.paises[pais_venda]["comodits"] 

				if comodits_vendas > 0: 
					acumulado_vendas += 1.0 / comodits_vendas 

					if sorteio_venda <= acumulado_vendas: 
						paises_venda_escolhidos.append(pais_venda) 
						break 


		var labels_nome_vendas = [
			$vendas_interface/nomes_dos_recursos/Label_compra1,
			$vendas_interface/nomes_dos_recursos/Label_compra2,
			$vendas_interface/nomes_dos_recursos/Label_compra3,
			$vendas_interface/nomes_dos_recursos/Label_compra4,
			$vendas_interface/nomes_dos_recursos/Label_compra5
		]

		var labels_qtd_vendas = [
			$vendas_interface/nomes_dos_recursos/Label_compra_qtd1,
			$vendas_interface/nomes_dos_recursos/Label_compra_qtd2,
			$vendas_interface/nomes_dos_recursos/Label_compra_qtd3,
			$vendas_interface/nomes_dos_recursos/Label_compra_qtd4,
			$vendas_interface/nomes_dos_recursos/Label_compra_qtd5
		]

		var labels_preco_vendas = [
			$vendas_interface/nomes_dos_recursos/Label_compra_pais1,
			$vendas_interface/nomes_dos_recursos/Label_compra_pais2,
			$vendas_interface/nomes_dos_recursos/Label_compra_pais3,
			$vendas_interface/nomes_dos_recursos/Label_compra_pais4,
			$vendas_interface/nomes_dos_recursos/Label_compra_pais5
		]


		for i in range(paises_venda_escolhidos.size()): 
			var pais_nome_venda = paises_venda_escolhidos[i] 

			var pib_vendas = paises.paises[pais_nome_venda]["pib"] 

			var comodits_vendas = paises.paises[pais_nome_venda]["comodits"] 

			var quantidade_base_vendas = comodits_vendas / 2 

			var quantidade_vendas = max(
				int(quantidade_base_vendas * randf_range(1, 2)),
				0.5
			) 

			# Converte PIB de trilhões para bilhões
			var pib_vendas_bilhoes = pib_vendas * 1000.0 

			var preco_base_vendas = (pib_vendas_bilhoes * 1.5) / 2 

			var preco_vendas = max(
				snapped(preco_base_vendas * randf_range(1,1), 0.01),
				0.5
			) 

			ofertas.append({
				"pais": pais_nome_venda, 
				"qtd": quantidade_vendas, 
				"preco": preco_vendas
			}) 

			labels_nome_vendas[i].text = pais_nome_venda 
			labels_qtd_vendas[i].text = str(quantidade_vendas) 
			labels_preco_vendas[i].text = formatar_dinheiro(preco_vendas)


func _on_botao_comprar_pressed() -> void: 
	$"animaçoes_geral".play("painel_compra") 
	demanda_compra_aberto = true 


func _on_botao_vender_pressed() -> void: 
	$"animaçoes_geral".play("animaçao_venda") 
	demanda_venda_aberto = true 


func _on_botao_lateral_mapa_pressed() -> void: 
	if not mapa_aberto: 
		$"animaçoes_geral".play("animaçao_mapa") 
		mapa_aberto = true 

	elif mapa_aberto: 
		$"animaçoes_geral".play_backwards("animaçao_mapa") 
		mapa_aberto = false 


func _on_botao_lateral_demandas_pressed() -> void: 
	if not demandas_aberto: 
		$"animaçoes_geral".play("demandas_animation") 
		demandas_aberto = true 


func _on_botao_voltar_com_corrente_pressed() -> void: 
	if $"animaçoes_geral".is_playing(): 
		return 

	if demanda_compra_aberto and demanda_venda_aberto: 
		$"animaçoes_geral".play_backwards("painel_compra") 

		await $"animaçoes_geral".animation_finished 

		$"animaçoes_geral".play_backwards("animaçao_venda") 

		await $"animaçoes_geral".animation_finished 

		$"animaçoes_geral".play_backwards("demandas_animation") 

		demandas_aberto = false 
		demanda_compra_aberto = false 
		demanda_venda_aberto = false 

	elif demanda_compra_aberto: 
		$"animaçoes_geral".play_backwards("painel_compra") 
		demanda_compra_aberto = false 

	elif demanda_venda_aberto: 
		$"animaçoes_geral".play_backwards("animaçao_venda") 
		demanda_venda_aberto = false 

	elif demandas_aberto: 
		$"animaçoes_geral".play_backwards("demandas_animation") 
		demandas_aberto = false 


# ==========================================================
# SISTEMA DE DINHEIRO
# ==========================================================

func formatar_dinheiro(valor):
	if valor >= 1000:
		return str(snapped(valor / 1000.0, 0.01)) + " T"
	else:
		return str(snapped(valor, 0.01)) + " B"


func comprar(indice): 
	if indice >= ofertas.size(): 
		return 

	var oferta = ofertas[indice] 

	if capital < oferta["preco"]: 
		print("Capital insuficiente!") 
		return 

	if paises.paises[pais]["materia_prima"] + oferta["qtd"] > paises.paises[pais]["estoque"]: 
		print("Armazém cheio!") 
		return 

	capital -= oferta["preco"] 

	paises.paises[pais]["materia_prima"] += oferta["qtd"] 

	$capital.text = formatar_dinheiro(capital)


func _on_botao_compra_1_pressed() -> void: 
	comprar(0)


func _on_botao_compra_2_pressed() -> void: 
	comprar(1)


func _on_botao_compra_3_pressed() -> void: 
	comprar(2)


func _on_botao_compra_4_pressed() -> void: 
	comprar(3)


func _on_botao_compra_5_pressed() -> void: 
	comprar(4)
