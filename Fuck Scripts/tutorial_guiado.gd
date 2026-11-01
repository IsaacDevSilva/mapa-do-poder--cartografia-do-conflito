extends CanvasLayer

const PASSOS = [
	{
		"texto": "Bem-vindo ao Mapa do Poder! Seu objetivo é desenvolver seu país e fortalecer sua posição no mundo antes que o tempo da partida acabe.",
		"caixa": "cima",
	},
	{
		"texto": "Cada dificuldade tem seu tempo de partida:\nFácil (desenvolvidos): 20 min\nMédio (em desenvolvimento): 30 min\nDifícil (subdesenvolvidos): 40 min",
		"destacar": ["escolha/didiculdate_facil", "escolha/didiculdate_media", "escolha/didiculdate_dificil"],
		"caixa": "cima",
	},
	{
		"texto": "Agora escolha o país que você vai governar.",
		"esperar": "pais",
		"caixa": "cima",
	},
	{
		"texto": "Este é o país que você escolheu. Faça a economia dele crescer e transforme-o em uma potência!",
		"destacar": ["pais_nome"],
	},
	{
		"texto": "O cifrão mostra seu capital: o dinheiro que você tem para gastar (B = bilhões, T = trilhões).\nO bonequinho mostra o IDH, que mede a qualidade de vida do país.",
		"destacar": ["IdhePib"],
	},
	{
		"texto": "Este é o calendário. Cada turno do jogo vale um ano.",
		"destacar": ["ano", "mes", "dia"],
	},
	{
		"texto": "O botão CONFLITAR passa o ano. Clique nele para jogar seu primeiro turno.",
		"clicar": "conflitar",
	},
	{
		"texto": "Passou um ano! Este pergaminho mostra as estatísticas do seu país e é atualizado a cada turno.",
		"destacar": ["PergaminhoDadosPais"],
		"caixa": "direita",
	},
	{
		"texto": "Atenção: o tempo da partida é real e não para, nem com os menus abertos.\nE a cada 5 anos o jogo confere se o seu PIB cresceu pelo menos 10%. Se não cresceu, o mundo acaba!",
	},
	{
		"texto": "Clique em DEMANDAS. É ali que você compra e vende matéria-prima.",
		"clicar": "BotaoLateraldemandas/botao_lateral_demandas",
	},
	{
		"texto": "Clique em COMPRAR para ver o que os outros países estão vendendo.",
		"clicar": "titulo_compra/botao_comprar",
	},
	{
		"texto": "Cada linha é uma oferta: país, quantidade e preço. Clicar numa oferta compra a matéria-prima.\nComprar gasta capital, mas faz o país vendedor te respeitar mais.",
		"caixa": "direita",
	},
	{
		"texto": "Clique em VOLTAR para fechar o painel de compra.",
		"clicar": "BotaoVoltarComCorrente",
	},
	{
		"texto": "Agora clique em VENDER.",
		"clicar": "titulo_venda/botao_vender",
	},
	{
		"texto": "Aqui estão os países que querem comprar. Para vender você precisa ter a matéria-prima pedida.\nVender aumenta seu capital E seu PIB: é o jeito de fazer a economia crescer!",
		"caixa": "esquerda",
	},
	{
		"texto": "Clique em VOLTAR para fechar o painel de venda.",
		"clicar": "BotaoVoltarComCorrente",
	},
	{
		"texto": "Clique em VOLTAR de novo para fechar o menu de demandas.",
		"clicar": "BotaoVoltarComCorrente",
	},
	{
		"texto": "O menu AÇÕES reúne as decisões de governo. Clique nele.",
		"clicar": "BotaoLateralMenuacoes/Button",
	},
	{
		"texto": "Clique em INVESTIR.",
		"clicar": "BotaoLateralMenuacoes/PergaminhoDadosPais/Sprite2D2/Button",
	},
	{
		"texto": "Aqui aparecem a saúde, a segurança e a educação do seu país. Investir nesses setores custa capital, mas desenvolve o país e melhora o IDH.",
		"destacar": [
			"PergaminhoDadosPais4_investbb/Label",
			"PergaminhoDadosPais4_investbb/Label2",
			"PergaminhoDadosPais4_investbb/Label3",
			"PergaminhoDadosPais4_investbb/Label5",
			"PergaminhoDadosPais4_investbb/Label6",
			"PergaminhoDadosPais4_investbb/Label7",
		],
	},
	{
		"texto": "Este é o botão SANCIONAR, usado para pressionar economicamente outro país.",
		"destacar": ["BotaoLateralMenuacoes/PergaminhoDadosPais/Sprite2D/Button_sancionarraaa"],
	},
	{
		"texto": "Clique em VOLTAR para fechar o investimento.",
		"clicar": "BotaoVoltarComCorrente",
	},
	{
		"texto": "Clique em VOLTAR mais uma vez para fechar o menu de ações.",
		"clicar": "BotaoVoltarComCorrente",
	},
	{
		"texto": "Por último, clique em MAPA.",
		"clicar": "BotaoLateralMenu/botao_lateral_mapa",
	},
	{
		"texto": "Os alfinetes mostram o quanto cada país te respeita:\nvermelho = pouco, amarelo = neutro, verde = muito.",
	},
	{
		"texto": "Clique no X para fechar o mapa.",
		"clicar": "MapaMundi/X/Button",
	},
	{
		"texto": "Na aba NOTÍCIAS você acompanha o que acontece no mundo: crises, preços das commodities, acordos e sanções. Use as notícias para achar oportunidades e evitar ameaças.",
		"destacar": ["Label2"],
	},
	{
		"texto": "Pronto! Quando o tempo acabar, seu governo será avaliado pelo crescimento econômico, pelos investimentos e pelas relações internacionais.\nAs regras completas estão no TUTORIAL do menu inicial. Boa sorte!",
	},
]

const MARGEM_CAIXA = 16  

@onready var destaque = $Destaque
@onready var caixa = $CaixaDica
@onready var texto = $CaixaDica/Margem/Coluna/Texto
@onready var contador = $CaixaDica/Margem/Coluna/Botoes/Contador
@onready var botao_proximo = $CaixaDica/Margem/Coluna/Botoes/Proximo
@onready var botao_pular = $CaixaDica/Margem/Coluna/Botoes/Pular

var mundo   
var passo_atual = -1
var nos_destacados = []  
var botao_esperado: BaseButton = null  


func _ready() -> void:
	mundo = get_parent()
	botao_proximo.pressed.connect(avancar)
	botao_pular.pressed.connect(encerrar)
	avancar()  


func _process(_delta: float) -> void:
	if passo_atual >= PASSOS.size():
		return 

	
	destaque.mostrar_buraco(calcular_area(nos_destacados))
	posicionar_caixa()




func avancar() -> void:
	passo_atual += 1
	if passo_atual >= PASSOS.size():
		encerrar()
		return
	mostrar_passo(PASSOS[passo_atual])


func mostrar_passo(passo: Dictionary) -> void:
	texto.text = passo["texto"]
	contador.text = str(passo_atual + 1) + "/" + str(PASSOS.size())
	caixa.reset_size()  
	nos_destacados = []
	for caminho in passo.get("destacar", []):
		nos_destacados.append(mundo.get_node(caminho))

	if passo.has("clicar"):
		
		var botao = mundo.get_node(passo["clicar"])
		if nos_destacados.is_empty():
			nos_destacados.append(botao)
		esperar_clique(botao)
		botao_proximo.visible = false
		destaque.bloquear_cliques = true
		destaque.liberar_buraco = true

	elif passo.get("esperar") == "pais":

		mundo.pais_escolhido.connect(_ao_avancar_pelo_jogo, CONNECT_ONE_SHOT)
		botao_proximo.visible = false
		destaque.bloquear_cliques = false
		destaque.liberar_buraco = false

	else:
		botao_proximo.visible = true
		destaque.bloquear_cliques = true
		destaque.liberar_buraco = false

		if passo_atual == PASSOS.size() - 1:
			botao_proximo.text = "Jogar!"


func esperar_clique(botao: BaseButton) -> void:
	botao_esperado = botao
	botao.pressed.connect(_ao_clicar_botao_esperado)


func _ao_clicar_botao_esperado() -> void:
	botao_esperado.pressed.disconnect(_ao_clicar_botao_esperado)
	botao_esperado = null
	_ao_avancar_pelo_jogo()


func _ao_avancar_pelo_jogo() -> void:

	avancar.call_deferred()


func encerrar() -> void:
	if botao_esperado != null:
		botao_esperado.pressed.disconnect(_ao_clicar_botao_esperado)
	queue_free()  



func calcular_area(nos: Array) -> Rect2:
	var area = Rect2()
	for no in nos:
		if not no.is_visible_in_tree():
			continue
		var retangulo = retangulo_na_tela(no)
		if area.has_area():
			area = area.merge(retangulo)
		else:
			area = retangulo
	return area



func retangulo_na_tela(no) -> Rect2:
	var retangulo_local = Rect2()
	if no is Control:
		retangulo_local = Rect2(Vector2.ZERO, no.size)
	elif no is Sprite2D:
		retangulo_local = no.get_rect()

	return no.get_global_transform_with_canvas() * retangulo_local



func posicionar_caixa() -> void:
	var tela = get_viewport().get_visible_rect().size
	var area = destaque.buraco
	var lugar = PASSOS[passo_atual].get("caixa", "")

	var colocar_embaixo = true
	if area.has_area() and area.get_center().y > tela.y / 2:
		colocar_embaixo = false
	if lugar == "cima":
		colocar_embaixo = false

	if colocar_embaixo:
		caixa.position.y = tela.y - caixa.size.y - MARGEM_CAIXA
	else:
		caixa.position.y = MARGEM_CAIXA

	var x = (tela.x - caixa.size.x) / 2
	if area.has_area():
		x = area.get_center().x - caixa.size.x / 2
	if lugar == "esquerda":
		x = 0
	elif lugar == "direita":
		x = tela.x


	caixa.position.x = clamp(x, MARGEM_CAIXA, tela.x - caixa.size.x - MARGEM_CAIXA)
