extends Node
class_name SoundController

@export var master_volume_db: float = -14.0
@export var music_volume_db: float = -14.0
@export var sfx_volume_db: float = -14.0
const LOWER_IMPORTANT_VOLUME_DB: float = -25.0

func _ready() -> void:
	if Game.sound_controller and Game.sound_controller != self:
		master_volume_db = Game.sound_controller.master_volume_db
		music_volume_db = Game.sound_controller.music_volume_db
		sfx_volume_db = Game.sound_controller.sfx_volume_db
	else:
		master_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
		music_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
		sfx_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	Game.sound_controller = self
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_db)

func set_volume(factor: float,bus_name="Master") -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), factor)
	if bus_name == "Master":
		master_volume_db = factor
	elif bus_name == "Music":
		music_volume_db = factor
	elif bus_name == "SFX":
		sfx_volume_db = factor

func lower_music_to_hear() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), LOWER_IMPORTANT_VOLUME_DB)

func play_important(sound: AudioStreamPlayer2D) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), LOWER_IMPORTANT_VOLUME_DB)
	sound.play()
	await sound.finished
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)

func play(sound: AudioStreamPlayer2D) -> void:
	sound.play()
	await sound.finished
