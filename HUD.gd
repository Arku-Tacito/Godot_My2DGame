extends CanvasLayer

signal start_game
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# 显示文字接口
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# 游戏结束
func show_game_over():
	show_message("Game Over!")
	yield($MessageTimer, "timeout")
	
	$Message.text = "My 2D Game"
	$Message.show()
	
	# 临时创建计时器, 类似sleep
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

# 更新分数到屏幕显示
func update_score(score):
	$ScoreLabel.text = str(score)

# 开始游戏按钮
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

# 屏幕显示时间
func _on_MessageTimer_timeout():
	$Message.hide()
