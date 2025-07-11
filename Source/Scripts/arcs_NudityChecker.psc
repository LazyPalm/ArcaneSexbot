Scriptname arcs_NudityChecker extends Quest  

Keyword slaArmorPrettyKeyword
Keyword eroticArmorKeyword
Keyword slaAmorSpendexKeyword
Keyword slaArmorHalfNakedBikniKeyword
Keyword slaArmorHalfNakedKeyword

int Property kSlotMask30 = 0x00000001 AutoReadOnly ; HEAD
int Property kSlotMask31 = 0x00000002 AutoReadOnly ; Hair
int Property kSlotMask32 = 0x00000004 AutoReadOnly ; BODY
int Property kSlotMask33 = 0x00000008 AutoReadOnly ; Hands
int Property kSlotMask34 = 0x00000010 AutoReadOnly ; Forearms
int Property kSlotMask35 = 0x00000020 AutoReadOnly ; Amulet
int Property kSlotMask36 = 0x00000040 AutoReadOnly ; Ring
int Property kSlotMask37 = 0x00000080 AutoReadOnly ; Feet
int Property kSlotMask38 = 0x00000100 AutoReadOnly ; Calves
int Property kSlotMask39 = 0x00000200 AutoReadOnly ; SHIELD
int Property kSlotMask40 = 0x00000400 AutoReadOnly ; TAIL
int Property kSlotMask41 = 0x00000800 AutoReadOnly ; LongHair
int Property kSlotMask42 = 0x00001000 AutoReadOnly ; Circlet
int Property kSlotMask43 = 0x00002000 AutoReadOnly ; Ears

int Property kSlotMask52 = 0x00400000 AutoReadOnly ; ???

event OnInit()

    if self.IsRunning()
        GameLoaded()
    endif

endevent

function GameLoaded()
    LoadKeywords()
endfunction

function LoadKeywords()

    ;TODO - only reload if empty if game loads - for mod list changes
    slaArmorPrettyKeyword = Keyword.GetKeyword("sla_armorpretty")
    eroticArmorKeyword = Keyword.GetKeyword("Eroticarmor")
    slaAmorSpendexKeyword = Keyword.GetKeyword("sla_armorspendex")
    slaArmorHalfNakedBikniKeyword = Keyword.GetKeyword("sla_armorhalfnakedbikini")
    slaArmorHalfNakedKeyword = Keyword.GetKeyword("sla_armorhalfnaked")

endfunction

bool function BakaChecks(Actor a)

    bool found = false

    if slaArmorPrettyKeyword != none && !found
        if a.WornHasKeyword(slaArmorPrettyKeyword)
            found = true
        endif
    endif

    if eroticArmorKeyword != none && !found
        if a.WornHasKeyword(eroticArmorKeyword)
            found = true
        endif
    endif

    if slaAmorSpendexKeyword != none && !found
        if a.WornHasKeyword(slaAmorSpendexKeyword)
            found = true
        endif
    endif

    if slaArmorHalfNakedBikniKeyword != none && !found
        if a.WornHasKeyword(slaArmorHalfNakedBikniKeyword)
            found = true
        endif
    endif

    if slaArmorHalfNakedKeyword != none && !found
        if a.WornHasKeyword(slaArmorHalfNakedKeyword)
            found = true
        endif
    endif

    return found

endfunction

int function NUDITYCHECK_ACTOR_NUDE()
    return 0
endfunction

int function NUDITYCHECK_ACTOR_DRESSED_SKIMPY()
    return 1
endfunction

int function NUDITYCHECK_ACTOR_DRESSED()
    return 2
endfunction

int function NudityCheck(Actor a)

    if a == none
        arcs_Utility.WriteInfo("Nudity check - none actor sent, exiting")
        return -1
    endif

    ;-1 - failure
    ;0 - nude
    ;1 - skimpy
    ;2 - dressed

    int result = 0

    bool clothingArmorResult = (a.WornHasKeyword(ArmorCuirass) || a.WornHasKeyword(ClothingBody))
    bool bakaResult = BakaChecks(a)

    ;arcs_Utility.WriteInfo("clothingArmorResult: " + clothingArmorResult + " bakaResult: " + bakaResult)

    if !clothingArmorResult && !bakaResult
        ;slot 32/52 check
        if a.GetWornForm(kSlotMask32)
            result = 2
            ;arcs_Utility.WriteInfo("Slot 32 found")
        Else
            if a.GetWornForm(kSlotMask52)
                result = 1 ;topless
                ;arcs_Utility.WriteInfo("Slot 52 found")
            endif
        endif
    elseif bakaResult
        result = 1
    elseif clothingArmorResult
        result = 2
    else
        ;no changes
    endif

    return result

endfunction

Keyword property ArmorCuirass auto
Keyword property ClothingBody auto
