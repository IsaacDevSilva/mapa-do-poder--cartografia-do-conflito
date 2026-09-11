extends Node2D 
var pais = null 
var estatisticas_aberto = false 
var demandas_aberto = false 
var demanda_compra_aberto = false 
var demanda_venda_aberto = false 
var mapa_aberto = false 
var acoes_aberto = false
var investimento_aberto = false
var sancionar_aberto = false
var turno_de_verificaçao = 1
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
var ofertas_vendas = []
var pib_de_comparacao 

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
		formatar_dinheiro(capital) 
		paises.paises[pais].erase("respeito_nacional")

func _botao_clicado(botao): 
	pais = botao.name 
	capital = paises.paises[pais]["pib"] 
	$escolha.visible = false 
	print(pais) 
	$capital.text = formatar_dinheiro(capital) 
	$AudioStreamPlayer2D.play()
 
 
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
	gerenciar_progresso()
	dia_atual = int(randi_range(1,30)) 
	mes_atual = int(randi_range(1,12)) 
	ano_atual = int(ano_atual+ 1) 
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
		ofertas_vendas.clear()
 
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
 
		# Labels separados 
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
			var quantidade = max(int(quantidade_base * randf_range(1, 2)),0.5) 
 
			var preco_base = (pib)/ randf_range(1.5,5.0)
			var preco = max(snapped(preco_base * randf_range(0.8,1.2), 1),0.5) 
 
			# Salva a oferta 
			ofertas.append({ 
				"pais": pais_nome, 
				"qtd": quantidade, 
				"preco": preco 
			}) 
 
			labels_nome[i].text = pais_nome 
			labels_qtd[i].text = str(quantidade) 
			labels_preco[i].text = "$" + str(preco) 
			 
			 
			#separaçao 67 
			 
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
 
		# Labels separados 
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
			var quantidade_vendas = max(int(quantidade_base_vendas * randf_range(1, 2)),0.5) 
 
			var preco_base_vendas = (pib_vendas ) / randf_range(1.5,5.0)
			var preco_vendas = max(snapped(preco_base_vendas * randf_range(0.8,1.2), 1),0.5) 
 
			# Salva a oferta 
			ofertas_vendas.append({ 
				"pais": pais_nome_venda, 
				"qtd": quantidade_vendas, 
				"preco": preco_vendas 
			}) 
 
			labels_nome_vendas[i].text = pais_nome_venda 
			labels_qtd_vendas[i].text = str(quantidade_vendas) 
			labels_preco_vendas[i].text = "$" + str(preco_vendas) 
 
 
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
 
func _on_button_investuir_pressed() -> void:
	if sancionar_aberto:
		$"animaçoes_geral".play_backwards("animaçao_sancionar")
		sancionar_aberto = false
		await $"animaçoes_geral".animation_finished
	$"animaçoes_geral".play("animaçao_investir")
	investimento_aberto = true

func _on_button_sancionarraaa_pressed() -> void:
	if investimento_aberto:
		$"animaçoes_geral".play_backwards("animaçao_investir")
		investimento_aberto = false
		await $"animaçoes_geral".animation_finished
	$"animaçoes_geral".play("animaçao_sancionar")
	sancionar_aberto = true

func _on_botao_lateral_demandas_pressed() -> void: 
	if not demandas_aberto: 
		$"animaçoes_geral".play("demandas_animation") 
		demandas_aberto = true 
func _on_button_acoes_pressed() -> void:
	$"animaçoes_geral".play("animaçao_acoes")
	acoes_aberto = true
func _on_botao_voltar_com_corrente_pressed() -> void: 
	if $"animaçoes_geral".is_playing(): 
		return 
		
	if investimento_aberto:
		$"animaçoes_geral".play_backwards("animaçao_investir")
		investimento_aberto = false
	if sancionar_aberto:
		$"animaçoes_geral".play_backwards("animaçao_sancionar")
		sancionar_aberto = false
	elif acoes_aberto and not investimento_aberto and not sancionar_aberto:
	
		$"animaçoes_geral".play_backwards("animaçao_acoes")
		acoes_aberto = false

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
		 
func formatar_dinheiro(valor): 
	if valor >= 1: 
		return str(valor) + "B" 
	else: 
		return str(valor) + " B" 
 
 
 
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
	paises.paises[pais]["respeito_nacional"] += 5
	paises.paises[oferta["pais"]]["respeito_nacional"]+=5

	paises.paises[pais]["materia_prima"] += oferta["qtd"] 
 
	$capital.text = formatar_dinheiro(capital) 
 
func vender(indice_vendas):
	if indice_vendas >= ofertas_vendas.size(): 
		return 
 
	var oferta_vendas = ofertas_vendas[indice_vendas] 
 
	if capital < oferta_vendas["preco"]: 
		print("Capital insuficiente!") 
		return 
 
	if paises.paises[pais]["materia_prima"] < oferta_vendas["qtd"]:
		print("Matéria-prima insuficiente!")
		return
 
	capital += oferta_vendas["preco"] 
	paises.paises[pais]["materia_prima"] -= oferta_vendas["qtd"] 
	paises.paises[pais]["respeito_nacional"] += 5
	paises.paises[oferta_vendas["pais"]]["respeito_nacional"]+=5
	$capital.text = formatar_dinheiro(capital) 
 

func acoes():
	pass



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

func _on_botao_venda_1_pressed() -> void:
	vender(0)
func _on_botao_venda_2_pressed() -> void:
	vender(1)
func _on_botao_venda_3_pressed() -> void:
	vender(2)
func _on_botao_venda_4_pressed() -> void:
	vender(3)
func _on_botao_venda_5_pressed() -> void:
	vender(4)
func gerenciar_progresso():
	
	if turno == 1 and turno_de_verificaçao == 1:
		pib_de_comparacao = paises.paises[pais]["pib"]
		turno_de_verificaçao += 5
		print("verificado")
		print(pib_de_comparacao)
	elif turno == turno_de_verificaçao:
		print(pib_de_comparacao)
		var pib_atual = paises.paises[pais]["pib"]
		if pib_atual < (pib_de_comparacao + (pib_de_comparacao*10)/100):
			destruiçao_planetaria()
		elif pib_atual < (pib_de_comparacao + (pib_de_comparacao*10)/100):
			pib_de_comparacao = pib_atual
		turno_de_verificaçao += 5
#espço dedicado ao script das animaçoes finais
func destruiçao_planetaria():

	var destruicao_aleatoria = randi_range(1,1)
	if destruicao_aleatoria == 1:
		$"animaçao_final_extraterrestre".visible = true
		$"animaçao_final_extraterrestre".play("pedro")
		await $"animaçao_final_extraterrestre".animation_finished
		$"animaçao_final_extraterrestre/Sprite2D".visible = true
		$"animaçoes_finais".play(("animaçao_da_animaçao_final_alienigena"))

	
