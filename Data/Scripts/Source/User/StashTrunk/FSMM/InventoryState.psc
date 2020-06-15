Scriptname StashTrunk:FSMM:InventoryState extends Quest Conditional

InjectTec:Plugin Property StashTrunk_FSMM Auto Const Mandatory

Int iArmorKitID = 0x00001739 Const
Int iChemsKitID = 0x0000173A Const
Int iCookingKitID = 0x0000173B Const
Int iScrapKitID = 0x00001EE8 Const
Int iWeaponKitID = 0x0000173C Const

MiscObject armorKitForm = None
MiscObject chemsKitForm = None
MiscObject cookingKitForm = None
MiscObject scrapKitForm = None
MiscObject weaponKitForm = None

Bool bHasArmorKit = false Conditional
Bool bHasChemsKit = false Conditional
Bool bHasCookingKit = false Conditional
Bool bHasScrapKit = false Conditional
Bool bHasWeaponKit = false Conditional

Function refreshForms()

EndFunction

Function refreshState()

EndFunction

Auto State Dormant
	Event OnBeginState(String asOldState)
		armorKitForm = None
		chemsKitForm = None
		cookingKitForm = None
		scrapKitForm = None
		weaponKitForm = None
		
		bHasArmorKit = false
		bHasChemsKit = false
		bHasCookingKit = false
		bHasScrapKit = false
		bHasWeaponKit = false
	EndEvent
	
	Event OnQuestInit()
		GoToState("Active")
	EndEvent
EndState

State Active
	Event OnBeginState(String asOldState)
		refreshForms()
	EndEvent
	
	Function refreshForms()
		armorKitForm = StashTrunk_FSMM.lookupInt(iArmorKitID) as MiscObject
		chemsKitForm = StashTrunk_FSMM.lookupInt(iChemsKitID) as MiscObject
		cookingKitForm = StashTrunk_FSMM.lookupInt(iCookingKitID) as MiscObject
		scrapKitForm = StashTrunk_FSMM.lookupInt(iScrapKitID) as MiscObject
		weaponKitForm = StashTrunk_FSMM.lookupInt(iWeaponKitID) as MiscObject
	EndFunction
	
	Function refreshState()
		Actor player = Game.GetPlayer()
		bHasArmorKit = player.GetItemCount(armorKitForm) as Bool
		bHasChemsKit = player.GetItemCount(chemsKitForm) as Bool
		bHasCookingKit = player.GetItemCount(cookingKitForm) as Bool
		bHasScrapKit = player.GetItemCount(scrapKitForm) as Bool
		bHasWeaponKit = player.GetItemCount(weaponKitForm) as Bool
	EndFunction
	
	Event OnQuestShutdown()
		GoToState("Dormant")
	EndEvent
EndState
