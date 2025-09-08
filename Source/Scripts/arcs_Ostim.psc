Scriptname arcs_Ostim extends Quest  

string jsonFile = "arcbot_ostim_descriptions.json"

function GameLoaded()

    RegisterForModEvent("ostim_prestart", "OStimPreStart")
	RegisterForModEvent("ostim_start", "OStimStart")
	RegisterForModEvent("ostim_end", "OStimEnd")
	RegisterForModEvent("ostim_orgasm", "OStimOrgasm")
    RegisterForModEvent("OStim_AnimationChanged", "OStimAnimationChanged")
    RegisterForModEvent("OStim_SceneChanged", "OStimSceneChanged")


endfunction

arcs_Ostim function GetOstim() global
    return Quest.GetQuest("arcs_MainQuest") as arcs_Ostim
endfunction

bool function UsingOstim() global
    arcs_ConfigSettings config = arcs_ConfigSettings.GetArcsConfig()
    return (config.arcs_GlobalUseOstim.GetValue() == 1 && config.arcs_GlobalHasOstim.GetValue() == 1)
endfunction

bool function ActorInSexScene(Actor akActor) global
    return OActor.IsInOStim(akActor)
endfunction

Event OStimPreStart(string eventName, string strArg, float numArg, Form sender)
    ;debug.MessageBox("prestart...")
    arcs_Utility.WriteInfo("OStimPreStart eventName: " + eventName + " strArg: " + strArg + " numArg: " + numArg + " sender: " + sender, 2)
EndEvent

Event OStimStart(String EventName, String sceneId, Float index, Form Sender)
    ;debug.MessageBox("start...")
    arcs_Utility.WriteInfo("OStimStart eventName: " + eventName + " sceneId: " + sceneId + " index: " + index + " sender: " + sender, 2)
	; _Actors = OThread.GetActors(0)
	; MostRecentOrgasmedActor = None
	; StartTime = Utility.GetCurrentRealTime()
EndEvent

Event OStimEnd(String EventName, String sceneId, Float index, Form Sender)
	; OSANative.EndPlayerDialogue()
    ;debug.MessageBox("end...")
    arcs_Utility.WriteInfo("OStimEnd eventName: " + eventName + " sceneId: " + sceneId + " index: " + index + " sender: " + sender, 2)

    Actor[] actors = OThread.GetActors(index as int)

    debug.MessageBox(actors)

    ; string content = ""
    ; if actors.length == 1
    ;     content = actors[0].GetDisplayName() + " masturbated."
    ; else
    ;     content = arcs_Utility.MakeActorsString(actors) + " had sex."
    ; endif

    ; Actor dom = actors[0]
    ; Actor sub = none
    ; if actors[1] 
    ;     sub = actors[1]
    ; endif

    ; bool result = arcs_SkyrimNet.CreateLongLivedEvent("sex_event", content, dom, sub)
    ; arcs_Utility.WriteInfo("OnAnimationStart - created long term event: " + result)

    ; arcs_Utility.WriteInfo("OnAnimationEnd fired - sex completed")

    ; if actors.length == 1
    ;     result = arcs_SkyrimNet.CreateDirectNarration(actors[0].GetDisplayName() + " finished masturbating.")
    ; else
    ;     result = arcs_SkyrimNet.CreateDirectNarration(arcs_Utility.MakeActorsString(actors) + " finished having sex.") 
    ; endif

EndEvent

Event OStimAnimationChanged(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OStimAnimationChanged eventName: " + eventName + " strArg: " + strArg + " numArg: " + numArg + " sender: " + sender, 2)

    Actor[] actors = OThread.GetActors(numArg as int)

    ;debug.MessageBox(actors)

    int i = 0
    while i < actors.Length
        StorageUtil.SetStringValue(actors[i], "arcbot_ostim_scene", strArg)
        i += 1
    endwhile

    ;debug.MessageBox("animation changed...")
EndEvent

Event OStimSceneChanged(string eventName, string strArg, float numArg, Form sender)
    ;debug.MessageBox("scene end...")
    arcs_Utility.WriteInfo("OStimSceneChanged eventName: " + eventName + " strArg: " + strArg + " numArg: " + numArg + " sender: " + sender, 2)

    string sceneId = OThread.GetScene(numArg as int)
    string[] actionTypes = OMetadata.GetActionTypes(sceneId)
    string[] sceneTags = OMetadata.GetSceneTags(sceneId)
    Actor[] actors = OThread.GetActors(numArg as int)

    ;debug.MessageBox("actionTypes: " + actionTypes)
    ;debug.MessageBox("sceneTags: " + sceneTags)

    string changeBuffer = ""
    string actionBuffer = ""
    string sceneTagBuffer = ""

    int idx = 0

    idx = 0
    while idx < actors.Length
        Actor act = actors[idx]

        if changeBuffer == ""
            changeBuffer = act.GetDisplayName()
        else
            changeBuffer += ", " + act.GetDisplayName()
        endif

        idx += 1
    endwhile

    idx = 0
    while idx < actionTypes.Length
        string actionType = actionTypes[idx]
        JsonUtil.StringListAdd(jsonFile, "action_types", actionType, false)
        if actionBuffer == ""
            actionBuffer = actionType
        else
            actionBuffer += ", " + actionType
        endif
        idx += 1
    endwhile

    idx = 0
    while idx < sceneTags.Length
        string sceneTag = sceneTags[idx]
        JsonUtil.StringListAdd(jsonFile, "scene_tags", sceneTag, false)
        if sceneTagBuffer == ""
            sceneTagBuffer = sceneTag
        else
            sceneTagBuffer += ", " + sceneTag
        endif
        idx += 1
    endwhile

    if actors.Length == 1
        string sexDesc = "his"
        if actors[0].GetActorBase().GetSex() == 1
            sexDesc = "her"
        endif        
        changeBuffer += " is changing " + sexDesc + " " + sceneTagBuffer + " self-love scene. This can be described with the words: " + actionBuffer
    else
        changeBuffer += " are changing their " + sceneTagBuffer + " intimate scene. This can be described with the words: " + actionBuffer
    endif


    ;debug.MessageBox(changeBuffer)



EndEvent

Event OStimOrgasm(String EventName, String sceneId, Float index, Form Sender)

	Actor akActor = Sender As Actor
    ;debug.MessageBox(akActor.GetDisplayName() + " had an orgasm...")
    arcs_Utility.WriteInfo("OStimOrgasm eventName: " + eventName + " sceneId: " + sceneId + " index: " + index + " sender: " + sender, 2)

    arcs_Utility.WriteInfo(akActor.GetDisplayName() + " just had an orgasm")

    ;string sceneName = StorageUtil.GetStringValue(akActor, "arcbot_ostim_scene", "")

    string actorsListStr = StorageUtil.GetStringValue(akActor, "arcbot_ostim_scene_actors", "")
    string[] actorsList = StringUtil.Split(actorsListStr, "|")

    ;debug.MessageBox(sceneName)

    ;Actor akSecondActor
    string secondActorName
    Actor[] actors = OThread.GetActors(index as int)
    ;debug.MessageBox(actors.Length)
    int i = 0
    if actorsList.Length == 2
        ;for 2 person sex
        while i < actorsList.Length
            ;debug.MessageBox("loop actor: " + actors[i])
            if actorsList[i] != akActor.GetDisplayName()
                secondActorName = actorsList[i]
                i = 500
            endif
            i += 1
        endwhile
    endif
    ;debug.MessageBox("actor: " + akActor.GetDisplayName() + " second: " + secondActorName)

    int sexFlag = akActor.GetActorBase().GetSex()

    string sexAct = ""
    if StringUtil.Find(sceneId, "finger", 0) > -1 || StringUtil.Find(sceneId, "sidemakeout", 0) > -1 || StringUtil.Find(sceneId, "kiss", 0) > -1 || StringUtil.Find(sceneId, "lyingsiderub", 0) > -1
        if sexFlag == 1
            if secondActorName != ""
                sexAct = " from " + secondActorName + " fingering her pussy."
            else
                sexAct = " from having her pussy fingered."
            endif
        endif
    endif
    if StringUtil.Find(sceneId, "lick", 0) > -1  || StringUtil.Find(sceneId, "69", 0) > -1
        if sexFlag == 1
            if secondActorName != ""
                sexAct = " from " + secondActorName + " licking her pussy."
            else
                sexAct = " from her pussy being licked."
            endif
        endif
    endif
    if StringUtil.Find(sceneId, "rub", 0) > -1
        if sexFlag == 1
            if secondActorName != ""
                sexAct = " from her pussy being rubbed by " + secondActorName
            else
                sexAct = " from her pussy being rubbed."
            endif
        Else
            sexAct = " from his cock being rubbed."
        endif
    endif
    if StringUtil.Find(sceneId, "scissor", 0) > -1
        if sexFlag == 1
            if secondActorName != ""
                sexAct = " from grinding her pussy against " + secondActorName + "'s pussy."
            else
                ;not sure how to handle 3 or more here?
                sexAct = " from grinding her pussy against another."
            endif
        endif
    endif
    if StringUtil.Find(sceneId, "grind", 0) > -1
        if sexFlag == 1
            if secondActorName != ""
                sexAct = " from grinding her pussy on " + secondActorName
            else
                sexAct = " from grinding her pussy."
            endif
        endif
    endif

    ;debug.MessageBox("sexact: " + sexAct)

    string desc = "Had orgasm" + sexAct
    string data = akActor.GetDisplayName() + " had an orgasm" + sexAct
    
    bool result = arcs_SkyrimNet.CreateDirectNarration(akActor.GetDisplayName() + " had an orgasm" + sexAct, akActor)
    arcs_Utility.WriteInfo("OStimOrgasm - direct narration: " + result + " actor: " + akActor.GetDisplayName())

    result = arcs_SkyrimNet.CreateShortLivedEvent("sex_event_" + akActor.GetDisplayName(), "sex_event_orgasm", desc, data, akActor, akActor)
    arcs_Utility.WriteInfo("OStimOrgasm - created short term event: " + result + " actor: " + akActor.GetDisplayName())


    ;fingering
    ;nipplelicking
    ;kneelinglicking


	; ; Fertility Mode compatibility
	; int actionIndex = OMetadata.FindActionForActor(sceneId, index as int, "vaginalsex")
	; If  actionIndex != -1
	; 	Actor impregnated = GetActor(OMetadata.GetActionTarget(sceneId, actionIndex))
	; 	If impregnated
	; 		int handle = ModEvent.Create("FertilityModeAddSperm")
	; 		If handle
	; 			ModEvent.PushForm(handle, impregnated)
	; 			ModEvent.PushString(handle, Act.GetDisplayName())
	; 			ModEvent.PushForm(handle, Act)
	; 			ModEvent.Send(handle)
	; 		EndIf
	; 	EndIf
	; EndIf
EndEvent

bool function StartSex(Actor[] actors, string type, string intensity, bool onlyUseType = false)

    ;debug.MessageBox("sex type: " + type)

    string tags = type

    Actor thePlayer = Game.GetPlayer()

    arcs_Utility.WriteInfo("StartSexScene processing for OStim: ") ; + tags)
    ; int playerIndex = actors.Find(thePlayer)
    ; if playerIndex > -1
    ;     actors = OActorUtil.SelectIndexAndSort(actors, PapyrusUtil.ActorArray(1))
    ; else
    ;     actors = OActorUtil.Sort(actors, PapyrusUtil.ActorArray(1))
    ; endif
    ; debug.MessageBox(actors)
    int builderID = OThreadBuilder.create(actors)
    
    string newScene = ""
    if onlyUseType != ""
        ;tags = ConvertTagsOstim(tags)
        ;newScene = OLibrary.GetRandomSceneWithAction(actors, tags)
        newScene = OLibrary.GetRandomSceneSuperloadCSV(actors, "", "", "", tags, "")
        ;debug.MessageBox("only use branch: " + newScene + "tag: " + tags)
    else
        if type == "any"
            newScene = OLibrary.GetRandomScene(actors)
        else
            newScene = GetSceneByActionsOrTags(actors, tags, true)
        endif
    endif

    ;debug.MessageBox("scene: " + newScene)

    OThreadBuilder.SetStartingAnimation(builderID, newScene)

    int newThreadID = OThreadBuilder.Start(builderID)

    arcs_Utility.WriteInfo("OStim Thread [" + newThreadID + "] Initialized")

    string actorsList = ""
    int i = 0
    while i < actors.Length
        if actorsList != ""
            actorsList += "|"
        endif
        actorsList += actors[i].GetDisplayName()
        i += 1
    endwhile

    i = 0
    while i < actors.Length
        StorageUtil.SetIntValue(actors[i], "arcbot_ostim_thread", newThreadID)
        StorageUtil.SetStringValue(actors[i], "arcbot_ostim_scene", newScene)
        StorageUtil.SetStringValue(actors[i], "arcbot_ostim_scene_actors", actorsList)
        i += 1
    endwhile

    ;;return newThreadID - store this

    return (newThreadID > 0)

endfunction

string function GetSceneByActionsOrTags(actor[] actors, string tags, bool useRandom = false)
    string newScene
    if tags != ""
        arcs_Utility.WriteInfo("Searching for OStim scene with Actions: " + tags)
        tags = ConvertTagsOstim(tags)
        newScene = OLibrary.GetRandomSceneWithAnyActionCSV(actors, tags)
        arcs_Utility.WriteInfo("Ostim post Action search: " + newScene)
        if(newScene == "")
            arcs_Utility.WriteInfo("Searching for OStim scene with Tags: " + tags)
            newScene = OLibrary.GetRandomSceneWithAnySceneTagCSV(actors, tags)
            arcs_Utility.WriteInfo("Ostim post Tag search: " + newScene)
        endif
        if (newScene == "")
            newScene = OLibrary.GetRandomScene(actors)
            ;debug.MessageBox(newScene)
        endif
    else
    arcs_Utility.WriteInfo("No OStim tags provided")
  endif
  return newScene
endfunction

;"anal|vaginal|oral|fingering|cunnilingus|breastfeeding|chestcum|pussy|vampire|hugging|kissing"

string Function ConvertTagsOstim(string tags)
    ; Convert sexlab tags to ostim tags
    if tags == "anal"
        tags = "analsex"
    elseif tags == "vaginal"
        tags = "vaginalsex"
    elseif tags == "oral"
        tags = "deepthroat"
    elseif tags == "fingering"
        tags = "vaginalfingering"
    elseif tags == "cunnilingus"
        tags = "cunnilingus,lickingvagina,oralfingering"
    elseif tags == "breastfeeding"
        tags = "suckingnipple"
    elseif tags == "chestcum"
        tags = "cumonchest"
    elseif tags == "pussy"
        tags = "rubbingclitoris"
    elseif tags == "vampire"
        tags = "vampirebite"
    elseif tags == "hugging"
        tags = "cuddling"
    elseif tags == "kissing"
        tags = "frenchkissing"
    EndIf
    return tags
EndFunction