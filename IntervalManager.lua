Safeguard_IntervalManager = {
  DangerousEnemiesVariables = {
    DangerousNpcs = nil,
    DangerousNpcsNearby = nil,
    IntervalsSinceLastVariableUpdate = nil,
    LastNpcIndexChecked = nil,
    PlayerAreaId = nil,
    PlayerFaction = nil,
    PlayerLevel = nil,
    PlayerOnTaxi = nil,
    TargetActionWasForbidden = nil,
    UIParentAddonActionForbiddenEventUnregistered = nil,
  }
}

local IM = Safeguard_IntervalManager

local groupUnitIds = { "player" }
for i = 1, 40 do
  if i <= 4 then
    groupUnitIds[#groupUnitIds + 1] = "party" .. i
  end
  groupUnitIds[#groupUnitIds + 1] = "raid" .. i
end

function IM:CheckCombatInterval()
  local shouldUpdateRaidFrames = false
  for i = 1, #groupUnitIds do
    local guid = UnitGUID(groupUnitIds[i])
    if (guid and
        UnitIsConnected(groupUnitIds[i]) and
        (not Safeguard_PlayerStates[guid] or
        not Safeguard_PlayerStates[guid].ConnectionInfo or
        not Safeguard_PlayerStates[guid].ConnectionInfo.IsConnected)) then
      local isInCombat = UnitAffectingCombat(groupUnitIds[i])
      if (not Safeguard_PlayerStates[guid]) then
        Safeguard_PlayerStates[guid] = PlayerState.New(nil, isInCombat)
      else
        if (isInCombat ~= Safeguard_PlayerStates[guid].IsInCombat) then
          shouldUpdateRaidFrames = true

          if (isInCombat) then
            Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName(groupUnitIds[i]), SgEnum.NotificationType.EnteredCombat)
          end
        end

        Safeguard_PlayerStates[guid].IsInCombat = isInCombat
      end
    end
	end

  if (shouldUpdateRaidFrames) then
    Safeguard_RaidFramesManager:UpdateRaidFrames()
  end
  
  C_Timer.After(5, function()
    IM:CheckCombatInterval()
  end)
end

function IM:CheckDangerousEnemiesInterval()
  if (not Safeguard_Settings.Options.EnableDangerousNpcAlerts or not Safeguard_NpcDatabase) then
    return
  end

  if (IM.DangerousEnemiesVariables.IntervalsSinceLastVariableUpdate == nil or IM.DangerousEnemiesVariables.IntervalsSinceLastVariableUpdate >= 100) then
    IM:UpdateVariablesForCheckingDangerousEnemies()
  end

  if (not IM.DangerousEnemiesVariables.PlayerOnTaxi and IM.DangerousEnemiesVariables.DangerousNpcs and #IM.DangerousEnemiesVariables.DangerousNpcs > 0) then
    local indexToCheck
    if (IM.DangerousEnemiesVariables.LastNpcIndexChecked == nil or IM.DangerousEnemiesVariables.LastNpcIndexChecked >= #IM.DangerousEnemiesVariables.DangerousNpcs) then
      indexToCheck = 1
    else
      indexToCheck = IM.DangerousEnemiesVariables.LastNpcIndexChecked + 1
    end

    local npc = IM.DangerousEnemiesVariables.DangerousNpcs[indexToCheck]

    IM.DangerousEnemiesVariables.TargetWasForbidden = false
    TargetUnit(npc.name)

    if (IM.DangerousEnemiesVariables.TargetWasForbidden) then
      if (not IM.DangerousEnemiesVariables.DangerousNpcsNearby[npc.name]) then
        IM.DangerousEnemiesVariables.DangerousNpcsNearby[npc.name] = npc
        Safeguard_DangerousNpcsWindow:Update(IM.DangerousEnemiesVariables.DangerousNpcsNearby)

        if (Safeguard_Settings.Options.EnableDangerousNpcAlertSounds) then
          Safeguard_EventManager:PlaySound("alert1")
        end
      end
    else
      if (IM.DangerousEnemiesVariables.DangerousNpcsNearby[npc.name]) then
        IM.DangerousEnemiesVariables.DangerousNpcsNearby[npc.name] = nil
        Safeguard_DangerousNpcsWindow:Update(IM.DangerousEnemiesVariables.DangerousNpcsNearby)
      end
    end

    IM.DangerousEnemiesVariables.LastNpcIndexChecked = indexToCheck
  end

  IM.DangerousEnemiesVariables.IntervalsSinceLastVariableUpdate = IM.DangerousEnemiesVariables.IntervalsSinceLastVariableUpdate + 1

  C_Timer.After(0.02, function()
    IM:CheckDangerousEnemiesInterval()
  end)
end

function IM:UpdateVariablesForCheckingDangerousEnemies()
  if (not IM.DangerousEnemiesVariables.UIParentAddonActionForbiddenEventUnregistered) then
    UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN")
    IM.DangerousEnemiesVariables.UIParentAddonActionForbiddenEventUnregistered = true
  end

  IM.DangerousEnemiesVariables.IntervalsSinceLastVariableUpdate = 0

  local playerUiMapID = C_Map.GetBestMapForUnit("player")
  local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()
  if (not Safeguard_ZoneDatabase[playerUiMapID] or type ~= "none") then
    IM.DangerousEnemiesVariables.DangerousNpcs = nil
    IM.DangerousEnemiesVariables.DangerousNpcsNearby = nil
    IM.DangerousEnemiesVariables.PlayerAreaId = nil
    IM.DangerousEnemiesVariables.PlayerLevel = nil
    IM.DangerousEnemiesVariables.PlayerFaction = nil
  else
    local oldPlayerAreaId = IM.DangerousEnemiesVariables.PlayerAreaId
    IM.DangerousEnemiesVariables.PlayerAreaId = Safeguard_ZoneDatabase[playerUiMapID].AreaId

    local oldPlayerLevel = IM.DangerousEnemiesVariables.PlayerLevel
    IM.DangerousEnemiesVariables.PlayerLevel = UnitLevel("player")

    if (not IM.DangerousEnemiesVariables.PlayerFaction) then
      IM.DangerousEnemiesVariables.PlayerFaction = UnitFactionGroup("player")
    end

    IM.DangerousEnemiesVariables.PlayerOnTaxi = UnitOnTaxi("player")

    if (oldPlayerAreaId ~= IM.DangerousEnemiesVariables.PlayerAreaId or oldPlayerLevel ~= IM.DangerousEnemiesVariables.PlayerLevel) then
      IM.DangerousEnemiesVariables.DangerousNpcs = {}
      IM.DangerousEnemiesVariables.DangerousNpcsNearby = {}

      for npcId, npc in pairs(Safeguard_NpcDatabase) do
        if (npc.location and npc.react) then
          local locationIsMatch = false
          for _, npcAreaId in pairs(npc.location) do
            if (IM.DangerousEnemiesVariables.PlayerAreaId == npcAreaId) then locationIsMatch = true end
          end

          if (locationIsMatch) then
            local npcIsUnfriendly = false
            if ((IM.DangerousEnemiesVariables.PlayerFaction == "Alliance" and (npc.react[1] == 0 or npc.react[1] == -1)) or 
                (IM.DangerousEnemiesVariables.PlayerFaction == "Horde" and (npc.react[2] == 0 or npc.react[2] == -1))) then
              npcIsUnfriendly = true
            end

            if (npcIsUnfriendly and npc.maxlevel and
                (npc.maxlevel >= IM.DangerousEnemiesVariables.PlayerLevel + Safeguard_Settings.Options.DangerousNpcNormalLevelOffset or (npc.classification > 0 and npc.maxlevel >= IM.DangerousEnemiesVariables.PlayerLevel + Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset))) then
              table.insert(IM.DangerousEnemiesVariables.DangerousNpcs, npc)
              --print(npcId .. ": " .. npc.name)
            end
          end
        end
      end
      --print("Total: " .. #IM.DangerousEnemiesVariables.DangerousNpcs)
    end
  end
end

function IM:CheckGroupConnectionsInterval()
  local playerGuid = UnitGUID("player")
  if (Safeguard_PlayerStates[playerGuid] and
      Safeguard_PlayerStates[playerGuid].ConnectionInfo and
      Safeguard_PlayerStates[playerGuid].ConnectionInfo.IsConnected == true) then

    for i = 1, #groupUnitIds do
      local guid = UnitGUID(groupUnitIds[i])
      if (guid and
          not UnitIsConnected(groupUnitIds[i]) and
          Safeguard_PlayerStates[guid]) then
        Safeguard_PlayerStates[guid] = nil
        Safeguard_RaidFramesManager:UpdateRaidFrames()
        Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), SgEnum.NotificationType.PlayerOffline, guid)
      end

      if (guid and
          Safeguard_PlayerStates[guid] and
          Safeguard_PlayerStates[guid].ConnectionInfo and
          GetTime() - Safeguard_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp > 13 and
          Safeguard_PlayerStates[guid].ConnectionInfo.IsConnected == true) then
        Safeguard_MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.PlayerConnectionCheck, guid)

        if (guid == playerGuid) then
          C_Timer.After(1, function()
            Safeguard_IntervalManager:CheckPlayerConnectionAndMarkIfDisconnected(guid)
          end)
        end
      end
    end
  end

  C_Timer.After(5, function()
    IM:CheckGroupConnectionsInterval()
  end)
end

function IM:CheckPlayerConnectionAndMarkIfDisconnected(guid)
  if (Safeguard_PlayerStates[guid] and
      Safeguard_PlayerStates[guid].ConnectionInfo and
      GetTime() - Safeguard_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp > 14 and
      Safeguard_PlayerStates[guid].ConnectionInfo.IsConnected == true) then
    Safeguard_PlayerStates[guid].ConnectionInfo.IsConnected = false
    Safeguard_RaidFramesManager:UpdateRaidFrames()
    Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), SgEnum.NotificationType.PlayerDisconnected, guid)
  end
end

function IM:SendHeartbeatInterval()
  local guid = UnitGUID("player")

  local timeSinceLastSentMessage = nil
  if (Safeguard_PlayerStates[guid] and Safeguard_PlayerStates[guid].ConnectionInfo) then
    timeSinceLastSentMessage = GetTime() - Safeguard_PlayerStates[guid].ConnectionInfo.LastMessageTimestamp
  end

  local delay = 10
  if (timeSinceLastSentMessage == nil or timeSinceLastSentMessage >= (10 - 0.01)) then
    Safeguard_MessageManager:SendHeartbeatMessage()
  else
    delay = 10 - timeSinceLastSentMessage
  end
  
  C_Timer.After(delay, function()
    IM:SendHeartbeatInterval()
  end)
end