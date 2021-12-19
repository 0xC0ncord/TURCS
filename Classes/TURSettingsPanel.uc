//=============================================================================
// TURSettingsPanel.uc
// Copyright (C) 2021 0xC0ncord <concord@fuwafuwatime.moe>
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
//=============================================================================

class TURSettingsPanel extends MidGamePanel;

var() automated GUISectionBackground sb_Main;
var() automated GUISectionBackground sb_Description;
var() automated GUIMultiOptionListBox currentScrollContainer;
var() automated GUIScrollTextBox descriptionTextBox;
var() automated moCheckBox bAllowMotionBlur;
var() automated moCheckBox bAllowKAddImpulse;
var() automated moCheckBox bU1PawnsSpawnHorseFlies;
var() localized string Text_Intro;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
    Super.InitComponent(InController, InOwner);

    bAllowMotionBlur = moCheckBox(currentScrollContainer.List.AddItem("XInterface.moCheckBox",, "Enable Motion Blur", true));
    bAllowMotionBlur.ToolTip.SetTip("Check this box to enable native motion blur effects. The native code behind this is known to be buggy on older hardware configurations and driver versions. If you experience frequent crashes whenever these effects are supposed to occur, try disabling this.");
    bAllowMotionBlur.ToolTip.StyleName = "";
    bAllowMotionBlur.__OnClick__Delegate = InternalOnClick;

    bAllowKAddImpulse = moCheckBox(currentScrollContainer.List.AddItem("XInterface.moCheckBox",, "Enable KAddImpulse", true));
    bAllowKAddImpulse.ToolTip.SetTip("Check this box to enable most KAddImpulse calls. Some objects like Gravity Vortexes, for graphical enhancements, will apply forces to objects in an active karma physics state. The native code behind this is known to be buggy on older hardware configurations and driver versions. If you experience frequent crashes whenever these effects are supposed to occur, try disabling this.");
    bAllowKAddImpulse.ToolTip.StyleName = "";
    bAllowKAddImpulse.__OnClick__Delegate = InternalOnClick;

    bU1PawnsSpawnHorseFlies = moCheckBox(currentScrollContainer.List.AddItem("XInterface.moCheckBox",, "Enable U1Pawns Horse Flies", true));
    bU1PawnsSpawnHorseFlies.ToolTip.SetTip("Check this box to allow derivates of U1Pawns monsters to spawn horse flies when dead. Due to a programming oversight, dead U1Pawns monsters that linger for long periods of time can spawn multiple swarms of horse flies, which may significantly impact performance. If you experience any performance degradation as a result of the horse flies effects, try disabling this.");
    bU1PawnsSpawnHorseFlies.ToolTip.StyleName = "";
    bU1PawnsSpawnHorseFlies.__OnClick__Delegate = InternalOnClick;

    SetDefaultComponent(bAllowMotionBlur);
    SetDefaultComponent(bAllowKAddImpulse);
    SetDefaultComponent(bU1PawnsSpawnHorseFlies);

    descriptionTextBox.MyScrollText.SetContent(Text_Intro);

    Initialize();
}

function Initialize()
{
    bAllowMotionBlur.SetComponentValue(class'TURSettings'.default.bAllowMotionBlur);
    bAllowKAddImpulse.SetComponentValue(class'TURSettings'.default.bAllowKAddImpulse);
    bU1PawnsSpawnHorseFlies.SetComponentValue(class'TURSettings'.default.bU1PawnsSpawnHorseFlies);
}

function SetDefaults()
{
    bAllowMotionBlur.SetComponentValue(false);
    bAllowKAddImpulse.SetComponentValue(false);
    bU1PawnsSpawnHorseFlies.SetComponentValue(false);
}

function SaveSettings()
{
    local MutSettingsPanel M;

    class'TURSettings'.default.bAllowMotionBlur = bAllowMotionBlur.IsChecked();
    class'TURSettings'.default.bAllowKAddImpulse = bAllowKAddImpulse.IsChecked();
    class'TURSettings'.default.bU1PawnsSpawnHorseFlies = bU1PawnsSpawnHorseFlies.IsChecked();
    class'TURSettings'.static.StaticSaveConfig();

    foreach PlayerOwner().DynamicActors(class'MutSettingsPanel', M)
    {
        if(M != none)
        {
            if(bU1PawnsSpawnHorseFlies.IsChecked())
            {
                M.SetTimer(1.0, true);
            }
            else
            {
                M.SetTimer(0.0, false);
            }
            break;
        }
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    if(moCheckBox(Sender) != none)
    {
        descriptionTextBox.MyScrollText.SetContent(moCheckBox(Sender).ToolTip.Text);
    }
    if(GUICheckBoxButton(Sender) != none)
    {
        SaveSettings();
    }
    return true;
}

function SetDefaultComponent(GUIMenuOption PassedComponent)
{
    PassedComponent.CaptionWidth = 0.80;
    PassedComponent.ComponentWidth = 0.20;
    PassedComponent.ComponentJustification = TXTA_Center;
    PassedComponent.bStandardized = false;
    PassedComponent.bBoundToParent = false;
    PassedComponent.bScaleToParent = false;

    if(PassedComponent.MyLabel != none)
    {
        PassedComponent.MyLabel.TextAlign = TXTA_Left;
    }
}

function InternalOnCreateComponent(GUIComponent NewComp, GUIComponent Sender)
{
    if(currentScrollContainer == Sender)
    {
        if(currentScrollContainer.List != none)
        {
            currentScrollContainer.List.ColumnWidth = 0.450;
            currentScrollContainer.List.bVerticalLayout = true;
            currentScrollContainer.List.bHotTrack = true;
        }
    }
}

defaultproperties
{
    Begin Object Name=InternalFrameImageMain class=AltSectionBackground
        Caption="Settings List"
        WinTop=0.0204380
        WinLeft=0.0236250
        WinWidth=0.9448750
        WinHeight=0.647190
        bScaleToParent=true
    End Object
    sb_Main=AltSectionBackground'InternalFrameImageMain'

    Begin Object Name=InternalFrameImageDescription class=AltSectionBackground
        Caption="Setting Description"
        WinTop=0.6799040
        WinLeft=0.0551250
        WinWidth=0.8818750
        WinHeight=0.2443150
        bScaleToParent=true
    End Object
    sb_Description=AltSectionBackground'InternalFrameImageDescription'

    Begin Object Name=MyRulesList class=GUIMultiOptionListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=InternalOnCreateComponent
        StyleName="ServerBrowserGrid"
        WinTop=0.0716690
        WinLeft=0.1337670
        WinWidth=0.7147410
        WinHeight=0.5423730
        bBoundToParent=true
        bScaleToParent=true
    End Object
    currentScrollContainer=GUIMultiOptionListBox'MyRulesList'

    Begin Object Name=descTextBox class=GUIScrollTextBox
        CharDelay=0.001250
        EOLDelay=0.001250
        OnCreateComponent=InternalOnCreateComponent
        FontScale=0
        WinTop=0.7299410
        WinLeft=0.0807450
        WinWidth=0.8351150
        WinHeight=0.1342130
        bNeverFocus=true
    End Object
    descriptionTextBox=GUIScrollTextBox'descTextBox'

    Text_Intro="Select a setting and see here for detailed information on it."
}
