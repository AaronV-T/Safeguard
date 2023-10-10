Safeguard_HelperFunctions = {}

local HF = Safeguard_HelperFunctions

function HF.BoolToNumber(bool)
  return bool and 1 or 0
end

function HF.NumberToBool(number)
  if (number == 0) then
    return false
  elseif (number == 1) 
    then return true
  else
    return nil
  end
end

function HF.PrintKeysAndValuesFromTable(tab, noRecurse, indentLevel)
  if tab == nil then return end

  local indentation = ""
  if (not indentLevel) then
    indentLevel = 0
  end

  for i = 1, indentLevel do
    indentation = indentation .. "  "
  end

  for k,v in pairs(tab) do
    print(indentation .. k .. ": " .. tostring(v))

    if (not noRecurse and type(v) == "table") then
      HF.PrintKeysAndValuesFromTable(v, noRecurse, indentLevel + 1)
    end
  end
end