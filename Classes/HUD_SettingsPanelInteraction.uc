//=============================================================================
// HUD_SettingsPanelInteraction.uc
// Copyright (C) 2021 0xC0ncord <concord@fuwafuwatime.moe>
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
//=============================================================================

class HUD_SettingsPanelInteraction extends Interaction;

function Tick(float dt)
{
    local UT2K4PlayerLoginMenu Menu;

    Menu = UT2K4PlayerLoginMenu(GUIController(ViewportOwner.Actor.Player.GUIController).FindPersistentMenuByName(UnrealPlayer(ViewportOwner.Actor).LoginMenuClass));
    if(Menu != none)
    {
        Menu.c_Main.AddTab("TUR Settings", string(class'TURSettingsPanel'),, "Custom miscellaneous settings");
        Master.RemoveInteraction(self);
    }
}

defaultproperties
{
    bRequiresTick=true
}
