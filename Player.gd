extends KinematicBody2D

var tile_size = 64
var can_move = true

var facing = 'ui_down'

var moves = {'ui_right' : Vector2(1,0),
			'ui_left' : Vector2(-1,0),
			'ui_up' : Vector2(0,-1),
			'ui_down' : Vector2(0,1)}
			
var raycasts = {'ui_right' : 'RayCastRight',
			'ui_left' : 'RayCastLeft',
			'ui_up' : 'RayCastUp',
			'ui_down' : 'RayCastDown'}
			

signal hit(pos,dir)

func _ready():
	pass
			
func move(dir):
	facing = dir
	if get_node(raycasts[facing]).is_colliding():
		var pos= position + moves[facing] * tile_size
		emit_signal("hit", pos, moves[facing])
		return
		
	can_move = false
	$AnimationPlayer.play(facing)
	$MoveTween.interpolate_property(self, "position", position, 
									position + moves[facing] * tile_size,
									0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT) 
	$MoveTween.start()

	return true

func _on_MoveTween_tween_completed(object, key):
	can_move = true

func _process(delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir) :
				move(dir) 


#func _process(delta):
#	if can_move:
#		for dir in moves.keys():
#			if Input.is_action_pressed(dir) :
#				if grid.is_cell_vacant(position , moves[dir]) :
#					if move(dir) :
#						grid.update_child_pos(position,
#											 moves[dir], grid.PLAYER)