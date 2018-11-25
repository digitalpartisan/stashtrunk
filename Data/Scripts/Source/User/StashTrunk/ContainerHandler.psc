Scriptname StashTrunk:ContainerHandler extends Quest

ReferenceAlias Property ContainerAlias Auto Const Mandatory
ActorValue Property CarryWeight Auto Const Mandatory

Function updateCarryWeight()
	getUnderlyingContainer().SetValue(CarryWeight, Game.GetPlayer().GetValue(CarryWeight))
EndFunction

Event OnQuestInit()
	updateCarryWeight()
EndEvent

Function open()
	getUnderlyingContainer().OpenInventory(true)
EndFunction

Actor Function getUnderlyingContainer()
	return ContainerAlias.GetActorRef()
EndFunction
