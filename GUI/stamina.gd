extends ColorRect

@onready var value = $Value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
#	we could put health_updated.connect(health_bar.update_health_ui), and for stamina;
#	i think the tutorial saying we should doesn't know about connecting signals in Godot 4.4.
#	... their method allows for complex dynamic connections, eg if "hit" should only
#	apply in combat;
#	or to centralise connection logic and improve maintainability.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_stamina_updated(s, ms) -> void:
	value.size.x = 98*s/ms
