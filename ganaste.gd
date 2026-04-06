extends Control

@onready var label_titulo = $VBoxContainer/LabelTitulo
@onready var btn_reintentar = $VBoxContainer/BtnReintentar
@onready var btn_salir = $VBoxContainer/BtnSalir

var tiempo: float = 0.0

func _ready():
	label_titulo.text = "¡GANASTE! 🏆"
	label_titulo.add_theme_color_override("font_color", Color(1, 0.85, 0, 1))
	label_titulo.add_theme_font_size_override("font_size", 72)
	btn_reintentar.pressed.connect(_on_reintentar_pressed)
	btn_salir.pressed.connect(_on_salir_pressed)

func _process(delta: float) -> void:
	tiempo += delta
	
	# Efecto de rebote
	var escala = 1.0 + sin(tiempo * 3.0) * 0.1
	label_titulo.scale = Vector2(escala, escala)
	
	# Efecto de color pulsante entre dorado y blanco
	var t = (sin(tiempo * 4.0) + 1.0) / 2.0
	var color = Color(1, 0.85, 0, 1).lerp(Color(1, 1, 1, 1), t)
	label_titulo.add_theme_color_override("font_color", color)

func _on_reintentar_pressed() -> void:
	GameData.puntuacion = 0
	get_tree().change_scene_to_file("res://juego.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
