extends Node
var paises = {

"ESTADOS UNIDOS":{
"pib":30.0,
"populacao":341,
"militar":100,
"honra":720,
"tecnologia":100,
"comodits":65,
"armazenamento_max":2000,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,


"saude":78,
"educacao":86,
"seguranca":70,

"idh":0.78
},

"CHINA":{
"pib":20.0,
"populacao":1410,
"militar":95,
"honra":500,
"tecnologia":92,
"comodits":88,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,

"saude":76,
"educacao":82,
"seguranca":72,

"idh":0.77
},

"REINO UNIDO":{
"pib":4.2,
"populacao":68,
"militar":78,
"honra":860,
"tecnologia":94,
"comodits":35,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,

"saude":90,
"educacao":89,
"seguranca":84,

"idh":0.88
},

"ALEMANHA":{
"pib":5.5,
"populacao":84,
"militar":72,
"honra":900,
"tecnologia":96,
"comodits":40,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":93,
"educacao":91,
"seguranca":88,

"idh":0.91
},

"FRANCA":{
"pib":3.6,
"populacao":65,
#linha six seven favor não mexer
"militar":82,
"honra":840,
"tecnologia":90,
"comodits":45,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":92,
"educacao":87,
"seguranca":80,

"idh":0.86
},

"JAPAO":{
"pib":4.4,
"populacao":124,
"militar":62,
"honra":920,
"tecnologia":99,
"comodits":20,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":97,
"educacao":95,
"seguranca":93,

"idh":0.95
},

"INDIA":{
"pib":4.1,
"populacao":1430,
"militar":88,
"honra":580,
"tecnologia":78,
"comodits":82,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":63,
"educacao":68,
"seguranca":60,

"idh":0.64
},

"RUSSIA":{
"pib":2.6,
"populacao":144,
"militar":94,
"honra":380,
"tecnologia":80,
"comodits":100,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":68,
"educacao":84,
"seguranca":58,

"idh":0.70
},
#Japão → rei do IDH/tecnologia, poucos commodities, militar moderado.
#EUA → build de potência total: militar + tech absurdos, mas saúde/segurança reduzem IDH.
#China → quase rival direta dos EUA, população gigantesca.
#Alemanha → país “econômico/qualidade de vida”.
#Rússia → militar + recursos naturais quebrados, honra menor.
#Índia → população monstruosa, crescimento forte, IDH mais baixo.
#França/Reino Unido → equilibrados premium.
"BRASIL":{
"pib":3.3,
"populacao":212,
"militar":70,
"honra":650,
"tecnologia":68,
"comodits":97,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":72,
"educacao":68,
"seguranca":38,

"idh":0.59
},

"MEXICO":{
"pib":2.1,
"populacao":129,
"militar":58,
"honra":620,
"tecnologia":60,
"comodits":75,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":70,
"educacao":67,
"seguranca":45,

"idh":0.61
},

"AFRICA DO SUL":{
"pib":0.5,
"populacao":63,
"militar":55,
"honra":560,
"tecnologia":52,
"comodits":93,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":58,
"educacao":61,
"seguranca":28,

"idh":0.49
},

"ARABIA SAUDITA":{
"pib":1.4,
"populacao":38,
"militar":82,
"honra":540,
"tecnologia":75,
"comodits":98,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":78,
"educacao":72,
"seguranca":82,

"idh":0.77
},

"ARGENTINA":{
"pib":0.7,
"populacao":46,
"militar":48,
"honra":570,
"tecnologia":58,
"comodits":84,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":78,
"educacao":79,
"seguranca":52,

"idh":0.70
},

"AUSTRALIA":{
"pib":2.1,
"populacao":27,
"militar":74,
"honra":910,
"tecnologia":86,
"comodits":92,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":95,
"educacao":92,
"seguranca":90,

"idh":0.92
},

"TURQUIA":{
"pib":1.6,
"populacao":86,
"militar":80,
"honra":520,
"tecnologia":70,
"comodits":58,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":74,
"educacao":71,
"seguranca":58,

"idh":0.67
},

"INDONESIA":{
"pib":1.5,
"populacao":281,
"militar":72,
"honra":600,
"tecnologia":63,
"comodits":90,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":68,
"educacao":66,
"seguranca":55,

"idh":0.63
},
#Austrália ficou absurdamente forte (quase verde premium escondido kkk), porque na vida real ela é bem poderosa em IDH + commodities + estabilidade.
#Brasil = build de recursos naturais monstruosos, mas segurança pesa muito.
#Arábia Saudita = petróleo quebrado + militar forte + segurança alta.
#Argentina = educação/saúde boas, economia mais fraca.
#Indonésia = população gigante + recursos altos.
#Turquia = militar forte e posição geopolítica forte.
#África do Sul = commodities muito altas, segurança derrubando bastante.
#México = equilíbrio geral intermediário.
"HAITI":{
"pib":0.025,
"populacao":12,
"militar":12,
"honra":140,
"tecnologia":10,
"comodits":28,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":28,
"educacao":32,
"seguranca":12,

"idh":0.24
},

"AFEGANISTAO":{
"pib":0.02,
"populacao":42,
"militar":42,
"honra":90,
"tecnologia":15,
"comodits":70,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":24,
"educacao":20,
"seguranca":8,

"idh":0.17
},

"SIRIA":{
"pib":0.02,
"populacao":24,
"militar":48,
"honra":100,
"tecnologia":25,
"comodits":50,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":30,
"educacao":45,
"seguranca":10,

"idh":0.28
},

"VENEZUELA":{
"pib":0.11,
"populacao":28,
"militar":52,
"honra":120,
"tecnologia":35,
"comodits":96,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":52,
"educacao":68,
"seguranca":18,

"idh":0.46
},

"CONGO":{
"pib":0.07,
"populacao":111,
"militar":32,
"honra":180,
"tecnologia":18,
"comodits":95,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":22,
"educacao":28,
"seguranca":15,

"idh":0.22
},

"CUBA":{
"pib":0.11,
"populacao":11,
"militar":45,
"honra":350,
"tecnologia":52,
"comodits":35,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":82,
"educacao":84,
"seguranca":60,

"idh":0.75
},

"PAQUISTAO":{
"pib":0.40 ,
"populacao":241,
"militar":86,
"honra":250,
"tecnologia":40,
"comodits":60,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":50,
"educacao":46,
"seguranca":35,

"idh":0.44
},

"COREIA DO NORTE":{
"pib":0.26,
"populacao":26,
"militar":90,
"honra":80,
"tecnologia":45,
"comodits":42,
"materia_prima":1500,
"taxa_imposto": 5,
"status_povo" : 90,
"saude":58,
"educacao":72,
"seguranca":40,

"idh":0.57
}
#Congo → quase sem infraestrutura, mas commodities absurdas. Pode virar monstro late-game.
#Venezuela → petróleo quebrado (comodits 96), mas economia e segurança afundadas.
#Coreia do Norte → build meme: militar absurdo, honra mínima.
#Paquistão → militar forte, população gigante, desenvolvimento complicado.
#Cuba → caso curioso: saúde/educação altas, economia pequena.
#Afeganistão/Haiti → modo sofrimento máximo kkkkk.
}


func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	pass
