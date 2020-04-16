function StoryUtil.SetTechLevel(player, level)
    if type(player) == "string" then
        player = Find_Player(player)
    end
    local event = StoryUtil.GetGenericEvent()
    event.Set_Reward_Type("SET_TECH_LEVEL")
    event.Set_Reward_Parameter(0, player)
    event.Set_Reward_Parameter(1, level)
    StoryUtil.TriggerGenericEvent()
    StoryUtil.ResetGenericEvent()
end