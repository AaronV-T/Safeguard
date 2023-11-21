Safeguard_Settings = nil

Safeguard_EventManager = {
  DebugLogs = {},
  EventHandlers = {},
  PlayerFlags = {
    Pvp = nil
  },
}

local EM = Safeguard_EventManager

local IntervalManager = Safeguard_IntervalManager
local MessageManager = Safeguard_MessageManager

-- Slash Commands

SLASH_SAFEGUARD1, SLASH_SAFEGUARD2 = "/safeguard", "/sg"
function SlashCmdList.SAFEGUARD()
  InterfaceOptionsFrame_OpenToCategory(Safeguard_OptionWindow)
end

SLASH_SAFEGUARDDEBUG1, SLASH_SAFEGUARDDEBUG2 = "/sasfeguarddebug", "/sgdebug"
function SlashCmdList.SAFEGUARDDEBUG()
  EM:Debug()
end

SLASH_SAFEGUARDTEST1, SLASH_SAFEGUARDTEST2 = "/sasfeguardtest", "/sgtest"
function SlashCmdList.SAFEGUARDTEST()
  EM:Test()
end

-- *** Locals ***

-- *** Event Handlers ***

function EM:OnEvent(_, event, ...)
  if self.EventHandlers[event] then
		self.EventHandlers[event](self, ...)
	end
end

function EM.EventHandlers.ADDON_ACTION_FORBIDDEN(self, addonName, functionCalled)
  --print("ADDON_ACTION_FORBIDDEN. " .. addonName .. ", " .. functionCalled)
  if (addonName ~= "Safeguard") then return end

  if (functionCalled == "TargetUnit()") then
    IntervalManager.DangerousEnemiesVariables.TargetWasForbidden = true
  end
end

function EM.EventHandlers.ADDON_LOADED(self, addonName, ...)
  if (addonName ~= "Safeguard") then return end

  local floatingCombatTextIsEnabled = GetCVar("enableFloatingCombatText") == "1"

  if (type(_G["SAFEGUARD_SETTINGS"]) ~= "table") then
		_G["SAFEGUARD_SETTINGS"] = {
      Options = {
        EnableChatMessages = true,
        EnableChatMessagesLogout = true,
        EnableChatMessagesLossOfControl = true,
        EnableChatMessagesLowHealth = true,
        EnableChatMessagesSpellCasts = true,
        EnableChatMessagesExtraAttacksStored = true,
        EnableDangerousNpcAlerts = true,
        DangerousNpcNormalLevelOffset = 5,
        DangerousNpcSpecialLevelOffset = -8,
        EnableDangerousNpcAlertWindow = true,
        EnableDangerousNpcAlertSounds = true,
        EnableLowHealthAlerts = true,
        EnableLowHealthAlertScreenFlashing = true,
        EnableLowHealthAlertSounds = true,
        EnableTextNotifications = true,
        EnableTextNotificationsAurasSelf = true,
        EnableTextNotificationsAurasGroup = true,
        EnableTextNotificationsCombatSelf = true,
        EnableTextNotificationsCombatGroup = true,
        EnableTextNotificationsConnectionSelf = true,
        EnableTextNotificationsConnectionGroup = true,
        EnableTextNotificationsLogout = true,
        EnableTextNotificationsLossOfControlSelf = true,
        EnableTextNotificationsLossOfControlGroup = true,
        EnableTextNotificationsLowHealthSelf = true,
        EnableTextNotificationsLowHealthGroup = true,
        EnableTextNotificationsPvpFlagged = true,
        EnableTextNotificationsSpellcasts = true,
        EnableTextNotificationsExtraAttacksStored = true,
        ForceFloatingCombatText = floatingCombatTextIsEnabled,
        ShowIconsOnRaidFrames = true,
        ShowPvpFlagTimerWindow = false,
        ThresholdForCriticallyLowHealth = 0.30,
        ThresholdForLowHealth = 0.50,
      },
    }
	end
  
  Safeguard_Settings = _G["SAFEGUARD_SETTINGS"]

  if (Safeguard_Settings.Options.EnableChatMessagesLossOfControl == nil) then Safeguard_Settings.Options.EnableChatMessagesLossOfControl = true end
  if (Safeguard_Settings.Options.EnableTextNotificationsLossOfControlSelf == nil) then Safeguard_Settings.Options.EnableTextNotificationsLossOfControlSelf = true end
  if (Safeguard_Settings.Options.EnableTextNotificationsLossOfControlGroup == nil) then Safeguard_Settings.Options.EnableTextNotificationsLossOfControlGroup = true end
  if (Safeguard_Settings.Options.ThresholdForCriticallyLowHealth == nil) then Safeguard_Settings.Options.ThresholdForCriticallyLowHealth = 0.30 end
  if (Safeguard_Settings.Options.ThresholdForLowHealth == nil) then Safeguard_Settings.Options.ThresholdForLowHealth = 0.50 end
  if (Safeguard_Settings.Options.EnableTextNotificationsPvpFlagged == nil) then Safeguard_Settings.Options.EnableTextNotificationsPvpFlagged = true end
  if (Safeguard_Settings.Options.EnableDangerousNpcAlerts == nil) then Safeguard_Settings.Options.EnableDangerousNpcAlerts = true end
  if (Safeguard_Settings.Options.DangerousNpcNormalLevelOffset == nil) then Safeguard_Settings.Options.DangerousNpcNormalLevelOffset = 5 end
  if (Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset == nil) then Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset = -8 end
  if (Safeguard_Settings.Options.EnableDangerousNpcAlertWindow == nil) then Safeguard_Settings.Options.EnableDangerousNpcAlertWindow = true end
  if (Safeguard_Settings.Options.EnableDangerousNpcAlertSounds == nil) then Safeguard_Settings.Options.EnableDangerousNpcAlertSounds = true end
  if (Safeguard_Settings.Options.EnableTextNotificationsExtraAttacksStored == nil) then Safeguard_Settings.Options.EnableTextNotificationsExtraAttacksStored = true end
  if (Safeguard_Settings.Options.ForceFloatingCombatText == nil) then Safeguard_Settings.Options.ForceFloatingCombatText = floatingCombatTextIsEnabled end
  if (Safeguard_Settings.Options.ShowPvpFlagTimerWindow == nil) then Safeguard_Settings.Options.ShowPvpFlagTimerWindow = false end
  if (Safeguard_Settings.Options.EnableChatMessagesExtraAttacksStored == nil) then Safeguard_Settings.Options.EnableChatMessagesExtraAttacksStored = true end

  Safeguard_DangerousNpcsWindow:Initialize()
  Safeguard_OptionWindow:Initialize()
  Safeguard_PvpFlagTimerWindow:Initialize()
end

function EM.EventHandlers.CHAT_MSG_ADDON(self, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
  MessageManager:OnChatMessageAddonEvent(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
end

local AurasToNotify = {
  ["Blessing of Protection"] = true,
  ["Divine Intervention"] = true,
  ["Divine Protection"] = true,
  ["Divine Shield"] = true,
  ["Feign Death"] = true, -- unconfirmed
  ["Ice Block"] = true, -- unconfirmed
  ["Invulnerability"] = true, -- unconfirmed Limited Invulnerability Potion
  ["Light of Elune"] = true, -- unconfirmed
  ["Petrification"] = true, --unconfirmed Flask of Petrification
  ["Vanish"] = true, -- unconfirmed
}

local SpellsToNotifyOnCastStart = {
  ["Hearthstone"] = true,
}

local combatLogHostileEvents = { }
do
    local hostileEventPrefixes = { "RANGE", "SPELL", "SPELL_BUILDING", "SPELL_PERIODIC", "SWING" }
    local hostileEventSuffixes = { "DAMAGE", "DRAIN", "INSTAKILL", "LEECH", "MISSED" }
    for _, prefix in pairs(hostileEventPrefixes) do
        for _, suffix in pairs(hostileEventSuffixes) do
          combatLogHostileEvents[prefix .. "_" .. suffix] = true
        end
    end
end

local knownHostileUnits = {} -- <GUID, _>
local unitsWithExtraAttacksStored = {} -- <GUID, amount>

function EM.EventHandlers.COMBAT_LOG_EVENT_UNFILTERED(self)
  local timestamp, event, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidflags = CombatLogGetCurrentEventInfo()
  --print("COMBAT_LOG_EVENT_UNFILTERED. " .. tostring(event))

  if (event == "SPELL_AURA_APPLIED") then
    local spellId, spellName, spellSchool, auraType = select(12, CombatLogGetCurrentEventInfo())
    if (AurasToNotify[spellName]) then
      Safeguard_NotificationManager:ShowNotificationToPlayer(destName, SgEnum.NotificationType.AuraApplied, spellName)
    end
  elseif (event == "SPELL_CAST_FAILED") then
    -- Note: SPELL_CAST_FAILED events are not triggered for other players' failed spell casts.
    local _, spellName = select(12, CombatLogGetCurrentEventInfo())
    if (SpellsToNotifyOnCastStart[spellName]) then
      if (sourceGuid == UnitGUID("player") and UnitInParty("player")) then
        MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.SpellCastInterrupted, spellName)
      end
    end
  elseif (event == "SPELL_CAST_START") then
    local _, spellName = select(12, CombatLogGetCurrentEventInfo())
    if (SpellsToNotifyOnCastStart[spellName]) then
      if (sourceGuid == UnitGUID("player") and UnitInParty("player")) then
        MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.SpellCastStarted, spellName)
      end
      
      if (sourceGuid ~= UnitGUID("player") and UnitHelperFunctions.IsUnitGuidInOurPartyOrRaid(sourceGuid)) then
        Safeguard_NotificationManager:ShowNotificationToPlayer(sourceName, SgEnum.NotificationType.SpellCastStarted, spellName)
      end
    end
  elseif (event == "SPELL_EXTRA_ATTACKS") then
    local spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())

    if (not unitsWithExtraAttacksStored[sourceGuid]) then
      unitsWithExtraAttacksStored[sourceGuid] = amount
    else
      unitsWithExtraAttacksStored[sourceGuid] = unitsWithExtraAttacksStored[sourceGuid] + amount
    end

    if (unitsWithExtraAttacksStored[sourceGuid] > 4) then
      unitsWithExtraAttacksStored[sourceGuid] = 4
    else
      C_Timer.After(0.25, function() -- This is on a timer because there is no point in notifying the player if the attacks occur immediately after the enemy stores them.
        EM:CheckToNotifyForExtraAttacks(sourceGuid, sourceName)
      end)
    end
  end

  if (combatLogHostileEvents[event]) then
    local playerGuid = UnitGUID("player")
    if (sourceGuid == playerGuid) then
      knownHostileUnits[destGuid] = true
    elseif (destGuid == playerGuid) then
      knownHostileUnits[sourceGuid] = true
    end
  end

  if (string.match(event, "SWING")) then
    if (unitsWithExtraAttacksStored[sourceGuid]) then
      unitsWithExtraAttacksStored[sourceGuid] = 0
    end
  end
end

local playerWasInParty = false
function EM.EventHandlers.GROUP_ROSTER_UPDATE(self)
  --print("GROUP_ROSTER_UPDATE.")
  self:UpdateGroupMemberInfo()

  local playerIsInParty = UnitInParty("player")
  if (playerIsInParty and playerIsInParty ~= playerWasInParty) then
    MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.AddonInfo, GetAddOnMetadata("Safeguard", "Version"))
  end

  playerWasInParty = playerIsInParty
end

function EM.EventHandlers.LOSS_OF_CONTROL_ADDED(self, unitId, effectIndex)
  --print("LOSS_OF_CONTROL_ADDED." .. tostring(unitId) .. "," .. tostring(effectIndex))

  if (unitId ~= "player") then return end -- From what I've seen, this event only fires for the player anyway.

  local lossOfControlData = C_LossOfControl.GetActiveLossOfControlDataByUnit(unitId, effectIndex)
  --Safeguard_HelperFunctions.PrintKeysAndValuesFromTable(lossOfControlData)

  local locType = SgEnum.LossOfControlType.Unknown
  if (lossOfControlData.locType == "CONFUSE") then
    locType = SgEnum.LossOfControlType.Confuse
  elseif (lossOfControlData.locType == "DISARM") then
    locType = SgEnum.LossOfControlType.Disarm
  elseif (lossOfControlData.locType == "FEAR_MECHANIC") then
    locType = SgEnum.LossOfControlType.FearMechanic
  elseif (lossOfControlData.locType == "ROOT") then
    locType = SgEnum.LossOfControlType.Root
  elseif (lossOfControlData.locType == "SCHOOL_INTERRUPT") then
    locType = SgEnum.LossOfControlType.SchoolInterrupt
  elseif (lossOfControlData.locType == "SILENCE") then
    locType = SgEnum.LossOfControlType.Silence
  elseif (lossOfControlData.locType == "STUN") then
    locType = SgEnum.LossOfControlType.Stun
  elseif (lossOfControlData.locType == "STUN_MECHANIC") then
    locType = SgEnum.LossOfControlType.StunMechanic
  else
    table.insert(Safeguard_EventManager.DebugLogs, string.format("%d - No LossOfControlType for: %s", time(), lossOfControlData.locType))
  end

  local timeRemaining = lossOfControlData.timeRemaining
  if (timeRemaining ~= nil) then timeRemaining = math.floor(timeRemaining + 0.5) end

  Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), SgEnum.NotificationType.LossOfControl, locType, timeRemaining)
  MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.LossOfControl, locType, timeRemaining)
end

function EM.EventHandlers.PLAYER_ENTERING_WORLD(self, isLogin, isReload)
  --print("PLAYER_ENTERING_WORLD. " .. tostring(isLogin) ..  ", " .. tostring(isReload))

  self:UpdateGroupMemberInfo()
  self.PlayerFlags.Pvp = UnitIsPVP("player")
  
  if (isLogin or isReload) then
    C_ChatInfo.RegisterAddonMessagePrefix(MessageManager.AddonMessagePrefix)
  
    IntervalManager:CheckCombatInterval()
    IntervalManager:CheckDangerousEnemiesInterval()
    IntervalManager:CheckGroupConnectionsInterval()
    IntervalManager:SendHeartbeatInterval()
  else
    Safeguard_PlayerStates = {}
    MessageManager:SendHeartbeatMessage()
  end

  if (Safeguard_Settings.Options.ForceFloatingCombatText and GetCVar("enableFloatingCombatText") ~= "1") then
    print("[Safeguard] Enabling floating combat text.")
    SetCVar("enableFloatingCombatText", 1)
  end
end

function EM.EventHandlers.PLAYER_FLAGS_CHANGED(self, unitId)
  if (unitId ~= "player" or UnitIsPVP("player") == self.PlayerFlags.Pvp) then return end

  local playerHadPvpEnabled = self.PlayerFlags.Pvp
  self.PlayerFlags.Pvp = UnitIsPVP("player")
  if (playerHadPvpEnabled == nil) then return end

  local notificationType = SgEnum.NotificationType.PvpFlagged
  if (not self.PlayerFlags.Pvp) then notificationType = SgEnum.NotificationType.PvpUnflagged end
  Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), notificationType)
end

function EM.EventHandlers.PLAYER_LEAVING_WORLD(self)
  --print("PLAYER_LEAVING_WORLD.")

  --This message only seems to actually get sent when reloading, not when going through instance portals.
  MessageManager:SendHeartbeatMessage()
end

function EM.EventHandlers.PLAYER_REGEN_DISABLED(self)
  --print("PLAYER_REGEN_DISABLED")

  MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.EnteredCombat)
  Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), SgEnum.NotificationType.EnteredCombat)
end

function EM.EventHandlers.PLAYER_REGEN_ENABLED(self)
  --print("PLAYER_REGEN_ENABLED")

  MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.ExitedCombat)
end

function EM.EventHandlers.UNIT_COMBAT(self, unitId, action, ind, dmg, dmgType)
  --print("UNIT_COMBAT: " .. unitId .. ". " .. action .. ". " .. ind .. ". " .. dmg .. ". " .. dmgType)
end

local healthStatus = {}

function EM.EventHandlers.UNIT_HEALTH(self, unitId)
  --print("UNIT_HEALTH: " .. unitId)

  if (not Safeguard_Settings.Options.EnableLowHealthAlerts) then return end

  local updateIsForPlayer = unitId == "player"
  local updateIsForParty = unitId:match("party")
  if (not updateIsForPlayer and not updateIsForParty) then return end

  local health = UnitHealth(unitId)
  local maxHealth = UnitHealthMax(unitId)
  
  if (maxHealth == 0) then return end

  local healthPercentage = health / maxHealth

  local newHealthStatus = nil
  if (health == 0) then
    newHealthStatus = 0
  elseif (healthPercentage <= Safeguard_Settings.Options.ThresholdForCriticallyLowHealth) then
    newHealthStatus = 1
  elseif (healthPercentage <= Safeguard_Settings.Options.ThresholdForLowHealth) then
    newHealthStatus = 2
  else
    newHealthStatus = 3
  end

  local oldHealthStatus = healthStatus[unitId]
  if (newHealthStatus == oldHealthStatus) then return end

  if (newHealthStatus == 1) then
    Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), SgEnum.NotificationType.HealthCriticallyLow, math.floor(healthPercentage * 100))

    if (updateIsForPlayer) then
      if (Safeguard_Settings.Options.EnableLowHealthAlertSounds) then
        self:PlaySound("alert2")
      end

      MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.HealthCriticallyLow, math.floor(healthPercentage * 100))

      if (Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing) then
        Safeguard_FlashFrame:PlayAnimation(9999, 1.5, 1.0)
      end
    end
  elseif (newHealthStatus == 2) then
    if (oldHealthStatus == nil or oldHealthStatus > newHealthStatus) then
      Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName(unitId), SgEnum.NotificationType.HealthLow, math.floor(healthPercentage * 100))
      
      if (updateIsForPlayer) then
        if (Safeguard_Settings.Options.EnableLowHealthAlertSounds) then
          self:PlaySound("alert3")
        end

        MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.HealthLow, math.floor(healthPercentage * 100))
      end
    end

    if (updateIsForPlayer and Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing) then
      Safeguard_FlashFrame:PlayAnimation(9999, 2.0, 0.75)
    end
  elseif (updateIsForPlayer) then
    Safeguard_FlashFrame:StopAnimation()
  end

  healthStatus[unitId] = newHealthStatus
end


function EM.EventHandlers.UNIT_TARGET(self, unitId)
  --print("UNIT_TARGET: " .. unitId)
end

hooksecurefunc("CancelLogout", function()
	--print("CancelLogout")

  MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.LogoutCancelled)
end)

hooksecurefunc("Logout", function()
	--print("Logout")
  if (UnitAffectingCombat("player")) then return end

  MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.LoggingOut)
end)

hooksecurefunc("Quit", function()
	--print("Quit")
  if (UnitAffectingCombat("player")) then return end

  MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.LoggingOut)
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	
end)

-- Register each event for which we have an event handler.
EM.Frame = CreateFrame("Frame")
for eventName,_ in pairs(EM.EventHandlers) do
	  EM.Frame:RegisterEvent(eventName)
end
EM.Frame:SetScript("OnEvent", function(_, event, ...) EM:OnEvent(_, event, ...) end)


-- Helper Functions

-- function EM:GetPlayerRelationship(unitId)
--   if (unitId == "player") then
--     return SgEnum.PlayerRelationshipType.Player
--   end

--   if (unitId:match("party")) then
--     return SgEnum.PlayerRelationshipType.Party
--   end

--   return SgEnum.PlayerRelationshipType.None
-- end

function EM:CheckToNotifyForExtraAttacks(sourceGuid, sourceName)
  if (unitsWithExtraAttacksStored[sourceGuid] > 0) then
    local shouldNotify = knownHostileUnits[sourceGuid]

    local unitId = nil
    local isTankingEnemy = nil
    if (not shouldNotify) then
      unitId = UnitHelperFunctions.FindUnitIdByUnitGuid(sourceGuid)
      if (unitId) then
        local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()
        if ((type == "party" or type == "raid") and not UnitIsFriend("player", unitId)) then
          shouldNotify = true
        else
          local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", unitId)
          isTankingEnemy = isTanking

          if (threatpct ~= nil) then
            shouldNotify = true
          end
        end
      end
    end

    if (shouldNotify) then
      Safeguard_NotificationManager:ShowNotificationToPlayer(UnitName("player"), SgEnum.NotificationType.ExtraAttacksStored, sourceName, unitsWithExtraAttacksStored[sourceGuid])

      if (isTankingEnemy ~= false) then
        if (not unitId) then unitId = UnitHelperFunctions.FindUnitIdByUnitGuid(sourceGuid) end
        if (unitId) then
          local classification = UnitClassification(unitId)
          if (classification == "worldboss" or classification == "rareelite" or classification == "elite") then
            if (isTankingEnemy == nil) then
              isTankingEnemy = UnitDetailedThreatSituation("player", unitId)
            end

            if (isTankingEnemy) then
              MessageManager:SendMessageToGroup(SgEnum.AddonMessageType.ExtraAttacksStored, sourceName, unitsWithExtraAttacksStored[sourceGuid])
            end
          end
        end
      end
    end
  end
end

function EM:PlaySound(soundFile)
  local normalEnableDialog = GetCVar("Sound_EnableDialog")
  local normalDialogVolume = GetCVar("Sound_DialogVolume")
  SetCVar("Sound_EnableDialog", 1)
  SetCVar("Sound_DialogVolume", 1)

  PlaySoundFile("Interface\\AddOns\\Safeguard\\resources\\" .. soundFile .. ".mp3", "Dialog")

  C_Timer.After(1, function()
    SetCVar("Sound_EnableDialog", normalEnableDialog)
    SetCVar("Sound_DialogVolume", normalDialogVolume)
  end)
end

function EM:UpdateGroupMemberInfo()
  -- Populate list of unit GUIDs in player's party/raid.
  local playerGuid = UnitGUID("player")
  local unitGuidsInGroup = { }

  unitGuidsInGroup[playerGuid] = "player"
  for i = 1, 4 do
    local unitId = "party" .. i
    local guid = UnitGUID(unitId)
    if (guid and guid ~= playerGuid) then
      unitGuidsInGroup[guid] = unitId
    end
  end
  for i = 1, 40 do
    local unitId = "raid" .. i
    local guid = UnitGUID(unitId)
    if (guid and guid ~= playerGuid) then
      unitGuidsInGroup[guid] = unitId
    end
  end
  
  -- Perform actions for units who are in the group.
  for k,v in pairs(unitGuidsInGroup) do
  end
  
  -- Perform actions for units who left the group.
  for k,v in pairs(Safeguard_PlayerStates) do
    if (not unitGuidsInGroup[k]) then
      Safeguard_PlayerStates[k] = nil
    end
  end
end

local testNum = 1
function EM:Test()
  print("[Safeguard] Test")

  -- print(UnitDetailedThreatSituation("player", "target"))
  -- local possibleEnemyUnitIds = UnitHelperFunctions.GetPossibleEnemyUnitIds()
  -- local unitsTargettingMe = {}
  -- for i = 1, #possibleEnemyUnitIds do
  --   local guid = UnitGUID(possibleEnemyUnitIds[i])
  --   if (guid and not unitsTargettingMe[guid]) then
  --     local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", possibleEnemyUnitIds[i])
  --     if (isTanking) then
  --       unitsTargettingMe[guid] = true
  --     end
  --   end
	-- end

  -- local unitsTargettingMeCount = 0
  -- for k,v in pairs(unitsTargettingMe) do
  --   unitsTargettingMeCount = unitsTargettingMeCount + 1
  -- end

  -- print(unitsTargettingMeCount)

  -- local nameplateMaxDistance = GetCVar("nameplateMaxDistance")
  -- print(nameplateMaxDistance)
  -- --SetCVar("nameplateMaxDistance", 40) -- max is 20 in vanilla

  print(UnitClassification("target"))
end

function EM:Debug()
  local startIndex = #self.DebugLogs - 50
  if (startIndex < 1) then startIndex = 1 end
  for i = startIndex, #self.DebugLogs do
    print(i .. " - " .. self.DebugLogs[i])
  end
end
