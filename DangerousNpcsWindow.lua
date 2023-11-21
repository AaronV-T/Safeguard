Safeguard_DangerousNpcsWindow = CreateFrame("Frame", "Safeguard_DangerousNpcsWindow", UIParent, "BackdropTemplate")

local DNW = Safeguard_DangerousNpcsWindow

function DNW:Initialize()
  DNW:SetPoint("TOP")
  DNW:SetBackdrop(BACKDROP_TUTORIAL_16_16)
  DNW:SetClampedToScreen(true)
  DNW:SetMovable(true)
  DNW:EnableMouse(true)
  DNW:RegisterForDrag("LeftButton")
  DNW:SetScript("OnDragStart", function(self, button)
    self:StartMoving()
  end)
  DNW:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
  DNW:Hide()
  
  DNW.HeaderFs = DNW:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  DNW.HeaderFs:SetPoint("TOP", DNW, "TOP", 0, -5)
  DNW.HeaderFs:SetText("Safeguard - Deadly NPCs Nearby")

  DNW.FontStringsPool = {
    Allocated = {},
    UnAllocated = {},
  }
end

function DNW:Update(dangerousNpcsNearby)
  if (not Safeguard_Settings.Options.EnableDangerousNpcAlertWindow) then
    DNW:Hide()
    return
  end

  for i = 1, #DNW.FontStringsPool.Allocated, 1 do
    local fs = DNW.FontStringsPool.Allocated[i]
    fs:ClearAllPoints()
    fs:Hide()
    fs:SetText("")
    table.insert(DNW.FontStringsPool.UnAllocated, fs)
  end
  DNW.FontStringsPool.Allocated = {}

  local count = 0
  for npcName, npc in Safeguard_HelperFunctions.PairsByKeys(dangerousNpcsNearby) do
    if (npc) then
      local fsName = table.remove(DNW.FontStringsPool.UnAllocated)
      if (not fsName) then
        fsName = DNW:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      end
      fsName:SetPoint("TOPLEFT", DNW, 5, -25 + (-15 * count))
      fsName:SetText(npcName)
      fsName:Show()
      table.insert(DNW.FontStringsPool.Allocated, fsName)

      local classificationString = ""
      if (npc.classification == 1) then classificationString = "(E)"
      elseif (npc.classification == 2) then classificationString = "(RE)"
      elseif (npc.classification == 3) then classificationString = "(B)"
      elseif (npc.classification == 4) then classificationString = "(R)"
      end

      local fsClassification = table.remove(DNW.FontStringsPool.UnAllocated)
      if (not fsClassification) then
        fsClassification = DNW:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      end
      fsClassification:SetPoint("TOPRIGHT", DNW, -40, -25 + (-15 * count))
      fsClassification:SetText(classificationString)
      fsClassification:Show()
      table.insert(DNW.FontStringsPool.Allocated, fsClassification)

      local fsLevelRange = table.remove(DNW.FontStringsPool.UnAllocated)
      if (not fsLevelRange) then
        fsLevelRange = DNW:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      end
      fsLevelRange:SetPoint("TOPRIGHT", DNW, -5, -25 + (-15 * count))
      fsLevelRange:SetText(string.format("%d-%d", npc.minlevel, npc.maxlevel))
      fsLevelRange:Show()
      table.insert(DNW.FontStringsPool.Allocated, fsLevelRange)

      count = count + 1
    end
  end

  if (count == 0) then
    DNW:Hide()
  else
    DNW:SetSize(210, 30 + (15 * count))
    DNW:Show()
  end
end