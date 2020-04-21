--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2017-11-24T12:43:51+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GCPlayerAgnostic.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-19T22:04:47+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGDebug")
require("PGStateMachine")
require("PGStoryMode")

CONSTANTS = require("GameConstants")
require("TRGameModeTransactions")

require("TRUtil")
require("GalacticConquest")
require("DisplayManager")
require("CategoryFilter")


function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 0.1

    StoryModeEvents = { Zoom_Zoom = Begin_GC }
end

function Begin_GC(message)
    if message == OnEnter then
        TM = TransactionManager:New()

        local plot = TRUtil.GetPlayerAgnosticPlot()
        GC = GalacticConquest:New(plot, CONSTANTS.PLAYABLE_FACTIONS)

        GC.HumanPlayer.Enable_Advisor_Hints("Galactic",false)
        GC.HumanPlayer.Enable_Advisor_Hints("Space",false)
        GC.HumanPlayer.Enable_Advisor_Hints("Land",false)

        StructureDisplay = OrbitalStructureDisplay:New(GC.Events.SelectedPlanetChanged, GC.Events.GalacticProductionFinished)
        Filter = CategoryFilter:New(plot, GC)

        -- Create_Thread("EventManagerThread")
        Create_Thread("TransactionManagerThread")
        -- Create_Thread("CategoryFilterThread")

      elseif message == OnUpdate then
        GC:Update()
        Filter:Update()
    end
end

function TransactionManagerThread()
    while true do
        TM:ExecuteGameModeTransactions()
        Sleep(1)
    end
end

function CategoryFilterThread()
  while true do
    Filter:Update()
    Sleep(0.1)
  end
end
