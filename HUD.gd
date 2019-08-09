extends CanvasLayer

signal restart_level
signal next_level

func _ready():
	toggle_button()
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_level_complete() :
	$MessageLabel.text = "Level Complete"
	toggle_HUD()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_RestartButton_pressed():
	toggle_HUD()
	emit_signal("restart_level")


func _on_NextButton_pressed():
	toggle_HUD()
	emit_signal("next_level")
	
func toggle_button() :
	$RestartButton.visible = not $RestartButton.visible
	$NextButton.visible = not $NextButton.visible

func toggle_HUD() :
	toggle_button()
	$MessageLabel.visible = not $MessageLabel.visible