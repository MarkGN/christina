extends CharacterBody2D

signal health_updated
signal stamina_updated

@export var SPEED = 100
@export var SPRINT_MULTIPLIER = 2.5
@onready var animation_sprite = $AnimatedSprite2D
# the original tutorial doesn't use this, but the original tutorial looks ugly
var facing : Vector2 = Vector2.ZERO
var is_attacking = false

var max_health = 100
var health = max_health
var regen_health = 1
var max_stamina : float = 100
var stamina = max_stamina
var regen_stamina = 5
var stamina_cost = 100+regen_stamina

func _physics_process(delta: float) -> void:
	if is_attacking:
		return
	var direction : Vector2
	direction.x = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	# Apply movement
	var movement = SPEED * direction * delta
	if Input.is_action_pressed("ui_sprint") and stamina > stamina_cost*delta:
		stamina = stamina - stamina_cost*delta
		movement = movement * SPRINT_MULTIPLIER
#		really ought to emit signal here, but as it happens every frame, why bother
	# Moves our player around, whilst enforcing collisions so that they come to a stop when colliding with another object.
	move_and_collide(movement)
	
	if direction != Vector2.ZERO:
		facing = direction
	animations(direction)
	
func _process(delta: float) -> void:
	var updated_health = min(health + regen_health * delta, max_health)
	if updated_health != health:
		health = updated_health
		health_updated.emit(health, max_health)
	var updated_stamina = min(stamina + regen_stamina * delta, max_stamina)
	if updated_stamina != stamina:
		stamina = updated_stamina
		stamina_updated.emit(stamina, max_stamina)

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		var animation = "attack_" + returned_direction(facing)
		animation_sprite.play(animation)

func animations(direction : Vector2) -> void:
	var animation : String;
	if direction == Vector2.ZERO:
		animation = "idle_" + returned_direction(facing)
	else:
		animation = "walk_" + returned_direction(facing)
	animation_sprite.play(animation)

func returned_direction(direction : Vector2) -> String:
	var normalised_direction = direction.normalized()
	var default_return = "down"
	if normalised_direction.y > 0:
		return "down"
	elif normalised_direction.y < 0:
		return "up"
	elif normalised_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalised_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		return "side"
		
	return default_return

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false
