extends CharacterBody2D


@export var SPEED = 100
@export var SPRINT = 250
@onready var animation_sprite = $AnimatedSprite2D
# the original tutorial doesn't use this, but the original tutorial looks ugly
var facing : Vector2 = Vector2.ZERO
var is_attacking = false

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
	if Input.is_action_pressed("ui_sprint"):
		movement = SPRINT * direction * delta
	# Moves our player around, whilst enforcing collisions so that they come to a stop when colliding with another object.
	move_and_collide(movement)
	
	if direction != Vector2.ZERO:
		facing = direction
	animations(direction)

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
