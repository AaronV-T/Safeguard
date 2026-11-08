UnitHelperFunctions = {}

local UHF = UnitHelperFunctions

local isSecretValue = issecretvalue

local function IsReadableIdentity(value)
  -- Dungeon units can have secret names/GUIDs. Check before comparing or
  -- returning them to callers that use identities as table keys.
  return not (isSecretValue and isSecretValue(value)) and type(value) == "string"
end

local validUnitIds = { "focus", "focuspet", "mouseover", "mouseoverpet", "pet", "player", "target", "targetpet" }
for i = 1, 40 do
  if i <= 4 then
    validUnitIds[#validUnitIds + 1] = "party" .. i
    validUnitIds[#validUnitIds + 1] = "partypet" .. i
  end
  validUnitIds[#validUnitIds + 1] = "raid" .. i
  validUnitIds[#validUnitIds + 1] = "raidpet" .. i
end
for i = 1, 50 do
  validUnitIds[#validUnitIds + 1] = "nameplate" .. i
end
for i = 1, #validUnitIds do
  validUnitIds[#validUnitIds + 1] = validUnitIds[i] .. "target"
end

function UHF.FindUnitIdAndGuidByUnitName(unitName)
  if (not IsReadableIdentity(unitName)) then return nil, nil end

  for i = 1, #validUnitIds do
    local name = UnitName(validUnitIds[i])
    if (IsReadableIdentity(name) and name == unitName) then
      local guid = UnitGUID(validUnitIds[i])
      if (IsReadableIdentity(guid)) then return validUnitIds[i], guid end
    end
  end

  return nil, nil
end

function UHF.FindUnitIdByUnitGuid(unitGuid)
  if (not IsReadableIdentity(unitGuid)) then return nil end

  for i = 1, #validUnitIds do
    local guid = UnitGUID(validUnitIds[i])
    if (IsReadableIdentity(guid) and guid == unitGuid) then return validUnitIds[i] end
  end

  return nil
end 

function UHF.IsUnitGuidInOurPartyOrRaid(unitGuid)
  if (not IsReadableIdentity(unitGuid)) then return false end

  for i = 1, #validUnitIds do
    if ((string.match(validUnitIds[i], "party") or string.match(validUnitIds[i], "raid")) and not string.match(validUnitIds[i], "target")) then
      local guid = UnitGUID(validUnitIds[i])
      if (IsReadableIdentity(guid) and guid == unitGuid) then return true end
    end
  end

  return false
end

-- function UHF.IsUnitGuidPlayerOrPlayerPet(unitGuid)
--   if (UnitGUID("player") == unitGuid) then return true end
--   if (UnitGUID("pet") == unitGuid) then return true end
--   return false
-- end

function UHF.FindUnitNameByUnitGuid(unitGuid)
  local unitId = UHF.FindUnitIdByUnitGuid(unitGuid)
  if (not unitId) then return nil end

  local name = UnitName(unitId)
  if (IsReadableIdentity(name)) then return name end
  return nil
end

function UHF.GetPossibleEnemyUnitIds()
  local possibleEnemyUnitIds = {}
  for i = 1, #validUnitIds do
    if (validUnitIds[i]:match("nameplate") or validUnitIds[i]:match("target")) then
      possibleEnemyUnitIds[#possibleEnemyUnitIds + 1] = validUnitIds[i]
    end
  end

  return possibleEnemyUnitIds
end
