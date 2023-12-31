extends Node

signal done
signal next
var messageStatus = false
@onready var currentTrack = get_node("/root/Game/Music").stream
var NPC

func go(npc):
	currentTrack = get_node("/root/Game/Music").stream
	NPC = npc
	messageStatus = true
	npc.talking = true
	get_node("/root/Game/UI/TextBox/Text").visible_ratio = 0
	await get_node("/root/Game/UI/TextBox").appear(.2)
	var tree = npc.dialogueTrees[npc.dialogueTreeKey]
	for i in tree.size():
		if checkForCommands(tree[i],npc):
			continue
		get_node("/root/Game/UI/TextBox/Text").text = tree[i]
		get_node("/root/Game/UI/TextBox/Text").visible_ratio = 0
		await get_tree().create_timer(.02).timeout
		while get_node("/root/Game/UI/TextBox/Text").visible_ratio<1:
			get_node("/root/Game/UI/TextBox/Text").visible_ratio += 0.05
			await get_tree().create_timer(.01).timeout
		await next
	await get_node("/root/Game/UI/TextBox").disappear(.2)
	npc.talking = false
	messageStatus = false
	if get_node("/root/Game/Music").stream != currentTrack:
		get_node("/root/Game/Music").stream = currentTrack
		get_node("/root/Game/Music").play()
	
func checkForCommands(line,npc):
	if line.substr(0,5)=="/song":
		var songName = line.substr(6,-1)
		get_node("/root/Game/Music").stream = load(songName)
		get_node("/root/Game/Music").seek(0)
		get_node("/root/Game/Music").play()
		return true
	elif line.substr(0,5)=="/cuts":
		var cutscene = line.substr(6,-1)
		get_node("/root/Game/Cutscenes").play(cutscene)
		return true
	elif line.substr(0,5)=="/gold":
		var amount = int(line.substr(6,-1))
		#give player 200 gold
		return true
	elif line.substr(0,5)=="/tree":
		var index = int(line.substr(6,-1))
		npc.dialogueTreeKey = index
		return true
	return false
	
func _ready():
	awaitDone()
	

func awaitDone():
	await done
	await get_node("/root/Game/UI/TextBox").disappear(.2)
	messageStatus = false
	if NPC:
		NPC.talking = false
	if get_node("/root/Game/Music").stream != currentTrack:
		get_node("/root/Game/Music").stream = currentTrack
		get_node("/root/Game/Music").play()
	awaitDone()
