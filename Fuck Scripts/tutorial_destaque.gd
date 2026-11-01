extends Control


const COR_ESCURO = Color(0, 0, 0, 0.6)
const COR_BORDA = Color(1.0, 0.82, 0.25)
const ESPESSURA_BORDA = 3.0
const FOLGA = 6.0  
var buraco = Rect2()  
var bloquear_cliques = true
var liberar_buraco = false


func mostrar_buraco(area: Rect2) -> void:
	if area.has_area():
		
		buraco = area.grow(FOLGA).intersection(Rect2(Vector2.ZERO, size))
	else:
		buraco = Rect2()
	queue_redraw()  


func _draw() -> void:
	if not buraco.has_area():
		return


	var b = buraco
	draw_rect(Rect2(0, 0, size.x, b.position.y), COR_ESCURO)
	draw_rect(Rect2(0, b.end.y, size.x, size.y - b.end.y), COR_ESCURO)
	draw_rect(Rect2(0, b.position.y, b.position.x, b.size.y), COR_ESCURO)
	draw_rect(Rect2(b.end.x, b.position.y, size.x - b.end.x, b.size.y), COR_ESCURO)

	draw_rect(b, COR_BORDA, false, ESPESSURA_BORDA)



func _has_point(ponto: Vector2) -> bool:
	if not bloquear_cliques:
		return false
	if liberar_buraco and buraco.has_point(ponto):
		return false
	return true
