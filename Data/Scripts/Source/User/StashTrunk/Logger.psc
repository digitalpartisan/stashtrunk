Scriptname StashTrunk:Logger Hidden Const DebugOnly

String Function getName() Global
	return "StashTrunk"
EndFunction

Bool Function log(String sMessage, String[] tags = None) Global
	return Loggout.log(getName(), sMessage, tags)
EndFunction

Bool Function warn(String sMessage, String[] tags = None) Global
	return Loggout.warn(getName(), sMessage, tags)
EndFunction

Bool Function error(String sMessage, String[] tags = None) Global
	return Loggout.error(getName(), sMessage, tags)
EndFunction

Bool Function logAddingContainerLink(ObjectReference akReference) Global
	return log("Adding container link to workbench " + akReference)
EndFunction

Bool Function logRemovingContainerLink(ObjectReference akReference) Global
	return log("Removing container link to workbench " + akReference)
EndFunction
