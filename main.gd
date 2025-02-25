extends Node
@export var mob_scene: PackedScene
var score 

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)  # Update score display when score changes


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout() -> void:
	spawn_mob()


func spawn_mob() -> void:
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150, 250), 0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
