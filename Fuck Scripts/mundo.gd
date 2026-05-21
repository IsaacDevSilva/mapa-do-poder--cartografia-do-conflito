extends Node2D
var botao
var vbox
var pais

func _ready() -> void:
	for vbox in $escolha.get_children():
		if vbox is VBoxContainer:
			for botao in vbox.get_children():
				if botao is Button:
					botao.pressed.connect(_botao_clicado.bind(botao))
	

func _process(delta: float) -> void:
	print(paises.paises["RUSSIA"]["pib"])
func _botao_clicado(botao):
	pais = botao.name
	$escolha.visible = false
	print(botao)
	print(pais)
