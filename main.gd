extends Node

@export var mob_scene: PackedScene
var score

func new_game():
	$Music.play()
	
	get_tree().call_group("mobs", "queue_free")
	
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150, 250), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	
	$HUD.update_score(score)


func _on_starter_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
