Scriptname arcs_Eligibility extends Quest  

bool function ActorIsEligible(Actor akActor) global
    ;TODO - add other global checks here
    bool valid = true

    if akActor == Game.GetPlayer()
        valid = false ;the player should never be the source of these
    endif

    if akActor.IsChild()
        valid = false ;adults onlly
    endif

    ;TODO - add DHLP check

    return valid
endfunction

bool function TargetIsElibible(Actor akActor) global

    ;TODO - add other global checks here
    bool valid = true

    if akActor.IsChild()
        valid = false ;adults onlly
    endif

    ;TODO - add DHLP check

    return valid

    return false

endfunction

;TODO - move eligibility checks to their own script
;TODO - create function to add to IsEligible calls to run high level checks like DHLP so not duplicated or missed
bool function ExtCmdStartSex_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true 

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionStartSex.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdStartSex_IsEligible - disabled action")
        return false
    endif
    
    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    if arcs_SexLab.ActorInSexScene(akOriginator)
        result = false ;in a sex scene already
    endif

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if akTarget.IsChild()
            result = false
        endif
    endif

    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akOriginator)
    int arousalNeeded = config.arcs_GlobalArousalForSex.GetValue() as int
    if arousal < arousalNeeded
        result = false
    endif

    ;TODO - target arousal check
    ;TODO - if NC sex, target arousal is not needed


    arcs_Utility.WriteInfo("ExtCmdStartSex_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + \
        " arousal: " + arousal + " needed: " + arousalNeeded + " akTarget: " + targetName + " result: " + result)

    return result

endfunction

bool function ExtCmdStartThreePersonSex_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    ;NOTE - I need to ask about this one. paramsJson is not working in here, but it works in the execute method??

    arcs_Utility.WriteInfo("ExtCmdStartThreePersonSex_IsEligible - contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    bool result = true 

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionStartSex.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdStartSex_IsEligible - disabled action")
        return false
    endif
    
    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    if arcs_SexLab.ActorInSexScene(akOriginator)
        result = false ;in a sex scene already
    endif

    Actor akTarget1 = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)
    Actor akTarget2 = SkyrimNetApi.GetJsonActor(paramsJson, "sexpartner2", none)

    string target1Name = ""
    string target2Name = ""
    ; if akTarget1 == none || akTarget2 == none
    ;     result = false
    ; Else
    ;     target1Name = akTarget1.GetDisplayName()
    ;     target2Name = akTarget2.GetDisplayName()
    ;     if akTarget1.IsChild() || akTarget2.IsChild()
    ;         result = false ;adults only
    ;     endif
    ; endif

    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akOriginator)
    int arousalNeeded = config.arcs_GlobalArousalForSex.GetValue() as int
    if arousal < arousalNeeded
        result = false
    endif

    ; if akTarget1 == akTarget2 || akOriginator == akTarget1 || akOriginator == akTarget2
    ;     result = false ;can't be the same person
    ; endif

    ;TODO - target 1 & 2 arousal check
    ;TODO - if NC 1 or 2 sex, target arousal is not needed

    ; arcs_Utility.WriteInfo("contextJson: " + contextJson)
    ; arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    arcs_Utility.WriteInfo("ExtCmdStartSexWith3_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + \
        " arousal: " + arousal + " needed: " + arousalNeeded + " akTarget1: " + target1Name + " akTarget2: " + target2Name + " result: " + result)

    return result

endfunction

bool function ExtCmdUpdateSexualPreferences_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    return true ;TODO - make this work
endfunction

bool function ExtCmdStripTarget_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionStripTarget.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdStripTarget_IsEligible - disabled action")
        return false
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if !arcs_Eligibility.TargetIsElibible(akTarget) 
            result = false
        endif

        arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
        if ncheck.NudityCheck(akTarget) == ncheck.NUDITYCHECK_ACTOR_NUDE()
            result = false ;already undressed
        endif

    endif

    arcs_Utility.WriteInfo("ExtCmdStripTarget_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " akTarget: " + targetName + " result: " + result, 2)

    return result

endfunction

bool function ExtCmdDressTarget_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    ;return true ;debug test

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionDressTarget.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdDressTarget_IsEligible - disabled action")
        return false
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if !arcs_Eligibility.TargetIsElibible(akTarget) 
            result = false
        endif

        arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
        if ncheck.NudityCheck(akTarget) != ncheck.NUDITYCHECK_ACTOR_NUDE()
            arcs_Utility.WriteInfo("ExtCmdDressTarget_IsEligible - nudity check: " + ncheck.NudityCheck(akTarget))
            result = false ;already dressed
        endif

    endif

    arcs_Utility.WriteInfo("ExtCmdDressTarget_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " akTarget: " + targetName + " result: " + result)

    return result

endfunction

bool function ExtCmdUndress_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionUndress.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdUndress_IsEligible - disabled action")
        return false
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    if arcs_SexLab.ActorInSexScene(akOriginator)
        result = false ;in a sex scene
    endif
    
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    if ncheck.NudityCheck(akOriginator) == ncheck.NUDITYCHECK_ACTOR_NUDE()
        result = false ;already undressed
    endif

    arcs_Utility.WriteInfo("ExtCmdUndress_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " result: " + result)

    return result

endfunction

bool function ExtCmdDress_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionDress.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdDress_IsEligible - disabled action")
        return false
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    if arcs_SexLab.ActorInSexScene(akOriginator)
        result = false ;in a sex scene
    endif
    
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    if ncheck.NudityCheck(akOriginator) != ncheck.NUDITYCHECK_ACTOR_NUDE()
        result = false ;already dressed
    endif

    arcs_Utility.WriteInfo("ExtCmdDress_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " result: " + result)

    return result

endfunction

bool function ExtCmdDecreaseArousal_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionDecreaseArousal.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdDecreaseArousal_IsEligible - disabled action")
        return false
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    return result

endfunction

bool function ExtCmdIncreaseArousal_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionIncreaseArousal.GetValue() == 0
        arcs_Utility.WriteInfo("ExtCmdIncreaseArousal_IsEligible - disabled action")
        return false
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    return result

endfunction

bool function ExtCmdDecreaseAttraction_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    ;NOTE - player only target action - maybe use json for all actors?

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    ;TODO - check for disabled actions

    Actor thePlayer = Game.GetPlayer()
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", thePlayer) ;todo - pull this from the quest?
    if config.arcs_GlobalUseAttractionSystem.GetValue() == 1 && akTarget == thePlayer
        return true
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    return result

endfunction

bool function ExtCmdIncreaseAttraction_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    ;NOTE - player only target action - maybe use json for all actors?

    bool result = true

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    ;TODO - check for disabled actions

    Actor thePlayer = Game.GetPlayer()
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", thePlayer) ;todo - pull this from the quest?
    if config.arcs_GlobalUseAttractionSystem.GetValue() == 1 && akTarget == thePlayer
        return true
    endif

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    return result

endfunction
