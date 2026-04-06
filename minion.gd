extends CharacterBody2D

@export var speed: float = 80.0
var vida: int = 2
var game_over_activo: bool = false  # ← agregar esta línea

func _ready() -> void:
    scale = Vector2(0.5, 0.5)
    add_to_group("enemigos")  # ← agregar al grupo
    
func _physics_process(_delta: float) -> void:
    if game_over_activo:
        return
    var jugador = get_node("../jugador")
    if not jugador:
        return
    var direccion = (jugador.global_position - global_position).normalized()
    velocity = direccion * speed
    move_and_slide()

    for i in get_slide_collision_count():
        var colision = get_slide_collision(i)
        if colision.get_collider().name == "jugador":
            game_over()

func recibir_danio() -> void:
    vida -= 1
    modulate = Color(1, 0, 0)
    await get_tree().create_timer(0.1).timeout
    modulate = Color(1, 1, 1)
    if vida <= 0:
        queue_free()

func game_over():
    if game_over_activo:
        return
    game_over_activo = true
    var jugador = get_node("../jugador")
    for i in 5:
        jugador.visible = false
        await get_tree().create_timer(0.1).timeout
        jugador.visible = true
        await get_tree().create_timer(0.1).timeout
    get_tree().call_deferred("change_scene_to_file", "res://gameover.tscn")