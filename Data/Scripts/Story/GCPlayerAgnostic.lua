
require("PGDebug")
require("PGStateMachine")
require("PGStoryMode")

require("CategoryFilter")


function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 0.1

    StoryModeEvents = { Zoom_Zoom = Begin_GC }
end

function Begin_GC(message)
    if message == OnEnter then

        StructureDisplay = OrbitalStructureDisplay:New(GC.Events.SelectedPlanetChanged, GC.Events.GalacticProductionFinished)
        Filter = CategoryFilter:New(plot, GC)

        -- Create_Thread("EventManagerThread")
        -- Create_Thread("CategoryFilterThread")

      elseif message == OnUpdate then
        GC:Update()
        Filter:Update()
    end
end


function CategoryFilterThread()
  while true do
    Filter:Update()
    Sleep(0.1)
  end
end
