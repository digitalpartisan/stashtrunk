Scriptname StashTrunk:FlushOnUninstall extends Chronicle:Package:CustomBehavior

StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const Mandatory

Bool Function uninstallBehavior()
	StashTrunk_ContainerHandler.uninstallFlush()
	return true
EndFunction
