extends CSGBox3D

var toggle = true
var interactable = true

@onready var truffle: CSGBox3D = $"." 
@onready var sound_player: AudioStreamPlayer3D = $TrufflePickUp 

func interact():
	if interactable:
		truffle.visible = false  
		sound_player.play()  
		await get_tree().create_timer(1.0).timeout  
		truffle.queue_free() 
