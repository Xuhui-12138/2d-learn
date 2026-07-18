extends Node
@export var mob_scene:PackedScene
const BASE_SPEED_MIN := 150.0
const BASE_SPEED_MAX := 250.0
const SPEED_INCREASE_PER_LEVEL := 20.0

var score = 0
var level = 0

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LevelTimer.stop()
	$Hud.show_game_over()
	$Bgm.stop()
	$DeathSound.play()

func new_game():
	score = 0
	level = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Hud.update_score(score)
	$Hud.update_level(level)
	$Hud.show_message("做好准备！")
	get_tree().call_group("mobs", "queue_free")
	$Bgm.play()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var speed_bonus = level * SPEED_INCREASE_PER_LEVEL
	var velocity = Vector2(
		randf_range(BASE_SPEED_MIN + speed_bonus, BASE_SPEED_MAX + speed_bonus),
		0.0
	)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$Hud.update_score(score)

func _on_level_timer_timeout() -> void:
	level += 1
	$Hud.update_level(level)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$LevelTimer.start()
