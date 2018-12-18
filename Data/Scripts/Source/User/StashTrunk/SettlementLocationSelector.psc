Scriptname StashTrunk:SettlementLocationSelector extends WorkshopNPCScript

Group KeywordSettings
	Keyword Property SelectionKeyword Auto Const Mandatory
	FormList Property RequiredKeywords = None Auto Const
	FormList Property ExcludedKeywords = None Auto Const
EndGroup

Group Toggles
	Bool Property RequireOwnership = true Auto Const
	Bool Property ExcludeZeroPopulation = false Auto Const
	Bool Property TurnOffHeader = false Auto Const
	Bool Property OnlyPotentialVassalSettlements = false Auto Const
	Bool Property DisableReservedByQuests = false Auto Const
EndGroup

Message Property ConfirmationMessage = None Auto Const

Event OnWorkshopNPCTransfer(Location akNewWorkshopLocation, Keyword akActionKW)
	if (SelectionKeyword == akActionKW)
		WorkshopParent.unassignActor(self, true)
	endif
EndEvent

Location Function selectLocation(Location akSelectLocation)
	return OpenWorkshopSettlementMenuEx(SelectionKeyword, ConfirmationMessage, akSelectLocation, RequiredKeywords, ExcludedKeywords, ExcludeZeroPopulation, RequireOwnership, TurnOffHeader, OnlyPotentialVassalSettlements, DisableReservedByQuests)
EndFunction
