//=============================================================================
// MutSettingsPanel.uc
// Copyright (C) 2021 0xC0ncord <concord@fuwafuwatime.moe>
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
//=============================================================================

class MutSettingsPanel extends Mutator;

simulated function Tick(float dt)
{
    local PlayerController PC;

    if(Level.NetMode == NM_DedicatedServer)
    {
        Disable('Tick');
        return;
    }
    PC = Level.GetLocalPlayerController();
    if(PC != none && PC.Player != none && PC.Player.InteractionMaster != none)
    {
        PC.Player.InteractionMaster.AddInteraction(string(class'HUD_SettingsPanelInteraction'), PC.Player);
        Disable('Tick');
    }
}

simulated function Timer()
{
    local Monster M;

    foreach DynamicActors(class'Monster', M)
    {
        if(M.IsA('U1Pawns') && bool(M.GetPropertyText("bHasHorseFlies")))
        {
            M.SetPropertyText("bHasHorseFlies", "False");
        }
    }
}

defaultproperties
{
    FriendlyName=".:TUR:. Settings Panel Helper"
    Description="Used to add the TUR Settings tab to the player login menu."
    bNetTemporary=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
}
