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
  DNW.HeaderFs:SetText("Dangerous NPCs Nearby:")

  DNW.FontStringsPool = {
    Allocated = {},
    UnAllocated = {},
  }
end

function DNW:Update(dangerousNpcsNearby)
  for i = 1, #DNW.FontStringsPool.Allocated, 1 do
    local fs = DNW.FontStringsPool.Allocated[i]
    fs:Hide()
    fs:SetText("")
    table.insert(DNW.FontStringsPool.UnAllocated, fs)
  end
  DNW.FontStringsPool.Allocated = {}

  for npcName, isNearby in pairs(dangerousNpcsNearby) do
    if (isNearby) then
      local fs = table.remove(DNW.FontStringsPool.UnAllocated)
      if (not fs) then
        fs = DNW:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      end
      fs:SetPoint("TOPLEFT", DNW, 5, -15 * #DNW.FontStringsPool.Allocated - 25)
      fs:SetText(npcName)
      fs:Show()
      table.insert(DNW.FontStringsPool.Allocated, fs)
    end
  end

  if (#DNW.FontStringsPool.Allocated == 0) then
    DNW:Hide()
  else
    DNW:SetSize(200, 30 + (15 * #DNW.FontStringsPool.Allocated))
    DNW:Show()
  end
end