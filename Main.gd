extends Node
export(PackedScene) var mob_scene
var score


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()	# 每次开始, 生成不同随机数
	# game_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 信号接收, 游戏结束
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$StartTimer.stop()
	$BGM.stop()
	$Death.play()
	# HUD处理
	score = 0
	$HUD.show_game_over()

# 信号接收, 游戏开始
func game_start():
	# 初始化
	score = 0
	$Player.start($StartPosition.position)
	$BGM.play()
	# HUD处理
	$HUD.update_score(score)
	$HUD.show_message("Ready!")
	# 通过groups删除上局的旧怪
	get_tree().call_group("mobs", "queue_free")
	# 计时器等处理
	$StartTimer.start()

# 分数计数的信号
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
# 游戏开始的信号
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# 怪物生成的信号
func _on_MobTimer_timeout():
	# 生成怪物单例
	var mob = mob_scene.instance()	# 实例一个怪物
	# 获取位置
	var mob_location = get_node("MobPath/MobSpawnLocation")	# 获取生成的随机起始位置
	mob_location.offset = randi()
	mob.position = mob_location.position
	# 获取方向
	var direction = mob_location.rotation + PI / 2	
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	# 获取速度
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
