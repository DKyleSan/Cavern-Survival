extends Node

var wave : int
var difficulty : float
const DIFF_MULTIPLIER : float = 2
var max_enemies : int
var lives : int

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$"Game Over"/Button.pressed.connect(new_game)

func new_game():
	wave = 1
	lives = 3
	difficulty = 10
	$EnemySpawner/Timer.wait_time = 1.0
	reset()

func reset():
	max_enemies = int(difficulty)
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("items", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	$HUD/LivesLabel.text = "X " + str(lives)
	$HUD/WaveLabel.text = "WAVE: " + str(wave)
	$HUD/EnemiesLabel.text = "X " + str(max_enemies)
	$"Game Over".hide()
	get_tree().paused = true
	$RestartTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_wave_completed():
		wave += 1
		#adjust difficulty
		difficulty += DIFF_MULTIPLIER
		if $EnemySpawner/Timer.wait_time > 0.25:
			$EnemySpawner/Timer.wait_time -= 0.05
		get_tree().paused = true
		$WaveOverTimer.start()

func _on_enemy_spawner_hit_p():
	lives -= 1
	$HUD/LivesLabel.text = "X " + str(lives)
	get_tree().paused = true
	if lives <= 0:
		$"Game Over"/WavesSurvivedLabel.text = "Waves Survived: " + str(wave - 1)
		$"Game Over".show()
	else:
		$WaveOverTimer.start()

func _on_restart_timer_timeout():
	get_tree().paused = false

func _on_wave_over_timer_timeout():
	reset()

func is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("enemies")
	#Check if all enemies have spawned
	if enemies.size() == max_enemies:
		for e in enemies:
			if e.alive:
				all_dead = false
		return all_dead
	else:
		return false
