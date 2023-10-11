extends CanvasLayer

var Censor : ProfanityCensor

func _ready():
	Censor = ProfanityCensor.new()

func _on_line_edit_text_changed(new_text):
	if Censor != null:
		if Censor.contains_profanity(new_text):
			var censored_text = Censor.censor(new_text)
			$LineEdit.text = censored_text
			$LineEdit.caret_column = $LineEdit.text.length()
