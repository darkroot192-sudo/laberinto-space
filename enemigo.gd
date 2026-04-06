extends CharacterBody2D

@export var speed: float = 60.0
@export var vida: int = 5  # Número de hits antes de morir

var game_over_activo: bool = false

func _ready() -> void:
    pass

func _physics_process(_delta: float) -> void:
    if game_over_activo:
        return
    var jugador = get_node("../jugador")
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
        # Primero elimina todos los minions
        for minion in get_tree().get_nodes_in_group("enemigos"):
            minion.queue_free()
        # Luego cambia a escena de ganaste
        queue_free()
        get_tree().call_deferred("change_scene_to_file", "res://ganaste.tscn")
    else:
        spawnear_minion()
func spawnear_minion() -> void:
    var minion = load("res://minion.tscn").instantiate()
    minion.global_position = global_position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
    get_parent().add_child(minion)

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