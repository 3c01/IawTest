-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/UpgradeGroundbasePlan.lua#15 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/UpgradeGroundbasePlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 24353 $
--
--          $DateTime: 2005/08/19 17:54:05 $
--
--          $Revision: #15 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- Now doing groundbase upgrades via base component construction plans
	Category = "AlwaysOff"
	--Category = "Upgrade_Groundbase | Build_Initial_Groundbase_Only"
	IgnoreTarget = true
	TaskForce = {
	{
		"BaseForce",
		"E_Ground_Barracks | R_Ground_Barracks | E_Ground_Light_Vehicle_Factory | R_Ground_Light_Vehicle_Factory | E_Ground_Research_Facility | Communications_Array_E | Communications_Array_R | E_Ground_Heavy_Vehicle_Factory | R_Ground_Heavy_Vehicle_Factory | E_Ground_Officer_Academy | R_Ground_Officer_Academy | E_Ground_Advanced_Vehicle_Factory | Power_Generator_E | Power_Generator_R | ER_Ground_Barracks | GM_Ground_Barracks | ER_Ground_Light_Vehicle_Factory | GM_Ground_Light_Vehicle_Factory  | ER_Ground_Heavy_Vehicle_Factory | GM_Ground_Heavy_Vehicle_Factory | ER_Ground_Officer_Academy | GM_Ground_Officer_Academy | ER_Ground_Advanced_Vehicle_Factory | GM_Ground_Advanced_Vehicle_Factory= 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function BaseForce_Thread()
	DebugMessage("%s -- In BaseForce_Thread.", tostring(Script))
	
	Sleep(1)
	
--	BaseForce.Set_As_Goal_System_Removable(false)
	AssembleForce(BaseForce)
	
	BaseForce.Set_Plan_Result(true)
	DebugMessage("%s -- BaseForce done!", tostring(Script));
	ScriptExit()
end

function BaseForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end