extends Control
@onready var text = $Background/Text
@onready var box = $"."
func talk(dialogue):
	box.show()
	text.text = dialogue
func close():
	box.hide()
