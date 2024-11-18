extends Node2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text  = "health: %.2f\nspeed: %f\nx vel: %f\n" % [$Player.health, $Player.accel, $Player.velocity.x]
	$Label.text += "x skid: %s" % [$Player.x_skid]
