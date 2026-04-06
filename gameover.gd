extends Control

func _ready() -> void:
    $VBoxContainer/BtnReintentar.pressed.connect(_on_reintentar_pressed)
    $VBoxContainer/BtnSalir.pressed.connect(_on_salir_pressed)
    $VBoxContainer/LabelPuntuacion.text = "Puntuación: " + str(GameData.puntuacion)

func _on_reintentar_pressed() -> void:
    GameData.puntuacion = 0
    get_tree().change_scene_to_file("res://juego.tscn")

func _on_salir_pressed() -> void:
    get_tree().quit()