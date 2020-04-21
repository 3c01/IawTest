--//////////////////////////////////////////////////////////////////////////////////
-- Spawn pirate units randomly
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")




function Definitions()

DebugMessage("%s -- In Definitions", tostring(Script))
--Define_State("State_Init", State_Init);
invaders = Find_Player("Hutts")
--attack_chance = 0

StoryModeEvents = { Battle_Start = State_Init,
			SWITCH_CONTROL_None1=Remove_Huttlist,
			SWITCH_CONTROL_None2 =Remove_Huttlist,
			SWITCH_CONTROL_None3 =Remove_Huttlist,
			SWITCH_CONTROL_None4 =Remove_Huttlist, 
			SWITCH_CONTROL_None5 =Remove_Huttlist,
			SWITCH_CONTROL_None6 =Remove_Huttlist,
			SWITCH_CONTROL_None7 =Remove_Huttlist,
			SWITCH_CONTROL_None8 =Remove_Huttlist,
			Retreat_Complete =Remove_Huttlist
		 }

defender = nil
attacker = nil




end


function State_Init(message)
if message == OnEnter then


starbases = { {"Rebel_Star_Base_1","Rebel_Star_Base_2","Rebel_Star_Base_3"},
{"Empire_Star_Base_1","Empire_Star_Base_2","Empire_Star_Base_3"},
{"Underworld_Star_Base_1", "Underworld_Star_Base_2", "Underworld_Star_Base_3"},
{"Zsinj_Star_Base_1", "Zsinj_Star_Base_2", "Zsinj_Star_Base_3"},
{"Pentastar_Star_Base_1", "Pentastar_Star_Base_2", "Pentastar_Star_Base_3"},
{"Hapan_Star_Base_1", "Hapan_Star_Base_2"}
}


factions = {"Rebel", "Empire", "Underworld", "Pirates", "Pentastar", "Sarlacc"}
unit_types = {{"Corellian_Corvette", "MC80b", "MC40a", "Dreadnaught_Rebel"}, {"Lancer_Frigate", "Carrack_Cruiser", "Imperial_Star_Destroyer_Two", "Victory_Destroyer_Mark_1"}, {"Asdoni", "Kariek_Shieldship", "Warlord", "Chiss_Star_Destroyer"}, {"Zsinj_Star_Destroyer", "Zsinj_Nebulon_B_Frigate", "Zsinj_Corellian_Corvette", "Zsinj_Star_Destroyer_Two"}, {"Enforcer", "Venator_Pentastar", "Munificent", "ISD_I_Pentastar"}, {"Nova_Cruiser", "BattleDragon"}}



-- Defender
for i, sub in pairs(starbases) do
for k, base in pairs(sub) do
if Find_First_Object(base) then
table.remove(factions, i)
table.remove(unit_types, i)
found_base = true
break


end
if Find_First_Object(base) == nil then
if i==table.getn(starbases) then
if k == table.getn(sub) then
Game_Message("TEXT_STRANGE_SIGNAL")
ScriptExit()
end
end
end

end
if found_base then
break
end

end


-- Attacker
for j, faction in pairs(factions) do
if table.getn(Find_All_Objects_Of_Type(Find_Player(faction))) > 0 then
table.remove(factions, j)
table.remove(unit_types, j)
break
end
end

raider = GameRandom(1,3)


entry = Find_First_Object("Attacker Entry Position")
moveto = Find_First_Object("Space Station Position")
Random_Spawn(unit_types[raider], invaders, entry, moveto, 100, 5)

end
end


function Random_Spawn(unit_list, faction, spawnpoint, target, probability, max_ship_number)
if type(unit_list) == "table" then

attack_chance = GameRandom(1,100)
anzahl = GameRandom(3,max_ship_number)
spawnliste = {}
count = 0


if attack_chance <= 20 then
	repeat
		einheit = GameRandom(1,table.getn(unit_list))
		table.insert(spawnliste, unit_list[einheit])
		count = count + 1
	until count == anzahl
	
	
	
	if factions[raider] == "Rebel" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")

	elseif factions[raider] == "Empire" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")

	elseif factions[raider] == "Underworld" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")
	elseif factions[raider] == "Pirates" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")
	elseif factions[raider] == "Pentastar" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")
	elseif factions[raider] == "Yevetha" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")
	elseif factions[raider] == "Sarlacc" then
		Sleep(10)
		Game_Message("TEXT_DETECTED_FLEET")

	end

	Sleep(90)

	huttlist = SpawnList(spawnliste,spawnpoint,faction,true,true)
	Sleep(20)


attack_chance = 0
else
ScriptExit()


end
end


end



function Remove_Huttlist(message)
	if message == OnEnter then
		for j, unit in pairs(huttlist) do
			Game_Message("TEXT_STRANGE_SIGNAL")
			unit.Despawn()
		end
	end
end