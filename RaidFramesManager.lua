Safeguard_RaidFramesManager = {
  ARaidFrameUpdateIsQueued = nil,
  LastRaidFramesUpdateTimestamp = nil,
}

local RFM = Safeguard_RaidFramesManager

function RFM:UpdateRaidFrames()
  if (not CompactRaidFrameContainer:IsShown()) then return end

  local now = GetTime()
  if (self.LastRaidFramesUpdateTimestamp and now - self.LastRaidFramesUpdateTimestamp < 1) then
    if (not self.ARaidFrameUpdateIsQueued) then
      C_Timer.After(1 - (now - self.LastRaidFramesUpdateTimestamp), function()
        RFM:UpdateRaidFrames()
      end)
      self.ARaidFrameUpdateIsQueued = true
    end

    return
  end

  self.ARaidFrameUpdateIsQueued = false
  self.LastRaidFramesUpdateTimestamp = now

  -- CompactRaidFrameContainer:ApplyToFrames("normal",
  --   function(frame)
  --     print(frame)
  --   end)
  CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal", function(frame) RFM:UpdateRaidFrame(frame) end)
end

function RFM:UpdateRaidFrame(frame)
  if (not frame.unit) then return end

  local guid = UnitGUID(frame.unit)
  if (not guid) then return end

  if (not frame.SgIconsContainerFrame) then RFM:SetupRaidFrameIcons(frame) end

  if (not Safeguard_PlayerStates[guid] or not Safeguard_Settings.Options.ShowIconsOnRaidFrames) then
    if (frame.SgIconsContainerFrame.ConnectedIcon:IsShown()) then frame.SgIconsContainerFrame.ConnectedIcon:Hide() end
    if (frame.SgIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.SgIconsContainerFrame.DisconnectedIcon:Hide() end
    if (frame.SgIconsContainerFrame.InCombatIcon:IsShown()) then frame.SgIconsContainerFrame.InCombatIcon:Hide() end

    return
  end

  if (not frame.SgIconsContainerFrame:IsShown()) then frame.SgIconsContainerFrame:Show() end

  if (not Safeguard_PlayerStates[guid].ConnectionInfo) then
    if (frame.SgIconsContainerFrame.ConnectedIcon:IsShown()) then frame.SgIconsContainerFrame.ConnectedIcon:Hide() end
    if (frame.SgIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.SgIconsContainerFrame.DisconnectedIcon:Hide() end
  else
    if (Safeguard_PlayerStates[guid].ConnectionInfo.IsConnected) then
      if (not frame.SgIconsContainerFrame.ConnectedIcon:IsShown()) then frame.SgIconsContainerFrame.ConnectedIcon:Show() end
      if (frame.SgIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.SgIconsContainerFrame.DisconnectedIcon:Hide() end
    else
      if (frame.SgIconsContainerFrame.ConnectedIcon:IsShown()) then frame.SgIconsContainerFrame.ConnectedIcon:Hide() end
      if (not frame.SgIconsContainerFrame.DisconnectedIcon:IsShown()) then frame.SgIconsContainerFrame.DisconnectedIcon:Show() end
    end
  end

  if (Safeguard_PlayerStates[guid].IsInCombat) then
    if (not frame.SgIconsContainerFrame.InCombatIcon:IsShown()) then frame.SgIconsContainerFrame.InCombatIcon:Show() end
  else
    if (frame.SgIconsContainerFrame.InCombatIcon:IsShown()) then frame.SgIconsContainerFrame.InCombatIcon:Hide() end
  end
end

function RFM:SetupRaidFrameIcons(frame)
  frame.SgIconsContainerFrame = CreateFrame("Frame", nil, frame)

  -- ConnectedIcon
  frame.SgIconsContainerFrame.ConnectedIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.SgIconsContainerFrame.ConnectedIcon:SetPoint("TOPLEFT", frame, 2, -2)
  frame.SgIconsContainerFrame.ConnectedIcon:SetSize(6, 6)
  
  frame.SgIconsContainerFrame.ConnectedIcon.Texture = frame.SgIconsContainerFrame.ConnectedIcon:CreateTexture()
  frame.SgIconsContainerFrame.ConnectedIcon.Texture:SetAllPoints()
  frame.SgIconsContainerFrame.ConnectedIcon.Texture:SetColorTexture(0, 1, 0)

  frame.SgIconsContainerFrame.ConnectedIcon:SetScript("OnEnter", function(self, button)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("TOPRIGHT", frame.ConnectedIcon, "BOTTOMRIGHT", 0, 0)

    GameTooltip:SetText("Connected")
    
    GameTooltip:Show()
  end)

  frame.SgIconsContainerFrame.ConnectedIcon:SetScript("OnLeave", function(self, button)
    GameTooltip:Hide()
  end)

  --icon:SetFrameLevel(999)
  frame.SgIconsContainerFrame.ConnectedIcon:Hide()

  -- DisconnectedIcon
  frame.SgIconsContainerFrame.DisconnectedIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.SgIconsContainerFrame.DisconnectedIcon:SetPoint("TOPLEFT", frame, 2, -2)
  frame.SgIconsContainerFrame.DisconnectedIcon:SetSize(6, 6)
  
  frame.SgIconsContainerFrame.DisconnectedIcon.Texture = frame.SgIconsContainerFrame.DisconnectedIcon:CreateTexture()
  frame.SgIconsContainerFrame.DisconnectedIcon.Texture:SetAllPoints()
  frame.SgIconsContainerFrame.DisconnectedIcon.Texture:SetColorTexture(1, 0, 0)

  frame.SgIconsContainerFrame.DisconnectedIcon:SetScript("OnEnter", function(self, button)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("TOPRIGHT", frame.DisconnectedIcon, "BOTTOMRIGHT", 0, 0)

    GameTooltip:SetText("Disconnected")
    
    GameTooltip:Show()
  end)

  frame.SgIconsContainerFrame.DisconnectedIcon:SetScript("OnLeave", function(self, button)
    GameTooltip:Hide()
  end)

  --icon:SetFrameLevel(999)
  frame.SgIconsContainerFrame.DisconnectedIcon:Hide()

  -- InCombatIcon
  frame.SgIconsContainerFrame.InCombatIcon = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
  frame.SgIconsContainerFrame.InCombatIcon:SetPoint("TOPLEFT", frame, 8, -2)
  frame.SgIconsContainerFrame.InCombatIcon:SetSize(6, 6)
  frame.SgIconsContainerFrame.InCombatIcon:SetBackdrop({bgFile = "Interface\\Icons\\ability_warrior_challange"})

  frame.SgIconsContainerFrame.InCombatIcon:SetScript("OnEnter", function(self, button)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("TOPRIGHT", frame.InCombatIcon, "BOTTOMRIGHT", 0, 0)

    GameTooltip:SetText("In Combat")
    
    GameTooltip:Show()
  end)

  frame.SgIconsContainerFrame.InCombatIcon:SetScript("OnLeave", function(self, button)
    GameTooltip:Hide()
  end)

  --icon:SetFrameLevel(999)
  frame.SgIconsContainerFrame.InCombatIcon:Hide()
end


