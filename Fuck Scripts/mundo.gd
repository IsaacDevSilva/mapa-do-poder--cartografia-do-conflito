extends Node2D 
signal pais_escolhido
@export var mostrar_tutorial = true
var pais = null 
var estatisticas_aberto = false 
var demandas_aberto = false 
var demanda_compra_aberto = false 
var demanda_venda_aberto = false 
var mapa_aberto = false 
var acoes_aberto = false
var investimento_aberto = false
var sancionar_aberto = false
var dificuldade_atual
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
var imposto_arrecadado
var imposto_total
var qualidade_de_vida
var taxa_de_imposto_nao_base
var primeiravez = true
var taxa_de_imposto
var constituicao_aberto = false
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

	
	if mostrar_tutorial:
		add_child(preload("res://Cenas +69/tutorial_guiado.tscn").instantiate())
	 
 
func _process(delta: float) -> void: 
	if pais != null: 
		$pais_nome.text = pais 
		capital = paises.paises[pais]["pib"] 
		$capital.text = formatar_dinheiro(capital) 
		formatar_dinheiro(capital) 
		if primeiravez:
			taxa_de_imposto_nao_base = paises.paises[pais]["taxa_imposto"]
			primeiravez = false
	marcador_paises()


func _botao_clicado(botao): 
	pais = botao.name 
	capital = paises.paises[pais]["pib"] 
	$escolha.visible = false 
	print(pais) 
	$capital.text = formatar_dinheiro(capital) 
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.volume_linear = 15

	if botao.is_in_group("paisesfaceis"):
		dificuldade_atual = "facil"
		print(dificuldade_atual)
	elif botao.is_in_group("paisesmedios"):
		dificuldade_atual = "medio"
		print(dificuldade_atual)
	elif botao.is_in_group("paisesdificeis"):
		dificuldade_atual = "dicil"
		print(dificuldade_atual)
	pais_escolhido.emit()
	
	
 
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
		if chave == "pib" or chave == "idh": 
			continue
		elif chave == "populacao": 
			valor = str(valor) + " M" 
		texto += str(chave) + ": " + str(valor) + "\n" 
		
	$info_estatisticas.text = texto 
	$idh.text = str(paises.paises[pais]["idh"])
	impostos()
	despesas_do_governo()

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
func _on_button_pressed() -> void:
	$"animaçoes_geral".play_backwards("animaçao_mapa")
	mapa_aberto = false
 
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
	acoes()
func _on_botao_voltar_com_corrente_pressed() -> void:
	
	if acoes_aberto and not investimento_aberto and not sancionar_aberto and not constituicao_aberto:
		$"animaçoes_geral".play_backwards("animaçao_acoes")
		acoes_aberto = false 
	elif investimento_aberto:
		$"animaçoes_geral".play_backwards("animaçao_investir")
		investimento_aberto = false
	elif sancionar_aberto:
		$"animaçoes_geral".play_backwards("animaçao_sancionar")
		sancionar_aberto = false
	elif constituicao_aberto:
		$"animaçoes_geral".play_backwards("animacao_constituicao")
		constituicao_aberto = false
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
	var valor_grafico
	if valor >= 1000: 
		valor_grafico = str((valor)/1000) + "T" 
		return valor_grafico
	else: 
		valor_grafico = str(valor) + "B" 
		return valor_grafico
 
 
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
	if oferta["pais"] != pais:
		paises.paises[oferta["pais"]]["respeito_nacional"] += 5
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
	paises.paises[pais]["pib"] += oferta_vendas["preco"]
	paises.paises[pais]["materia_prima"] -= oferta_vendas["qtd"] 
	if oferta_vendas["pais"] != pais:
		paises.paises[oferta_vendas["pais"]]["respeito_nacional"] += 5

	paises.paises[oferta_vendas["pais"]]["respeito_nacional"]+=5
	$capital.text = formatar_dinheiro(capital) 
 

func acoes():
	$PergaminhoDadosPais4_investbb/Label5.text = str(paises.paises[pais]["saude"])
	$PergaminhoDadosPais4_investbb/Label6.text = str(paises.paises[pais]["seguranca"])
	$PergaminhoDadosPais4_investbb/Label7.text = str(paises.paises[pais]["educacao"])
	$PergaminhoDadosPais4_investbb/Label9.text = str(paises.paises[pais]["idh"])
	$PergaminhoDadosPais4_investbb/Label11.text = str(paises.paises[pais]["pib"])

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
	elif turno == turno_de_verificaçao:
		var pib_atual = paises.paises[pais]["pib"]
		if pib_atual < (pib_de_comparacao + (pib_de_comparacao*25)/100):
			destruiçao_planetaria()
		elif pib_atual >= (pib_de_comparacao + (pib_de_comparacao*25)/100):
			pib_de_comparacao = pib_atual
		turno_de_verificaçao += 5
		
	if dificuldade_atual == "facil":
		if paises.paises[pais]["pib"] >= 4000 and paises.paises[pais]["idh"] >= 0.9:
			destruiçao_planetaria()
	if dificuldade_atual == "medio":
		if paises.paises[pais]["pib"] >= 2000 and paises.paises[pais]["idh"] >= 0.8:
			destruiçao_planetaria()
	if dificuldade_atual == "dificil":
		if paises.paises[pais]["pib"] >= 1000 and paises.paises[pais]["idh"] >= 0.7:
			destruiçao_planetaria()

func marcador_paises():
	for pin in get_tree().get_nodes_in_group("pinsmapa"):
		var nome_pais_pin = pin.name.replace("TagMapa", "").to_upper()
		var chave_encontrada = ""
		# Procura o país ignorando os acentos
		for chave in paises.paises.keys():
			var nome_chave = str(chave).to_upper()

			var nome_pin_limpo = nome_pais_pin
			nome_pin_limpo = nome_pin_limpo.replace("Á", "A")
			nome_pin_limpo = nome_pin_limpo.replace("À", "A")
			nome_pin_limpo = nome_pin_limpo.replace("Â", "A")
			nome_pin_limpo = nome_pin_limpo.replace("Ã", "A")
			nome_pin_limpo = nome_pin_limpo.replace("É", "E")
			nome_pin_limpo = nome_pin_limpo.replace("Ê", "E")
			nome_pin_limpo = nome_pin_limpo.replace("Í", "I")
			nome_pin_limpo = nome_pin_limpo.replace("Ó", "O")
			nome_pin_limpo = nome_pin_limpo.replace("Ô", "O")
			nome_pin_limpo = nome_pin_limpo.replace("Õ", "O")
			nome_pin_limpo = nome_pin_limpo.replace("Ú", "U")
			nome_pin_limpo = nome_pin_limpo.replace("Ü", "U")
			nome_pin_limpo = nome_pin_limpo.replace("Ç", "C")

			nome_chave = nome_chave.replace("Á", "A")
			nome_chave = nome_chave.replace("À", "A")
			nome_chave = nome_chave.replace("Â", "A")
			nome_chave = nome_chave.replace("Ã", "A")
			nome_chave = nome_chave.replace("É", "E")
			nome_chave = nome_chave.replace("Ê", "E")
			nome_chave = nome_chave.replace("Í", "I")
			nome_chave = nome_chave.replace("Ó", "O")
			nome_chave = nome_chave.replace("Ô", "O")
			nome_chave = nome_chave.replace("Õ", "O")
			nome_chave = nome_chave.replace("Ú", "U")
			nome_chave = nome_chave.replace("Ü", "U")
			nome_chave = nome_chave.replace("Ç", "C")

			if nome_chave == nome_pin_limpo:
				chave_encontrada = str(chave)
				break

		if chave_encontrada == "":
			print("País não encontrado: ", nome_pais_pin)
			continue

		var respeito = paises.paises[chave_encontrada]["respeito_nacional"]
		respeito = clamp(respeito, 0, 100)

		if respeito < 50:
			var valor = inverse_lerp(0.0, 50.0, respeito)
			pin.modulate = Color.RED.lerp(Color.YELLOW, valor)
		else:
			var valor = inverse_lerp(50.0, 100.0, respeito)
			pin.modulate = Color.YELLOW.lerp(Color.GREEN, valor)
#espço dedicado ao script das animaçoes finais
func destruiçao_planetaria():
	$ColorRect.visible = true
	$Animation_fades.play("fade_de_transiçao")
	await $Animation_fades.animation_finished
	var destruicao_aleatoria = randi_range(1,1)
	if destruicao_aleatoria == 1:
		$"animaçao_final_extraterrestre".visible = true
		$"animaçao_final_extraterrestre".play("pedro")
		await $"animaçao_final_extraterrestre".animation_finished
		$"animaçao_final_extraterrestre/Sprite2D".visible = true
		$"animaçoes_finais".play(("animaçao_da_animaçao_final_alienigena"))
		await $"animaçoes_finais".animation_finished
		$"animaçoes_finais".play("creditos")
	#Parabéns Felipe;>D
	


func _on_investir_pressed() -> void:
	if int($PergaminhoDadosPais4_investbb/SpinBox.value + $PergaminhoDadosPais4_investbb/SpinBox2.value + $PergaminhoDadosPais4_investbb/SpinBox3.value) <= paises.paises[pais]["pib"]:
		paises.paises[pais]["seguranca"] += int($PergaminhoDadosPais4_investbb/SpinBox.value / 10)
		paises.paises[pais]["saude"] += int($PergaminhoDadosPais4_investbb/SpinBox2.value / 10)
		paises.paises[pais]["educacao"] += int($PergaminhoDadosPais4_investbb/SpinBox3.value / 10)
		paises.paises[pais]["idh"] += (($PergaminhoDadosPais4_investbb/SpinBox3.value + $PergaminhoDadosPais4_investbb/SpinBox2.value + $PergaminhoDadosPais4_investbb/SpinBox.value)/3)/1000
		paises.paises[pais]["idh"] =snappedf(paises.paises[pais]["idh"],0.01)
		var total = int($PergaminhoDadosPais4_investbb/SpinBox.value + $PergaminhoDadosPais4_investbb/SpinBox2.value + $PergaminhoDadosPais4_investbb/SpinBox3.value)
		paises.paises[pais]["pib"] -= total
		acoes()
	else: 
		print("sem capital")
func impostos():
	qualidade_de_vida = float(paises.paises[pais]["idh"]) * float(paises.paises[pais]["tecnologia"] / 100.0) 
	var taxa_de_producao = snapped(paises.paises[pais]["idh"],0.15) * randf_range(1,2)
	imposto_arrecadado = paises.paises[pais]["populacao"] * qualidade_de_vida * taxa_de_producao * 5
	imposto_total = imposto_arrecadado * (paises.paises[pais]["taxa_imposto"]/100.0)
	print(imposto_total)
	paises.paises[pais]["pib"] += int(imposto_total)
func despesas_do_governo():
	var qualidade_servicos = (
	float(paises.paises[pais]["saude"]) + float(paises.paises[pais]["educacao"]) + float(paises.paises[pais]["seguranca"])) / 300.0
	var gasto_social = qualidade_servicos * 0.10
	var total = imposto_arrecadado * (float(taxa_de_imposto_nao_base) / 100.0) * (0.6 + gasto_social)
	paises.paises[pais]["pib"] -= int(total)
	print(total,qualidade_servicos, gasto_social)


func _on_constituicao_pressed() -> void:
	$"animaçoes_geral".play("animacao_constituicao")
	$abrir_cosnt/SpinBox.value = paises.paises[pais]["taxa_imposto"]
	constituicao_aberto = true
func _on_alterar_cosnt_pressed() -> void:
	paises.paises[pais]["taxa_imposto"] = $abrir_cosnt/SpinBox.value
	print(paises.paises[pais]["taxa_imposto"])
