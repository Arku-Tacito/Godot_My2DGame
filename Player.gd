extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 200	# export, 在inspector可以设置
var screen_size	# 屏幕大小
signal hit	# 获取碰撞信号

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()	# 先隐藏
	screen_size = get_viewport_rect().size	# 获取屏幕大小

# 游戏开始时的玩家初始状态
func start(pos):
	position = pos
	show()	# 显示玩家
	$CollisionShape2D.disabled = false	# 启用碰撞体
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	# 判断是否要移动, 播放对应动画
	if velocity.length() > 0:	# 向量长度大于0, 移动
		velocity = velocity.normalized() * speed	# 要做归一化, 避免斜向移动过快
		$AnimatedSprite.play()	# $ 与 get_node 相同
	else:
		$AnimatedSprite.stop()
	# 通过翻转动画表示四个方向
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"	# 播放walk的动画
		$AnimatedSprite.flip_v = false	# 可选, 左右移动时保持向上姿势, 关掉垂直翻转
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"	# 模仿up的动画
		$AnimatedSprite.flip_v = velocity.y > 0
	
	# 移动角色
	position += velocity * delta
	# 修正, 确保不会走出屏幕
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# 碰撞信号
func _on_Player_body_entered(body):
	hide()	# 隐藏角色
	emit_signal("hit")	# 给hit发信号
	# 禁用碰撞检测, 避免反复
	$CollisionShape2D.set_deferred("disabled", true)	# set_deferred 安全地设置碰撞
