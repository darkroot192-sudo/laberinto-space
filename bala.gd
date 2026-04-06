extends Area2D
@onready var game_data = get_node("/root/GameData")

@export var speed: float = 400.0

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    await get_tree().create_timer(3.0).timeout
    queue_free()

func _process(delta: float) -> void:
    position += Vector2.UP.rotated(rotation) * speed * delta

func _on_body_entered(body: Node) -> void:
    if body.name == "enemigo":
        body.recibir_danio()
        GameData.puntuacion += 50
        queue_free()
    elif body.is_in_group("enemigos"):  # ← detecta todos los minions
        body.recibir_danio()
        GameData.puntuacion += 20
        queue_free()
    elif body is StaticBody2D:
        queue_free()