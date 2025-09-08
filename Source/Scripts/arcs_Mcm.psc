Scriptname arcs_Mcm extends SKI_ConfigBase

string version = ""

bool skyrimNetFound

int toggleClearDhlp

int toggleUseOstim
int toggleUseOSLA
int toggleUseSexLab
int toggleUseSLA

int toggleActionStartSex
int toggleActionStripTarget
int toggleActionDressTarget
int toggleActionUndress
int toggleActionDress
int toggleActionDecreaseArousal
int toggleActionIncreaseArousal
int toggleActionDecreaseAttraction
int toggleActionIncreaseAttraction
int toggleActionStartThreePerson
int toggleActionStartMasturbation
int toggleActionKiss

int toggleActionAllDevious
int toggleActionDeviousEquips

;armbinder|belt|boots|blindfold|collar|corset|gag|gloves|harness|hood|npiercing|vpiercing|aplug|vplug
int toggleDeviousShocks
int toggleDeviousStartVibration
int toggleDeviousStopVibration
int toggleDeviousArmbinder
int toggleDeviousBelt
int toggleDeviousBoots
int toggleDeviousBlindfold
int toggleDeviousCollar
int toggleDeviousCorset
int toggleDeviousGag
int toggleDeviousGloves
int toggleDeviousHarness
int toggleDeviousHood
int toggleDeviousNPiercing
int toggleDeviousVPiercing
int toggleDeviousAPlug
int toggleDeviousVPlug

int toggleShowSexConfirm
int toggleDeviousConfirm

int toggleUseArousal
int sliderArousalForSex
int sliderSlightlyAroused
int sliderVeryAroused
int toggleUseSexualityInCheck

int toggleAttractionSystem
int toggleAttractionSeeding
int sliderSlightlyAttracted
int sliderVeryAttracted

int toggleSubmissionAndSlavery

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

int hotkeyKeymapOption
int hotkeyModifierOption

int actorCountMenu
int selectSlPageMenu
int selectedActorCount
int selectedSlPage
string[] actorCountArr
string[] slPagesArr
string[] slEditPageArr
int[] slToggleArr

Actor thePlayer

event OnConfigOpen()

    thePlayer = Game.GetPlayer()

    ;main = Quest.GetQuest("arcs_MainQuest") as arcs_Main
    ;config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    Pages = new string[7]

    Pages[0] = "Settings"
    Pages[1] = "Arousal Settings"
    Pages[2] = "Attraction Settings"
    Pages[3] = "SexLab Tags"
    Pages[4] = "Manage Actions"
    Pages[5] = "Devious Devices"
    Pages[6] = "Diagnostics"

    ;load
    actorCountArr = CreateNumberMenu(5)

    slEditPageArr = new string[12]
    slToggleArr = new int[12]

    if selectedActorCount == 0
        selectedActorCount = 1
        selectedSlPage = 1
    endif

endevent

string[] function CreateNumberMenu(int max)
    string str = ""
    int i = 1
    while i <= max
        if str != ""
            str += "|"
        endif
        str += i
        i += 1
    endwhile
    return StringUtil.Split(str, "|")
endfunction

event OnPageReset(string page)

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplayWelcome()
    elseif page == "Settings"
        DisplaySettings()
    elseif page == "Arousal Settings"
        DisplayArousal()
    elseif page == "Attraction Settings"
        DisplayAttraction()
    elseif page == "SexLab Tags"
        DisplaySexLabTags()
    elseif page == "Manage Actions"
        DisplayActions()
    elseif page == "Diagnostics"
        DisplayDiagnostics()
    elseif page == "Devious Devices"
        DisplayDevious()
    elseif page == "Submission & Slavery"
        DisplaySlavery()

    endif

    if Game.IsPluginInstalled("SkyrimNet.esp")
        skyrimNetFound = true
    Else
        skyrimNetFound = false
    endif

endevent

function DisplayWelcome()

    AddTextOption("Version", "5.01")

endfunction

function DisplayDiagnostics()

    AddHeaderOption("Status Information")
    AddHeaderOption("")

    string dhlpStatus = "No"
    if !(gdata.DhlpSuspend == 0)
        dhlpStatus = "Yes - "
        if StringUtil.GetLength(gdata.DhlpSuspendByMod) > 15
            dhlpStatus += StringUtil.Substring(gdata.DhlpSuspendByMod, 0, 15)
        Else
            dhlpStatus += gdata.DhlpSuspendByMod
        endif
    endif

    AddTextOption("DHLP Suspended", dhlpStatus)
    if !(gdata.DhlpSuspend == 0)
        toggleClearDhlp = AddTextOption("Click to end DHLP suspended", "")
    else
        AddTextOption("", "")
    endif

    AddHeaderOption("Requied Mods")
    AddHeaderOption("")

    string found = "No"
    if skyrimNetFound
        found = "Yes"
    endif

    AddTextOption("SkyrimNet", found)
    AddTextOption("", "")

    AddHeaderOption("Optional Mods")
    AddHeaderOption("")

    AddTextOption("Devious Devices", GlobalDetectionString(config.arcs_GlobalHasDeviousDevices))
    AddTextOption("", "")

    AddTextOption("Ostim", GlobalDetectionString(config.arcs_GlobalHasOstim))
    if config.arcs_GlobalHasOstim.GetValue() == 1
        toggleUseOstim = AddToggleOption("Use Ostim", config.arcs_GlobalUseOstim.GetValue() as int)
    else
        AddTextOption("", "")
    endif

    AddTextOption("SexLab", GlobalDetectionString(config.arcs_GlobalHasSexLab))
    if config.arcs_GlobalHasSexLab.GetValue() == 1
        toggleUseSexLab = AddToggleOption("Use SexLab", config.arcs_GlobalUseSexLab.GetValue() as int)
    else
        AddTextOption("", "")
    endif

    AddTextOption("SexLab Arousal", GlobalDetectionString(config.arcs_GlobalHasSexLabAroused))
    AddTextOption("", "")

    AddTextOption("OSL Aroused", GlobalDetectionString(config.arcs_GlobalHasOslAroused))
    AddTextOption("", "")

endfunction

function DisplaySettings()

    AddHeaderOption("Interface Settings")
    AddHeaderOption("")

    toggleShowSexConfirm = AddToggleOption("Show Confirm Before Sex", arcs_GlobalShowSexConfirm.GetValue() as int)
    AddTextOption("", "")

    AddHeaderOption("Key Settings")
    AddHeaderOption("")

    int mHotkey = arcs_GlobalHotkey.GetValue() as int
    if mHotkey == 0
        mHotkey = -1
    endif
    hotkeyKeymapOption = AddKeyMapOption("Set Hotkey Menu Key", mHotkey)
    hotkeyModifierOption = AddTextOption("Set Hotkey Menu Modifier", GetModifierString(arcs_GlobalModifierKey.GetValue() as int))

endfunction

function DisplayArousal()

    AddHeaderOption("Arousal Settings")
    AddHeaderOption("")

    toggleUseArousal = AddToggleOption("Use Arousal In Sex", config.arcs_GlobalUseArousal.GetValue() as int)
    sliderArousalForSex = AddSliderOption("Arousal Needed For Sex", arcs_GlobalArousalForSex.GetValue() as int, "{0}")

    sliderSlightlyAroused = AddSliderOption("Slightly Aroused Conversation", arcs_GlobalSlightlyAroused.GetValue() as int, "{0}")
    sliderVeryAroused = AddSliderOption("Very Aroused Conversation", arcs_GlobalVeryAroused.GetValue() as int, "{0}")



endfunction

function DisplayAttraction()

    AddHeaderOption("Attraction Settings")
    AddHeaderOption("")

    toggleAttractionSystem = AddToggleOption("Use Attraction System", config.arcs_GlobalUseAttractionSystem.GetValue() as int)
    toggleAttractionSeeding = AddToggleOption("Use Attraction Seeding", config.arcs_GlobalUseAttractionSeed.GetValue() as int)

    sliderSlightlyAttracted = AddSliderOption("Slightly Attracted Conversation", config.arcs_GlobalSlightlyAttracted.GetValue() as int, "{0}")
    sliderVeryAttracted = AddSliderOption("Very Attracted Conversation", config.arcs_GlobalVeryAttracted.GetValue() as int, "{0}")

    toggleUseSexualityInCheck = AddToggleOption("Use SL Sexuality - Bi, Gay, Straight", config.arcs_GlobalUseSexualityCheck.GetValue() as int)


endfunction

function DisplaySexLabTags()

    AddHeaderOption("SexLab Tags")
    AddHeaderOption("")

    SexLabFramework sfx = arcs_SexLab.GetSexLab()

    string[] tags = sfx.GetAllAnimationTags(selectedActorCount, true)

    slPagesArr = CreateNumberMenu(Math.Ceiling(tags.Length as float / 12.0))

    actorCountMenu = AddMenuOption("View For Actor Count", selectedActorCount)
    selectSlPageMenu = AddMenuOption("Select Page", selectedSlPage)

    AddTextOption("Total For Count", tags.Length)
    AddTextOption("", "")

    int ip = (12 * (selectedSlPage - 1))
    int i = 0
    while ip < tags.Length && i < 12

        slEditPageArr[i] = tags[ip]

        slToggleArr[i] = AddTextOption(slEditPageArr[i], "")

        ip += 1
        i += 1

    endwhile

endfunction

function DisplayActions()

    AddHeaderOption("Manage Actions")
    AddHeaderOption("")

    toggleActionStartSex = AddToggleOption("Action - Start Sex (" + arcs_Utility.GetTimesUsed("ExtCmdStartSex", thePlayer) + ")", config.arcs_GlobalActionStartSex.GetValue() as int)
    toggleActionStartThreePerson = AddToggleOption("Action - Start 3 Person Sex (" + arcs_Utility.GetTimesUsed("ExtCmdStartThreePersonSex", thePlayer) + ")", config.arcs_GlobalActionStartSex.GetValue() as int)
    toggleActionStartMasturbation = AddToggleOption("Action - Start Masturbation (" + arcs_Utility.GetTimesUsed("ExtCmdStartMasturbation", thePlayer) + ")", config.arcs_GlobalActionStartMasturbation.GetValue() as int)
    toggleActionKiss = AddToggleOption("Action - Kiss (" + arcs_Utility.GetTimesUsed("ExtCmdKiss", thePlayer) + ")", config.arcs_GlobalActionKiss.GetValue() as int)
    toggleActionStripTarget = AddToggleOption("Action - Strip Target (" + arcs_Utility.GetTimesUsed("ExtCmdStripTarget", thePlayer) + ")", config.arcs_GlobalActionStripTarget.GetValue() as int)
    toggleActionDressTarget = AddToggleOption("Action - Dress Target (" + arcs_Utility.GetTimesUsed("ExtCmdDressTarget", thePlayer) + ")", config.arcs_GlobalActionDressTarget.GetValue() as int)
    toggleActionUndress = AddToggleOption("Action - Undress (" + arcs_Utility.GetTimesUsed("ExtCmdUndress", thePlayer) + ")", config.arcs_GlobalActionUndress.GetValue() as int)
    toggleActionDress = AddToggleOption("Action - Dress (" + arcs_Utility.GetTimesUsed("ExtCmdDress", thePlayer) + ")", config.arcs_GlobalActionDress.GetValue() as int)
    toggleActionDecreaseArousal = AddToggleOption("Action - Decrease Arousal (" + arcs_Utility.GetTimesUsed("ExtCmdDecreaseArousal", thePlayer) + ")", config.arcs_GlobalActionDecreaseArousal.GetValue() as int)
    toggleActionIncreaseArousal = AddToggleOption("Action - Increase Arousal (" + arcs_Utility.GetTimesUsed("ExtCmdIncreaseArousal", thePlayer) + ")", config.arcs_GlobalActionIncreaseArousal.GetValue() as int)
    toggleActionDecreaseAttraction = AddToggleOption("Action - Decrease Attraction (" + arcs_Utility.GetTimesUsed("ExtCmdDecreaseAttraction", thePlayer) + ")", config.arcs_GlobalActionDecreaseAttraction.GetValue() as int)
    toggleActionIncreaseAttraction = AddToggleOption("Action - Increase Attraction (" + arcs_Utility.GetTimesUsed("ExtCmdIncreaseAttraction", thePlayer) + ")", config.arcs_GlobalActionIncreaseAttraction.GetValue() as int)

endfunction

function DisplayDevious()

    AddHeaderOption("Devious Device Settings")
    AddHeaderOption("")

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1

        toggleDeviousConfirm = AddToggleOption("Show Confirm For Device Change", config.arcs_GlobalDeviousConfirm.GetValue() as int)
        toggleActionAllDevious = AddToggleOption("Enable Devious Actions", config.arcs_GlobalActionAllDevious.GetValue() as int)
        toggleActionDeviousEquips = AddToggleOption("Enable Devious Item Equip", config.arcs_GlobalActionDeviousEquips.GetValue() as int)
        AddTextOption("", "")

        AddHeaderOption("Devious Device Actions")
        AddHeaderOption("")

        toggleDeviousShocks = AddToggleOption("Action - Shocks (" + arcs_Utility.GetTimesUsed("ArcbotShock", thePlayer) + ")", config.arcs_GlobalDeviousActionShock.GetValue() as int)
        AddTextOption("", "")
        toggleDeviousStartVibration = AddToggleOption("Action - Start Vibration (" + arcs_Utility.GetTimesUsed("ArcbotStartVibration", thePlayer) + ")", config.arcs_GlobalDeviousActionVibration.GetValue() as int)
        toggleDeviousStopVibration = AddToggleOption("Action - Stop Vibration (" + arcs_Utility.GetTimesUsed("ArcbotStopVibration", thePlayer) + ")", config.arcs_GlobalDeviousActionStopVibration.GetValue() as int)
        toggleDeviousArmbinder = AddToggleOption("Action - Add Binder (" + arcs_Utility.GetTimesUsed("ArcbotAddArmbinder", thePlayer) + ")", config.arcs_GlobalDeviousActionBinder.GetValue() as int)
        toggleDeviousBelt = AddToggleOption("Action - Add Belt (" + arcs_Utility.GetTimesUsed("ArcbotAddChastityBelt", thePlayer) + ")", config.arcs_GlobalDeviousActionBelt.GetValue() as int)
        toggleDeviousBoots = AddToggleOption("Action - Add Boots (" + arcs_Utility.GetTimesUsed("ArcbotAddSlaveBoots", thePlayer) + ")", config.arcs_GlobalDeviousActionBoots.GetValue() as int)
        toggleDeviousBlindfold = AddToggleOption("Action - Add Blindfold (" + arcs_Utility.GetTimesUsed("ArcbotAddBlindfold", thePlayer) + ")", config.arcs_GlobalDeviousActionBlindfold.GetValue() as int)
        toggleDeviousCollar = AddToggleOption("Action - Add Collar (" + arcs_Utility.GetTimesUsed("ArcbotAddCollar", thePlayer) + ")", config.arcs_GlobalDeviousActionCollar.GetValue() as int)
        toggleDeviousCorset = AddToggleOption("Action - Add Corset (" + arcs_Utility.GetTimesUsed("ArcbotAddCorset", thePlayer) + ")", config.arcs_GlobalDeviousActionCorset.GetValue() as int)
        toggleDeviousGag = AddToggleOption("Action - Add Gag (" + arcs_Utility.GetTimesUsed("ArcbotAddGag", thePlayer) + ")", config.arcs_GlobalDeviousActionGag.GetValue() as int)
        toggleDeviousGloves = AddToggleOption("Action - Add Gloves (" + arcs_Utility.GetTimesUsed("ArcbotAddSlaveGloves", thePlayer) + ")", config.arcs_GlobalDeviousActionGloves.GetValue() as int)
        toggleDeviousHarness = AddToggleOption("Action - Add Harness (" + arcs_Utility.GetTimesUsed("ArcbotAddHarness", thePlayer) + ")", config.arcs_GlobalDeviousActionHarness.GetValue() as int)
        toggleDeviousHood = AddToggleOption("Action - Add Hood (" + arcs_Utility.GetTimesUsed("ArcbotAddHood", thePlayer) + ")", config.arcs_GlobalDeviousActionHood.GetValue() as int)
        toggleDeviousNPiercing = AddToggleOption("Action - Add Nipple Piercing (" + arcs_Utility.GetTimesUsed("ArcbotAddNipplePiercing", thePlayer) + ")", config.arcs_GlobalDeviousActionNPiercing.GetValue() as int)
        toggleDeviousVPiercing = AddToggleOption("Action - Add Vaginal Piercing (" + arcs_Utility.GetTimesUsed("ArcbotAddVaginalPiercing", thePlayer) + ")", config.arcs_GlobalDeviousActionVPiercing.GetValue() as int)
        toggleDeviousAPlug = AddToggleOption("Action - Add Anal Plug (" + arcs_Utility.GetTimesUsed("ArcbotAddAnalPlug", thePlayer) + ")", config.arcs_GlobalDeviousActionAPlug.GetValue() as int)
        toggleDeviousVPlug = AddToggleOption("Action - Add Vaginal Plug (" + arcs_Utility.GetTimesUsed("ArcbotAddVaginalPlug", thePlayer) + ")", config.arcs_GlobalDeviousActionVPlug.GetValue() as int)
        


    else
        AddTextOption("Devious Devices Not installed", "")
    endif

endfunction

function DisplaySlavery()

    AddHeaderOption("Submission & Slavery")
    AddHeaderOption("")

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1

        toggleSubmissionAndSlavery = AddToggleOption("Use Submission & Slavery System", config.arcs_GlobalUseSubmissionAndSlavery.GetValue() as int)

        ;PRMOPT or this for testing
        ; {# submission and slavery system #}
        ; {% if sex_info.sub_and_slave == 1 %}

        ;     - Slavery is a legal system in Skyrim. It is widespread and commonplace.
        ;     - Slaves are both owned for work and for pleasure.
        ;     - Free people of Skyrim mostly ignore slaves but are happy to take their coin for business.
        ;     - Slave owners will discuss slavery as a business venture.

        ;     {% if is_in_faction(npc.UUID, "Arcane Sexbot In Submission And Slavery Faction") %}

        ;         {% if is_in_faction(npc.UUID, "Arcane Sexbot Master Faction") %}
        ;         - {{ actor_name }} is a slave owner, often refered to as Master or Mistress.
        ;         - {{ actor_name }} exercises control over the day to day of life of owned slaves.
        ;         - {{ actor_name }} might use owned slaves for sexual puproses.
        ;         - {{ actor_name }} might develop a rules system for owned slaves.
        ;         - {{ actor_name }} might bind and confine owned slaves.
        ;         {% endif %}

        ;         {% if is_in_faction(npc.UUID, "Arcane Sexbot Head Slave Faction") %}

        ;         {% endif %}

        ;         {% if is_in_faction(npc.UUID, "Arcane Sexbot Slave Faction") %}

        ;         {% endif %}

        ;         {% if is_in_faction(npc.UUID, "Arcane Sexbot Dominant Faction") %}

        ;         {% endif %}

        ;         {% if is_in_faction(npc.UUID, "Arcane Sexbot Switch Faction") %}

        ;         {% endif %}

        ;         {% if is_in_faction(npc.UUID, "Arcane Sexbot Submissive Faction") %}

        ;         {% endif %}

        ;         {% if responseTarget %}
        ;             {% set npc_sas_group_id = get_faction_rank(npc.UUID, "Arcane Sexbot In Submission And Slavery Faction") %}

        ;         {% endif %}

        ;     {% endif %}

        ; {% endif %}


    else
        AddTextOption("Devious Devices Not installed", "")
    endif

endfunction

event OnOptionMenuOpen(int option)

    if option == actorCountMenu
        SetMenuDialogOptions(actorCountArr)
        SetMenuDialogStartIndex(actorCountArr.Find("" + selectedActorCount))

    elseif option == selectSlPageMenu
        SetMenuDialogOptions(slPagesArr)
        SetMenuDialogStartIndex(slPagesArr.Find("" + selectedSlPage))

    endif

endevent

event OnOptionMenuAccept(int option, int index)

    if option == actorCountMenu
        selectedActorCount = index + 1
        selectedSlPage = 1 ;go back to the first page
        SetMenuOptionValue(actorCountMenu, index + 1)
        ForcePageReset()

    elseif option == selectSlPageMenu
        selectedSlPage = index + 1
        SetMenuOptionValue(selectSlPageMenu, index + 1)
        ForcePageReset() 

    endif

endevent

event OnOptionSelect(int option)

    ;globals
    if option == toggleShowSexConfirm
        SetToggleOptionValue(option, toggleGlobalOnOff(arcs_GlobalShowSexConfirm))
    elseif option == toggleActionStartSex
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionStartSex))
    elseif option == toggleActionStripTarget
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionStripTarget))
    elseif option == toggleActionDressTarget
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDressTarget))
    elseif option == toggleActionUndress
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionUndress))
    elseif option == toggleActionDress
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDress))
    elseif option == toggleActionDecreaseArousal
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDecreaseArousal))
    elseif option == toggleActionIncreaseArousal
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionIncreaseArousal))
    elseif option == toggleActionAllDevious
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionAllDevious))
    elseif option == toggleActionDeviousEquips
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDeviousEquips))
    elseif option == toggleDeviousConfirm
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousConfirm))
    elseif option == toggleUseSexualityInCheck
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseSexualityCheck))
    elseif option == toggleAttractionSystem
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseAttractionSystem))
    elseif option == toggleAttractionSeeding
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseAttractionSeed))
    elseif option == toggleActionDecreaseAttraction
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDecreaseAttraction))
    elseif option == toggleActionIncreaseAttraction
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionIncreaseAttraction))
    elseif option == toggleActionStartThreePerson
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionStartThreePersonSex))
    elseif option == toggleActionStartMasturbation
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionStartMasturbation))
    elseif option == toggleActionKiss
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionKiss))
    elseif option == toggleUseArousal
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseArousal))
    elseif option == toggleSubmissionAndSlavery
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseSubmissionAndSlavery))
    elseif option == toggleUseOstim
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseOstim))
    elseif option == toggleUseSexLab
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseSexLab))


    elseif option == toggleDeviousShocks
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionShock))
    elseif option == toggleDeviousStartVibration
         SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionVibration))       
    elseif option == toggleDeviousStopVibration
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionStopVibration))
    elseif option == toggleDeviousArmbinder
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionBinder))
    elseif option == toggleDeviousBelt
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionBelt))
    elseif option == toggleDeviousBoots
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionBoots))
    elseif option == toggleDeviousBlindfold
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionBlindfold))
    elseif option == toggleDeviousCollar
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionCollar))
    elseif option == toggleDeviousCorset
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionCorset))
    elseif option == toggleDeviousGag
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionGag))
    elseif option == toggleDeviousGloves
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionGloves))
    elseif option == toggleDeviousHarness
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionHarness))
    elseif option == toggleDeviousHood
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionHood))
    elseif option == toggleDeviousNPiercing
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionNPiercing))
    elseif option == toggleDeviousVPiercing
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionVPiercing))
    elseif option == toggleDeviousAPlug
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionAPlug))
    elseif option == toggleDeviousVPlug
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousActionVPlug))



    endif

    if option == hotkeyModifierOption
        int currentModifier = arcs_GlobalModifierKey.GetValue() as int
        int newModifier = AdvanceModifierValue(currentModifier)
        arcs_GlobalModifierKey.SetValue(newModifier)
        SetTextOptionValue(option, GetModifierString(newModifier))

    endif

    if option == toggleClearDhlp
        if ShowMessage("Clear DHLP event? WARNING: another mod could be running a long process and clearing DHLP could have undesirable impacts.", true, "$Yes", "$No")
            arcs_Main.EndDhlp()
            ForcePageReset()
        endif
    endif

endevent

int function toggleGlobalOnOff(GlobalVariable g)
    int newValue
    if g.GetValue() == 1
        g.SetValue(0)
        newValue = 0
    else
        g.SetValue(1)
        newValue = 1
    endif
    return newValue
endfunction

string function GlobalOnOffToString(GlobalVariable g)
    string result = "N/A"
    if g.GetValue() == 0
        result = "No"
    elseif g.GetValue() == 1
        result = "Yes"
    endif
    return result
endfunction

string function GlobalDetectionString(GlobalVariable g)
    string result = "Detecting..."
    if g.GetValue() == 2
        result = "No"
    elseif g.GetValue() == 1
        result = "Yes"
    endif
    return result
endfunction

event OnOptionSliderOpen(Int option)

    if option == sliderArousalForSex
        SetSlider(arcs_GlobalArousalForSex.GetValue(), 50, 1, 100, 1)

    elseif option == sliderSlightlyAroused
        SetSlider(arcs_GlobalSlightlyAroused.GetValue(), 30, 0, 100, 1)

    elseif option == sliderVeryAroused
        SetSlider(arcs_GlobalVeryAroused.GetValue(), 70, 0, 100, 1)

    elseif option == sliderSlightlyAttracted
        SetSlider(config.arcs_GlobalSlightlyAttracted.GetValue(), 30, 0, 100, 1)

    elseif option == sliderVeryAttracted
        SetSlider(config.arcs_GlobalVeryAttracted.GetValue(), 70, 0, 100, 1)

    endif

endevent

function SetSlider(float start, int default, int min, int max, int interval)
    SetSliderDialogStartValue(start)
    SetSliderDialogDefaultValue(default)
    SetSliderDialogRange(min, max)
    SetSliderDialogInterval(interval)
endfunction

event OnOptionSliderAccept(Int option, Float value)

    if option == sliderArousalForSex
        arcs_GlobalArousalForSex.SetValue(value as int)
    elseif option == sliderSlightlyAroused
        arcs_GlobalSlightlyAroused.SetValue(value as int)
    elseif option == sliderVeryAroused
        arcs_GlobalVeryAroused.SetValue(value as int)
    elseif option == sliderSlightlyAttracted
        config.arcs_GlobalSlightlyAttracted.SetValue(value as int)
    elseif option == sliderVeryAttracted
        config.arcs_GlobalVeryAttracted.SetValue(value as int)

    endif

    SetSliderOptionValue(option, value, "{0}")  

endevent

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)

	bool continue = true
	if (conflictControl != "" && keyCode != 1)
		string msg
		if (conflictControl != "")
			msg = "This key is mapped to:\n'" + conflictControl + "'\n(" + conflictName + ")\n\nDo you want to continue?"
		else
			msg = "This key is mapped to:\n'" + conflictControl + "'\n\nDo you want to continue?"
		endIf
		continue = ShowMessage(msg, true, "$Yes", "$No")
	endIf

	; clear if escape key
	if (keyCode == 1)
		keyCode = -1
	endIf

	if (continue)
        if option == hotkeyKeymapOption
            main.ChangeHotkey(keyCode)
            RegisterForKey(keyCode)
            SetKeyMapOptionValue(hotkeyKeymapOption, keyCode)
        endif
    endif

endevent

string function GetModifierString(int modifierValue)
    string modifierStr = "None"
    if modifierValue == keyCodeLeftAlt
        modifierStr = "Left Alt"
    elseif modifierValue == keyCodeRightAlt
        modifierStr = "Right Alt"
    elseif modifierValue == keyCodeLeftShift
        modifierStr = "Left Shift"
    elseif modifierValue == keyCodeRightShift
        modifierStr = "Right Shift"
    elseif modifierValue == keyCodeRightControl
        modifierStr = "Right Control"
    endif
    return modifierStr
endfunction

int function AdvanceModifierValue(int currentModifier)
    int newModifier = 0
    if currentModifier == 0
        newModifier = keyCodeLeftAlt
    elseif currentModifier == keyCodeLeftAlt
        newModifier = keyCodeRightAlt
    elseif currentModifier == keyCodeRightAlt
        newModifier = keyCodeLeftShift
    elseif currentModifier == keyCodeLeftShift
        newModifier = keyCodeRightShift
    elseif currentModifier == keyCodeRightShift
        newModifier = keyCodeRightControl
    elseif currentModifier == keyCodeRightControl
        newModifier = 0
    endif
    return newModifier
endfunction

GlobalVariable property arcs_GlobalArousalForSex auto
GlobalVariable property arcs_GlobalSlightlyAroused auto
GlobalVariable property arcs_GlobalVeryAroused auto
GlobalVariable property arcs_GlobalShowSexConfirm auto

GlobalVariable property arcs_GlobalHotkey auto
GlobalVariable property arcs_GlobalModifierKey auto

arcs_Main property main auto
arcs_ConfigSettings property config auto
arcs_Data property gdata auto