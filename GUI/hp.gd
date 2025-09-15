extends ColorRect

@onready var value = $Value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_health_updated(hp, max_hp) -> void:
	value.size.x = 98*hp/max_hp
