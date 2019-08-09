extends CanvasLayer

signal restart_level
signal next_level

func _ready():
	toggle_button()
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	toggle_button()
	$MessageTimer.start()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_RestartButton_pressed():
	toggle_button()
	emit_signal("restart_level")


func _on_NextButton_pressed():
	toggle_button()
	emit_signal("next_level")
	
func toggle_button() :
	$RestartButton.visible = not $RestartButton.visible
	$NextButton.visible = not $NextButton.visible
