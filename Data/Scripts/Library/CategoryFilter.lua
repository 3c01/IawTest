
require("PGSpawnUnits")
require("Class")

CategoryFilter = Class {

        EventNames = {
            "Filter_Non_Capital",
            "Filter_Capitals",
            "Filter_Structures"
        },

        CategoryFlags = {
            ["SELECT_NON_CAPITAL"] = "Non_Capital_Category_Dummy",
            ["SELECT_CAPITAL"] = "Capital_Category_Dummy",
            ["SELECT_STRUCTURE"] = "Structure_Category_Dummy"
        },

        Placeholder = "Placeholder_Category_Dummy",

        ActiveFilter = "SELECT_NON_CAPITAL",

        SpawnedHumanDummies = {},

        SpawnedAiDummies = {},

        LastAiDummyCheck = nil,

        Constructor = function(self, plot, galacticConquest)
            self.GalacticConquest = galacticConquest
            self.GalacticConquest.Events.SelectedPlanetChanged:AttachListener(self.SpawnCategoryDummy, self)
            self.GalacticConquest.Events.PlanetOwnerChanged:AttachListener(self.OnPlanetOwnerChanged, self)

            for _, eventName in pairs(self.EventNames) do
                local event = plot.Get_Event(eventName)
                if event then
                    event.Set_Reward_Parameter(1, galacticConquest.HumanPlayer.Get_Faction_Name())
                end
            end


            local allPlanets = self.GalacticConquest.Planets
            for _, planet in pairs(allPlanets) do
                self:SpawnAiDummies(planet)
            end

            self.LastAiDummyCheck = GetCurrentTime()
        end,

        Update = function(self)
            self:HandleFilterChange()
            self:RespawnMissingDummies()
        end,

        HandleFilterChange = function (self)
            for categoryFlag, _ in pairs(self.CategoryFlags) do
                if Check_Story_Flag(self.GalacticConquest.HumanPlayer, categoryFlag, nil, true) then
                    if self.ActiveFilter == categoryFlag then
                        break
                    end
                    self.ActiveFilter = categoryFlag
                    self:SpawnCategoryDummy(self.GalacticConquest.GetSelectedPlanet())
                    break
                end
            end
        end,

        OnPlanetOwnerChanged = function(self, planet)
            if not planet then
                return
            end

            self:ClearAiDummies(planet)
            if planet.Get_Owner().Is_Human() then
                if planet == self.GalacticConquest.GetSelectedPlanet() then
                    self:SpawnCategoryDummy(self.GalacticConquest.GetSelectedPlanet())
                end
            else
                self:SpawnAiDummies(planet)
            end
        end,

        RespawnMissingDummies = function(self)
            if (GetCurrentTime() - self.LastAiDummyCheck) < 10 then
                return
            end

            for _, planet in pairs(self.GalacticConquest.Planets) do
                if not planet.Get_Owner().Is_Human() then
                    self:CreateAiEntry(planet)
                    self:RemoveInvalidEntries(self.SpawnedAiDummies[planet])
                    if table.getn(self.SpawnedAiDummies[planet]) == 0 then
                        self:SpawnAiDummies(planet)
                    end
                end
            end

            self.LastAiDummyCheck = GetCurrentTime()
        end,

        RemoveInvalidEntries = function(self, tab)
            for i, object in pairs(tab) do
                if not TestValid(object) then
                    table.remove(tab, i)
                end
            end
        end,

        CreateAiEntry = function(self, planet)
            if not self.SpawnedAiDummies[planet] then
                self.SpawnedAiDummies[planet] = {}
            end
        end,

        SpawnCategoryDummy = function(self, selectedPlanet)
            self:ClearDummies()

            if not selectedPlanet then
                return
            end

            if not selectedPlanet.Get_Owner().Is_Human() then
                return
            end

            if not self.ActiveFilter then
                return
            end

            local typeList = {
                self.CategoryFlags[self.ActiveFilter],
                self.Placeholder,
                self.Placeholder
            }

            local dummies = SpawnList(typeList, selectedPlanet, self.GalacticConquest.HumanPlayer, false, false)
        end,

        SpawnAiDummies = function(self, planet)
            local owner = planet.Get_Owner()
            if owner.Is_Human() or owner == Find_Player("Neutral") then
                return
            end

            --hopefully prevents perception evaluation crashes
            if owner and planet then
                if EvaluatePerception("Has_Starbase", self.GalacticConquest.HumanPlayer, planet) == 0 then
                    return
                end
            end

            self:ClearAiDummies(planet)
            self:CreateAiEntry(planet)

            local typeList = {
                "Non_Capital_Category_Dummy",
                "Capital_Category_Dummy",
                "Structure_Category_Dummy"
            }

            local dummies = SpawnList(typeList, planet, planet.Get_Owner(), false, false)
            for _, dummy in pairs(dummies) do
                table.insert(self.SpawnedAiDummies[planet], dummy)
            end
        end,

        ClearDummies = function(self)
            local dummies = nil
            for _, dummyType in pairs(self.CategoryFlags) do
                dummies = Find_All_Objects_Of_Type(dummyType)
                for _, dummy in pairs(dummies) do
                    if TestValid(dummy) and dummy.Get_Owner().Is_Human() then
                        dummy.Despawn()
                    end
                end
            end

            dummies = Find_All_Objects_Of_Type(self.Placeholder)
            for _, dummy in pairs(dummies) do
                if TestValid(dummy) and dummy.Get_Owner().Is_Human() then
                    dummy.Despawn()
                end
            end
        end,

        ClearAiDummies = function(self, planet)
            if not self.SpawnedAiDummies[planet] then
                return
            end

            for i, dummy in pairs(self.SpawnedAiDummies[planet]) do
                if TestValid(dummy) then
                    dummy.Despawn()
                end
                table.remove(self.SpawnedAiDummies[planet], i)
            end
        end
}

return CategoryFilter
