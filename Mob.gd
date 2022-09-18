extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# 随机选取一个状态的动画播放
	$AnimatedSprite.playing = true
	var anims_name = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = anims_name[randi() % anims_name.size()]
	
# 超出屏幕前删除自己
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
