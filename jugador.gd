extends CharacterBody2D

@export var speed: float = 100.0
@export var nitro_speed: float = 250.0
@export var nitro_duracion: float = 0.3
@export var bala_escena: PackedScene

var nitro_activo: bool = false
var puede_disparar: bool = true

@onready var sonido_laser = $SonidoLaser
@onready var sonido_motor = $SonidoMotor
@onready var sonido_nitro = $SonidoNitro
@onready var sonido_fondo = $SonidoFondo

func _ready() -> void:
    # Inicia música de fondo
    sonido_fondo.play()
    # Motor en loop pero silencioso al inicio
    sonido_motor.volume_db = -80.0
    sonido_motor.play()

func _physics_process(_delta: float) -> void:
    var direction = Vector2.ZERO

    # Controles de teclado (PC)
    if Input.is_action_pressed("mover_izquierda"):
        direction.x = -1
    if Input.is_action_pressed("mover_derecha"):
        direction.x = 1
    if Input.is_action_pressed("mover_arriba"):
        direction.y = -1
    if Input.is_action_pressed("mover_abajo"):
        direction.y = 1

    # Joystick virtual (Android)
    var joystick = get_node_or_null("/root/juego/Controles/VirtualJoystick")
    if joystick and joystick.is_pressed:
        direction = joystick.output

    if direction != Vector2.ZERO:
        $Sprite2D.rotation = direction.angle() + PI/2
        lerpf(sonido_motor.volume_db, 0.0, 0.1)
    else:
        lerpf(sonido_motor.volume_db, -80.0, 0.1)

    var velocidad_actual = nitro_speed if nitro_activo else speed
    velocity = direction.normalized() * velocidad_actual
    move_and_slide()
func _process(_delta: float) -> void:
    var label = get_node("/root/juego/UI/LabelPuntuacion")
    label.text = "Puntuación: " + str(GameData.puntuacion)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("nitro") and not nitro_activo:
        activar_nitro()
    if event.is_action_pressed("disparar") and puede_disparar:
        disparar()
    # ← Disparo con toque en pantalla para Android
    if event is InputEventScreenTouch and event.pressed and puede_disparar:
        disparar()

func activar_nitro():
    nitro_activo = true
    sonido_nitro.play()
    $Sprite2D.modulate = Color(1, 1, 0)
    await get_tree().create_timer(nitro_duracion).timeout
    nitro_activo = false
    $Sprite2D.modulate = Color(1, 1, 1)

func disparar():
    if bala_escena == null:
        return
    puede_disparar = false
    sonido_laser.play()
    var bala = bala_escena.instantiate()
    bala.global_position = global_position
    bala.rotation = $Sprite2D.rotation
    get_parent().add_child(bala)
    await get_tree().create_timer(0.3).timeout
    puede_disparar = true

