Scriptname arcs_Devious extends Quest  

;zadLibs zlib

zadLibs function GetDeviousZadlibs() global
    return Quest.GetQuest("zadQuest") as zadLibs
endfunction

zadDeviceLists function GetDeviousZadDevicesList() global
    return Quest.GetQuest("zadxQuest") as zadDeviceLists
endfunction

function FakeDecorators()
    ;if DD is disabled
    SkyrimNetApi.RegisterDecorator("arcs_devious_being_vibrated", "arcs_Devious", "GetDeviousBeingVibratedFake")
endfunction

string function GetDeviousBeingVibratedFake(Actor akActor) global
    bool vibrated = false
    return "{\"being_vibrated\":" + vibrated + "}"
endfunction

function GameLoaded()

    ;zlib = GetDeviousZadlib()

    arcs_DeviousRegister.RegisterDecorators()
    arcs_DeviousRegister.RegisterActions()

    RegisterModEvents()

    Debug.Notification("Arcane Sexbot - Devious Devices active")

endfunction

function RegisterModEvents()
    RegisterForModEvent("DeviceActorOrgasm", "OnOrgasm")
    RegisterForModEvent("DeviceEdgedActor", "OnEdged")
    RegisterForModEvent("DeviceVibrateEffectStart", "OnVibrateStart")
    RegisterForModEvent("DeviceVibrateEffectStop", "OnVibrateStop")
endfunction

; Helper function to convert vibration strength to descriptive text
string function GetVibStrength(float vibStrength) global
    string strength = ""
    if vibStrength <= 0.5
        strength = "weakly"
    elseif vibStrength <= 1.0
        strength = "strongly"  
    elseif vibStrength <= 1.5
        strength = "intensely"
    else
        strength = "extremely intensely"
    endif
    return strength
endfunction

; Event handlers for Devious Devices mod events
Event OnOrgasm(string eventName, string actorName, float numArg, Form sender)

    Actor akActor = Game.GetPlayer()
    bool isRealFemale = akActor.GetLeveledActorBase().GetSex() == 1
    string messageStr
    if isRealFemale
        messageStr = actorName + " cries out in ecstasy as her body shudders with an intense climax, overwhelmed by waves of pleasure from her intimate devices"
    else
        messageStr = actorName + " cries out in ecstasy as his body shudders with an intense climax, overwhelmed by waves of pleasure from his intimate devices"    
    endif
    
    ; Register short-lived event for immediate context awareness
    SkyrimNetApi.RegisterShortLivedEvent("orgasm_" + actorName, "devious_orgasm", "", messageStr, 60000, Game.GetPlayer(), None)
    
    ; Also register as persistent event for historical tracking
    SkyrimNetApi.RegisterEvent("devious_orgasm", messageStr, Game.GetPlayer(), None)
    
    arcs_Utility.WriteInfo("DD Event: " + messageStr)
EndEvent

Event OnEdged(string eventName, string actorName, float numArg, Form sender)

    Actor akActor = Game.GetPlayer()
    bool isRealFemale = akActor.GetLeveledActorBase().GetSex() == 1
    string messageStr
    if isRealFemale
        messageStr = actorName + " gasps and whimpers in desperate frustration as she's brought right to the brink of climax, only to have the stimulation cruelly stop just before release, leaving her trembling with unfulfilled need"
    else
        messageStr = actorName + " gasps and whimpers in desperate frustration as he's brought right to the brink of climax, only to have the stimulation cruelly stop just before release, leaving him trembling with unfulfilled need"
    endif

    ; Register short-lived event for immediate context awareness
    SkyrimNetApi.RegisterShortLivedEvent("edged_" + actorName, "devious_edged", "", messageStr, 60000, Game.GetPlayer(), None)
    
    ; Also register as persistent event for historical tracking
    SkyrimNetApi.RegisterEvent("devious_edged", messageStr, Game.GetPlayer(), None)
    
    arcs_Utility.WriteInfo("DD Event: " + messageStr)
EndEvent

Event OnVibrateStart(string eventName, string actorName, float vibStrength, Form sender)
    string strength = GetVibStrength(vibStrength)
    Actor akActor = Game.GetPlayer()
    bool isRealFemale = akActor.GetLeveledActorBase().GetSex() == 1
    string messageStr
    if isRealFemale
        messageStr = actorName + "'s intimate devices have started vibrating " + strength + ", sending waves of pleasure through her body as the sexual stimulation begins"
    else
        messageStr = actorName + "'s intimate devices have started vibrating " + strength + ", sending waves of pleasure through his body as the sexual stimulation begins"
    endif
    
    ; Register short-lived event for immediate context awareness - longer TTL since vibration continues
    SkyrimNetApi.RegisterShortLivedEvent("vibrate_" + actorName, "devious_vibrate_start", "", messageStr, 60000, Game.GetPlayer(), None)
    
    ; Also register as persistent event for historical tracking
    ; SkyrimNetApi.RegisterEvent("devious_vibrate_start", messageStr, Game.GetPlayer(), None)
    
    arcs_Utility.WriteInfo("DD Event: " + messageStr)
EndEvent

Event OnVibrateStop(string eventName, string actorName, float vibStrength, Form sender)
    string strength = GetVibStrength(vibStrength)
    Actor akActor = Game.GetPlayer()
    bool isRealFemale = akActor.GetLeveledActorBase().GetSex() == 1
    string messageStr
    if isRealFemale
        messageStr = actorName + "'s intimate devices have stopped vibrating, leaving her breathless and aching as the intense sexual stimulation suddenly ends"
    else
        messageStr = actorName + "'s intimate devices have stopped vibrating, leaving him breathless and aching as the intense sexual stimulation suddenly ends"
    endif
    
    ; Register short-lived event for immediate context awareness
    SkyrimNetApi.RegisterShortLivedEvent("vibrate_" + actorName, "devious_vibrate_stop", "", messageStr, 60000, Game.GetPlayer(), None)
    
    ; Also register as persistent event for historical tracking
    ; SkyrimNetApi.RegisterEvent("devious_vibrate_stop", messageStr, Game.GetPlayer(), None)
    
    arcs_Utility.WriteInfo("DD Event: " + messageStr)
EndEvent


  

string function DeviousListDisplayNames() global
    return "Armbinder|Chastity Belt|Boots|Blindfold|Collar|Corset|Gag|Gloves|Harness|Hood|Nipple Piercing|Vaginal Piercing|Anal Plug|Vaginal Plug"
endfunction

string function DeviousList() global
    return "armbinder|belt|boots|blindfold|collar|corset|gag|gloves|harness|hood|npiercing|vpiercing|aplug|vplug"
    ;arm cuffs|leg cuffs|suit/catsuit|bra|"
endfunction

; string function DeviousRestraintsList() global
;     return "yoke|armbinder|collar|gag|blindfold|hood|harness|arm cuffs|leg cuffs|gloves|boots|corset|suit/catsuit"
; endfunction

string function GetDeviousDisplayName(string type) global
    string types = arcs_Devious.DeviousList()
    string displayNames = arcs_Devious.DeviousListDisplayNames()
    string result = ""
    string[] typesList = StringUtil.Split(types, "|")
    string[] displayNamesList = StringUtil.Split(displayNames, "|")
    int i = 0
    while i < typesList.Length
        if typesList[i] == type
            result = displayNamesList[i]
            i = 500
        endif
        i += 1
    endwhile
    return result
endfunction



Keyword function ItemTypeToKeyword(string type) global

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()

    if type == "armbinder"
        return zlib.zad_DeviousHeavyBondage  ;zad_DeviousArmbinder
    elseif type == "belt"
        return zlib.zad_DeviousBelt
    elseif type == "boots"
        return zlib.zad_DeviousBoots
    elseif type == "blindfold"
        return zlib.zad_DeviousBlindfold
    elseif type == "collar"
        return zlib.zad_DeviousCollar
    elseif type == "corset"
        return zlib.zad_DeviousCorset
    elseif type == "gag"
        return zlib.zad_DeviousGag
    elseif type == "gloves"
        return zlib.zad_DeviousGloves
    elseif type == "harness"
        return zlib.zad_DeviousHarness
    elseif type == "hood"
        return zlib.zad_DeviousHood
    elseif type == "npiercing"
        return zlib.zad_DeviousPiercingsNipple
    elseif type == "vpiercing"
        return zlib.zad_DeviousPiercingsVaginal
    elseif type == "aplug"
        return zlib.zad_DeviousPlugAnal
    elseif type == "vplug"
        return zlib.zad_DeviousPlugVaginal
    elseif type == "suit"
        return zlib.zad_DeviousSuit
    ;ankles cuffs
    ;arms cuffs
    ;ankle shackles
    ;other binders?


    else
        return none
    endif

endfunction

;NOTE - this code will not work in this mod, but will be super handy for binding

; int function CAN_EQUIP_LIST()
;     return 1
; endfunction

; int function CAN_REMOVE_LIST()
;     return 2
; endfunction

; string function CreateDeviousItemsTypes(Actor akActor, int direction)

;     string list = ""

;     list = arcs_Utility.AppendStringToStringList(list, AddItemToTypesList("Collar", akActor.WornHasKeyword(zlib.zad_DeviousCollar), direction), "|", false)
;     list = arcs_Utility.AppendStringToStringList(list, AddItemToTypesList("Wrist Restraints", akActor.WornHasKeyword(zlib.zad_DeviousHeavyBondage), direction), "|", false)

; endfunction

; string function AddItemToTypesList(string name, bool found, int direction)
;     string result = ""
;     if direction == CAN_EQUIP_LIST()
;         if !found 
;             result = name
;         endif
;     elseif direction == CAN_REMOVE_LIST()
;         if found
;             result = name
;         endif
;     endif
;     return result
; endfunction

;return types: 0 failed, 1 success, 2 player rejected
int function RemoveDeviousItem(Actor akSource, Actor akTarget, string type) global

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    int result = 0

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            if !arcs_Utility.ConfirmBox(akSource.GetDisplayName() + " wants to remove - " + arcs_Devious.GetDeviousDisplayName(type), "Allow this?", "Reject this")
                return 2
            endif
        endif

        arcs_Movement.FaceTarget(akSource, akTarget)
        arcs_Movement.PlayDoWork(akSource)

        if zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)
            result = 1
        endif

        StorageUtil.StringListRemove(akTarget, "arcs_dd_items", type, true)
        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, none) ;todo - make sure this works
        
        arcs_Utility.WriteInfo("Removeing DD: " + dev.GetName())

    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

    return result

endfunction

;return types: 0 failed, 1 success, 2 player rejected
int function AddRandomDeviousItem(Actor akSource, Actor akTarget, string type) global

    int result = 0

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    Keyword kw = arcs_Devious.ItemTypeToKeyword(type)

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    zadDeviceLists zDevicesList = arcs_Devious.GetDeviousZadDevicesList()

    ;armbinder|belt|boots|blindfold|collar|corset|gag|gloves|harness|hood|npiercing|vpiercing|aplug|vplug

    LeveledItem itemsList
    if type == "armbinder"
        itemsList = zDevicesList.zad_dev_armbinders
    elseif type == "belt"
        itemsList = zDevicesList.zad_dev_chastitybelts
    elseif type == "boots"
        itemsList = zDevicesList.zad_dev_boots
    elseif type == "blindfold"
        itemsList = zDevicesList.zad_dev_blindfolds
    elseif type == "collar"
        itemsList = zDevicesList.zad_dev_collars
    elseif type == "corset"
        itemsList = zDevicesList.zad_dev_corsets
    elseif type == "gag"
        itemsList = zDevicesList.zad_dev_gags
    elseif type == "gloves"
        itemsList = zDevicesList.zad_dev_gloves
    elseif type == "harness"
        itemsList = zDevicesList.zad_dev_harnesses
    elseif type == "hood"
        itemsList = zDevicesList.zad_dev_hoods
    elseif type == "npiercing"
        itemsList = zDevicesList.zad_dev_piercings_nipple
    elseif type == "vpiercing"
        itemsList = zDevicesList.zad_dev_piercings_vaginal
    elseif type == "aplug"
        itemsList = zDevicesList.zad_dev_plugs_anal
    elseif type == "vplug"
        itemsList = zDevicesList.zad_dev_plugs_vaginal

    endif

    Armor dev = zDevicesList.GetRandomDevice(itemsList)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            if !arcs_Utility.ConfirmBox(akSource.GetDisplayName() + " wants to add - " + type, "Allow this?", "Reject this")
                return 2
            endif
        endif

        arcs_Utility.WriteInfo("Adding DD: " + dev.GetName())
        if zlib.LockDevice(akTarget, dev, true)
            result = 1
        endif
        
        StorageUtil.StringListAdd(akTarget, "arcs_dd_items", type, false)
        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, dev)
        StorageUtil.SetFloatValue(akTarget, "arcs_worn_time_" + type, arcs_Utility.GetTime())
      
    else
        arcs_Utility.WriteInfo("No DD found")
    endif

    return result

endfunction



