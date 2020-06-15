Scriptname StashTrunk:FSMM:Workbench:PowerArmor extends StashTrunk:FSMM:Workbench

MiscObject Property StashTrunk_FSMM_InventoryItem_PA Auto Const Mandatory
{Autofill}
Spawny:Modifier Property StashTrunk_FSMM_Workbench_PowerArmor_Modification Auto Const Mandatory
{Autofill}
Sound Property UIModsComponentsMetalLight Auto Const Mandatory
{Autofill}
Sound Property UIWorkshopModeItemPickUpGeneric Auto Const Mandatory
{Autofill}

Function pickUp()
	BlockActivation(true, true)
	UIModsComponentsMetalLight.Play(self)
	UIWorkshopModeItemPickUpGeneric.Play(self)
	Disable(false)
	Game.GetPlayer().AddItem(StashTrunk_FSMM_InventoryItem_PA, 1, false)
	Delete()
EndFunction

Event OnInit()
	parent.OnInit()
	MoveTo(Game.GetPlayer(), 0, 0, 0, true)
	SetAngle(0, 0, Game.GetPlayer().GetAngleZ())
	StashTrunk_FSMM_Workbench_PowerArmor_Modification && StashTrunk_FSMM_Workbench_PowerArmor_Modification.apply(self)
	UIWorkshopModeItemPickUpGeneric.Play(self)
	UIModsComponentsMetalLight.Play(self)
EndEvent
