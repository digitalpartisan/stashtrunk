;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname StashTrunk:Fragments:Terminals:WorkshopContents Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_WorkbenchScanner.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_WorkbenchScanner.Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

StashTrunk:WorkbenchScanner Property StashTrunk_WorkbenchScanner Auto Const Mandatory
