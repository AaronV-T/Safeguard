Safeguard_OptionWindow = CreateFrame("Frame", "Safeguard Options", UIParent)

function Safeguard_OptionWindow:Initialize()
  self.Header = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  self.Header:SetPoint("TOPLEFT", 10, -10)
  self.Header:SetText("Safeguard Options")
  
  local yPos = -50

  self.cbEnableChatMessages = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessages:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableChatMessages = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessages:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableChatMessages:SetText("Enable Chat Messages")
  yPos = yPos - 22

  self.cbEnableChatMessagesLogout = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesLogout:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesLogout = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesLogout:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesLogout:SetText("Send chat messages when you are logging out.")
  yPos = yPos - 22

  self.cbEnableChatMessagesLowHealth = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesLowHealth:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesLowHealth = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesLowHealth:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesLowHealth:SetText("Send chat messages when your health is critically low. (Requires low health alerts to be enabled.)")
  yPos = yPos - 22

  self.cbEnableChatMessagesSpellCasts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesSpellCasts:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesSpellCasts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesSpellCasts:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesSpellCasts:SetText("Send chat messages when you cast certain spells (e.g. Hearthstone).")
  yPos = yPos - 22

  self.cbEnableChatMessagesLossOfControl = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableChatMessagesLossOfControl:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableChatMessagesLossOfControl = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableChatMessagesLossOfControl:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableChatMessagesLossOfControl:SetText("Send chat messages when you are crowd controlled (e.g. stunned, silenced).")
  yPos = yPos - 22

  self.cbEnableDangerousNpcAlerts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableDangerousNpcAlerts:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableDangerousNpcAlerts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableDangerousNpcAlerts:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableDangerousNpcAlerts:SetText("Enable Dangerous NPC Alerts")
  yPos = yPos - 22

  self.ebDangerousNpcNormalLevelOffset = CreateFrame("EditBox", nil, self, BackdropTemplateMixin and "BackdropTemplate");
  self.ebDangerousNpcNormalLevelOffset.LastValidNumber = Safeguard_Settings.Options.DangerousNpcNormalLevelOffset
  self.ebDangerousNpcNormalLevelOffset:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.ebDangerousNpcNormalLevelOffset:SetSize(35, 20)
  self.ebDangerousNpcNormalLevelOffset:SetFontObject(ChatFontNormal)
  self.ebDangerousNpcNormalLevelOffset:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
  self.ebDangerousNpcNormalLevelOffset:SetAutoFocus(false)
  self.ebDangerousNpcNormalLevelOffset:SetMaxLetters(3)
  self.ebDangerousNpcNormalLevelOffset:SetMultiLine(false)
  self.ebDangerousNpcNormalLevelOffset:SetNumeric(false)
  self.ebDangerousNpcNormalLevelOffset:SetScript("OnEscapePressed", function() self.ebDangerousNpcNormalLevelOffset:ClearFocus() end)
  C_Timer.After(1, function() -- This is set on a timer because if it runs immediately then the text will hidden to the leftof  the editbox for some reason.
    self.ebDangerousNpcNormalLevelOffset:SetScript("OnTextChanged", function()
      local number = tonumber(self.ebDangerousNpcNormalLevelOffset:GetText())
      if (number == nil) then
        if (self.ebDangerousNpcNormalLevelOffset:GetText() ~= "-" and self.ebDangerousNpcNormalLevelOffset:GetText() ~= "") then
          self.ebDangerousNpcNormalLevelOffset:SetNumber(self.ebDangerousNpcNormalLevelOffset.LastValidNumber)
        end

        return
      end
      
      self.ebDangerousNpcNormalLevelOffset.LastValidNumber = number
    end)
  end)
  self.ebDangerousNpcNormalLevelOffset:SetTextInsets(5, 5, 0, 0)
  self.fsDangerousNpcNormalLevelOffset = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsDangerousNpcNormalLevelOffset:SetPoint("LEFT", self, "TOPLEFT", 72, yPos)
  self.fsDangerousNpcNormalLevelOffset:SetText("Normal Level Offset")

  self.ebDangerousNpcSpecialLevelOffset = CreateFrame("EditBox", nil, self, BackdropTemplateMixin and "BackdropTemplate");
  self.ebDangerousNpcSpecialLevelOffset.LastValidNumber = Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset
  self.ebDangerousNpcSpecialLevelOffset:SetPoint("LEFT", self, "TOPLEFT", 204, yPos)
  self.ebDangerousNpcSpecialLevelOffset:SetSize(35, 20)
  self.ebDangerousNpcSpecialLevelOffset:SetFontObject(ChatFontNormal)
  self.ebDangerousNpcSpecialLevelOffset:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
  self.ebDangerousNpcSpecialLevelOffset:SetAutoFocus(false)
  self.ebDangerousNpcSpecialLevelOffset:SetMaxLetters(3)
  self.ebDangerousNpcSpecialLevelOffset:SetMultiLine(false)
  self.ebDangerousNpcSpecialLevelOffset:SetNumeric(false)
  self.ebDangerousNpcSpecialLevelOffset:SetScript("OnEscapePressed", function() self.ebDangerousNpcSpecialLevelOffset:ClearFocus() end)
  C_Timer.After(1, function() -- This is set on a timer because if it runs immediately then the text will hidden to the leftof  the editbox for some reason.
    self.ebDangerousNpcSpecialLevelOffset:SetScript("OnTextChanged", function()
      local number = tonumber(self.ebDangerousNpcSpecialLevelOffset:GetText())
      if (number == nil) then
        if (self.ebDangerousNpcSpecialLevelOffset:GetText() ~= "-" and self.ebDangerousNpcSpecialLevelOffset:GetText() ~= "") then
          self.ebDangerousNpcSpecialLevelOffset:SetNumber(self.ebDangerousNpcSpecialLevelOffset.LastValidNumber)
        end

        return
      end
      
      self.ebDangerousNpcSpecialLevelOffset.LastValidNumber = number
    end)
  end)
  self.ebDangerousNpcSpecialLevelOffset:SetTextInsets(5, 5, 0, 0)
  self.fsDangerousNpcSpecialLevelOffset = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsDangerousNpcSpecialLevelOffset:SetPoint("LEFT", self, "TOPLEFT", 242, yPos)
  self.fsDangerousNpcSpecialLevelOffset:SetText("Rare/Elite Level Offset")
  yPos = yPos - 22

  self.cbEnableDangerousNpcAlertWindow = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableDangerousNpcAlertWindow:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableDangerousNpcAlertWindow = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableDangerousNpcAlertWindow:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableDangerousNpcAlertWindow:SetText("Show window.")

  self.cbEnableDangerousNpcAlertSounds = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableDangerousNpcAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 200, yPos)
  self.fsEnableDangerousNpcAlertSounds = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableDangerousNpcAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 230, yPos)
  self.fsEnableDangerousNpcAlertSounds:SetText("Enable alert sounds.")
  yPos = yPos - 22

  self.cbEnableLowHealthAlerts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlerts:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableLowHealthAlerts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlerts:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableLowHealthAlerts:SetText("Enable Low Health Alerts")
  yPos = yPos - 22

  self.ebLowHealthThreshold = CreateFrame("EditBox", nil, self, BackdropTemplateMixin and "BackdropTemplate");
  self.ebLowHealthThreshold:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.ebLowHealthThreshold:SetSize(28, 20)
  self.ebLowHealthThreshold:SetFontObject(ChatFontNormal)
  self.ebLowHealthThreshold:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
  self.ebLowHealthThreshold:SetAutoFocus(false)
  self.ebLowHealthThreshold:SetMaxLetters(2)
  self.ebLowHealthThreshold:SetMultiLine(false)
  self.ebLowHealthThreshold:SetNumeric(true)
  self.ebLowHealthThreshold:SetScript("OnEscapePressed", function() self.ebLowHealthThreshold:ClearFocus() end)
  self.ebLowHealthThreshold:SetTextInsets(5, 5, 0, 0)
  self.fsLowHealthThreshold = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsLowHealthThreshold:SetPoint("LEFT", self, "TOPLEFT", 65, yPos)
  self.fsLowHealthThreshold:SetText("Low Health %")

  self.ebCriticalHealthThreshold = CreateFrame("EditBox", nil, self, BackdropTemplateMixin and "BackdropTemplate");
  self.ebCriticalHealthThreshold:SetPoint("LEFT", self, "TOPLEFT", 204, yPos)
  self.ebCriticalHealthThreshold:SetSize(28, 20)
  self.ebCriticalHealthThreshold:SetFontObject(ChatFontNormal)
  self.ebCriticalHealthThreshold:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
  self.ebCriticalHealthThreshold:SetAutoFocus(false)
  self.ebCriticalHealthThreshold:SetMaxLetters(2)
  self.ebCriticalHealthThreshold:SetMultiLine(false)
  self.ebCriticalHealthThreshold:SetNumeric(true)
  self.ebCriticalHealthThreshold:SetScript("OnEscapePressed", function() self.ebCriticalHealthThreshold:ClearFocus() end)
  self.ebCriticalHealthThreshold:SetTextInsets(5, 5, 0, 0)
  self.fsCriticalHealthThreshold = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsCriticalHealthThreshold:SetPoint("LEFT", self, "TOPLEFT", 235, yPos)
  self.fsCriticalHealthThreshold:SetText("Critically Low Health %")
  yPos = yPos - 22

  self.cbEnableLowHealthAlertScreenFlashing = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertScreenFlashing:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsEnableLowHealthAlertScreenFlashing = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertScreenFlashing:SetPoint("LEFT", self, "TOPLEFT", 60, yPos)
  self.fsEnableLowHealthAlertScreenFlashing:SetText("Enable screen flashing.")

  self.cbEnableLowHealthAlertSounds = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableLowHealthAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 200, yPos)
  self.fsEnableLowHealthAlertSounds = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableLowHealthAlertSounds:SetPoint("LEFT", self, "TOPLEFT", 230, yPos)
  self.fsEnableLowHealthAlertSounds:SetText("Enable alert sounds.")
  yPos = yPos - 22

  self.fsLowHealthAlertNote = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsLowHealthAlertNote:SetPoint("LEFT", self, "TOPLEFT", 30, yPos)
  self.fsLowHealthAlertNote:SetText("Note: Chat messages and notification settings can be set in their respective sections.")
  yPos = yPos - 22

  self.cbEnableTextNotifications = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotifications:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsEnableTextNotifications = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotifications:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsEnableTextNotifications:SetText("Enable Onscreen Text Notifications")
  yPos = yPos - 22

  self.fsEnableTextNotificationsCombatTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsCombatTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsCombatTitle:SetText("Enter Combat")

  self.cbEnableTextNotificationsCombatSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsCombatSelf:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsCombatSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsCombatSelf:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsCombatSelf:SetText("You")

  self.cbEnableTextNotificationsCombatGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsCombatGroup:SetPoint("LEFT", self, "TOPLEFT", 350, yPos)
  self.fsEnableTextNotificationsCombatGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsCombatGroup:SetPoint("LEFT", self, "TOPLEFT", 380, yPos)
  self.fsEnableTextNotificationsCombatGroup:SetText("Party")
  yPos = yPos - 22

  self.fsEnableTextNotificationsConnectionTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsConnectionTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsConnectionTitle:SetText("Disconnect or Go Offline")

  self.cbEnableTextNotificationsConnectionSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsConnectionSelf:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsConnectionSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsConnectionSelf:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsConnectionSelf:SetText("You")

  self.cbEnableTextNotificationsConnectionGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsConnectionGroup:SetPoint("LEFT", self, "TOPLEFT", 350, yPos)
  self.fsEnableTextNotificationsConnectionGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsConnectionGroup:SetPoint("LEFT", self, "TOPLEFT", 380, yPos)
  self.fsEnableTextNotificationsConnectionGroup:SetText("Party*")
  yPos = yPos - 22

  self.fsEnableTextNotificationsLogoutTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLogoutTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsLogoutTitle:SetText("Logging Out")

  self.cbEnableTextNotificationsLogout = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLogout:SetPoint("LEFT", self, "TOPLEFT", 350, yPos)
  self.fsEnableTextNotificationsLogout = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLogout:SetPoint("LEFT", self, "TOPLEFT", 380, yPos)
  self.fsEnableTextNotificationsLogout:SetText("Party*")
  yPos = yPos - 22

  self.fsEnableTextNotificationsLowHealthTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLowHealthTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsLowHealthTitle:SetText("Low Health")
  self.fsEnableTextNotificationsLowHealthSubtitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.fsEnableTextNotificationsLowHealthSubtitle:SetPoint("LEFT", self, "TOPLEFT", 105, yPos)
  self.fsEnableTextNotificationsLowHealthSubtitle:SetText("(Requires Low Health Alerts)")
  
  self.cbEnableTextNotificationsLowHealthSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLowHealthSelf:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsLowHealthSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLowHealthSelf:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsLowHealthSelf:SetText("You")

  self.cbEnableTextNotificationsLowHealthGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLowHealthGroup:SetPoint("LEFT", self, "TOPLEFT", 350, yPos)
  self.fsEnableTextNotificationsLowHealthGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLowHealthGroup:SetPoint("LEFT", self, "TOPLEFT", 380, yPos)
  self.fsEnableTextNotificationsLowHealthGroup:SetText("Party")
  yPos = yPos - 22

  self.fsEnableTextNotificationsSpellcastsTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsSpellcastsTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsSpellcastsTitle:SetText("Cast Certain Spells")
  self.fsEnableTextNotificationsSpellcastsSubtitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.fsEnableTextNotificationsSpellcastsSubtitle:SetPoint("LEFT", self, "TOPLEFT", 148, yPos)
  self.fsEnableTextNotificationsSpellcastsSubtitle:SetText("(e.g. Hearthstone)")

  self.cbEnableTextNotificationsSpellcasts = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsSpellcasts:SetPoint("LEFT", self, "TOPLEFT", 350, yPos)
  self.fsEnableTextNotificationsSpellcasts = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsSpellcasts:SetPoint("LEFT", self, "TOPLEFT", 380, yPos)
  self.fsEnableTextNotificationsSpellcasts:SetText("Party")
  yPos = yPos - 22

  self.fsEnableTextNotificationsAurasTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsAurasTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsAurasTitle:SetText("Affected by Certain Threat-Altering Buffs")

  self.cbEnableTextNotificationsAurasSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsAurasSelf:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsAurasSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsAurasSelf:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsAurasSelf:SetText("You")

  self.cbEnableTextNotificationsAurasGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsAurasGroup:SetPoint("LEFT", self, "TOPLEFT", 420, yPos)
  self.fsEnableTextNotificationsAurasGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsAurasGroup:SetPoint("LEFT", self, "TOPLEFT", 450, yPos)
  self.fsEnableTextNotificationsAurasGroup:SetText("Any Nearby Player")
  yPos = yPos - 22

  self.fsEnableTextNotificationsLossOfControlTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLossOfControlTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsLossOfControlTitle:SetText("Crowd Controlled")
  self.fsEnableTextNotificationsLossOfControlSubtitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.fsEnableTextNotificationsLossOfControlSubtitle:SetPoint("LEFT", self, "TOPLEFT", 143, yPos)
  self.fsEnableTextNotificationsLossOfControlSubtitle:SetText("(e.g. stunned, silenced)")

  self.cbEnableTextNotificationsLossOfControlSelf = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLossOfControlSelf:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsLossOfControlSelf = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLossOfControlSelf:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsLossOfControlSelf:SetText("You")

  self.cbEnableTextNotificationsLossOfControlGroup = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsLossOfControlGroup:SetPoint("LEFT", self, "TOPLEFT", 350, yPos)
  self.fsEnableTextNotificationsLossOfControlGroup = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsLossOfControlGroup:SetPoint("LEFT", self, "TOPLEFT", 380, yPos)
  self.fsEnableTextNotificationsLossOfControlGroup:SetText("Party*")
  yPos = yPos - 22

  self.fsEnableTextNotificationsPvpFlaggedTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsPvpFlaggedTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsPvpFlaggedTitle:SetText("Flagged for PvP")

  self.cbEnableTextNotificationsPvpFlagged = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsPvpFlagged:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsPvpFlagged = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsPvpFlagged:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsPvpFlagged:SetText("You")
  yPos = yPos - 22

  self.fsEnableTextNotificationsExtraAttacksStoredTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsExtraAttacksStoredTitle:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsEnableTextNotificationsExtraAttacksStoredTitle:SetText("Extra Attacks Stored")

  self.cbEnableTextNotificationsExtraAttacksStored = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbEnableTextNotificationsExtraAttacksStored:SetPoint("LEFT", self, "TOPLEFT", 280, yPos)
  self.fsEnableTextNotificationsExtraAttacksStored = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsEnableTextNotificationsExtraAttacksStored:SetPoint("LEFT", self, "TOPLEFT", 310, yPos)
  self.fsEnableTextNotificationsExtraAttacksStored:SetText("Enemies In Combat")
  yPos = yPos - 22

  self.fsNotificationsAsteriskNote = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsNotificationsAsteriskNote:SetPoint("LEFT", self, "TOPLEFT", 34, yPos)
  self.fsNotificationsAsteriskNote:SetText("*: Requires other player to have Safeguard installed.")
  yPos = yPos - 22

  self.cbForceFloatingCombatText = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbForceFloatingCombatText:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsForceFloatingCombatText = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsForceFloatingCombatText:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsForceFloatingCombatText:SetText("Force \"Floating Combat Text\" interface option to be enabled.")
  yPos = yPos - 22

  self.cbShowIconsOnRaidFrames = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate") 
  self.cbShowIconsOnRaidFrames:SetPoint("LEFT", self, "TOPLEFT", 10, yPos)
  self.fsShowIconsOnRaidFrames = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  self.fsShowIconsOnRaidFrames:SetPoint("LEFT", self, "TOPLEFT", 40, yPos)
  self.fsShowIconsOnRaidFrames:SetText("Show Icons on Raid Frames")
  yPos = yPos - 22
end

function Safeguard_OptionWindow:LoadOptions()
  self.cbEnableChatMessages:SetChecked(Safeguard_Settings.Options.EnableChatMessages)
  self.cbEnableChatMessagesLogout:SetChecked(Safeguard_Settings.Options.EnableChatMessagesLogout)
  self.cbEnableChatMessagesLowHealth:SetChecked(Safeguard_Settings.Options.EnableChatMessagesLowHealth)
  self.cbEnableChatMessagesSpellCasts:SetChecked(Safeguard_Settings.Options.EnableChatMessagesSpellCasts)
  self.cbEnableChatMessagesLossOfControl:SetChecked(Safeguard_Settings.Options.EnableChatMessagesLossOfControl)
  self.cbEnableDangerousNpcAlerts:SetChecked(Safeguard_Settings.Options.EnableDangerousNpcAlerts)
  self.ebDangerousNpcNormalLevelOffset:SetNumber(Safeguard_Settings.Options.DangerousNpcNormalLevelOffset)
  self.ebDangerousNpcSpecialLevelOffset:SetNumber(Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset)
  self.cbEnableDangerousNpcAlertWindow:SetChecked(Safeguard_Settings.Options.EnableDangerousNpcAlertWindow)
  self.cbEnableDangerousNpcAlertSounds:SetChecked(Safeguard_Settings.Options.EnableDangerousNpcAlertSounds)
  self.cbEnableLowHealthAlerts:SetChecked(Safeguard_Settings.Options.EnableLowHealthAlerts)
  self.ebLowHealthThreshold:SetNumber(Safeguard_Settings.Options.ThresholdForLowHealth * 100)
  self.ebCriticalHealthThreshold:SetNumber(Safeguard_Settings.Options.ThresholdForCriticallyLowHealth * 100)
  self.cbEnableLowHealthAlertScreenFlashing:SetChecked(Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing)
  self.cbEnableLowHealthAlertSounds:SetChecked(Safeguard_Settings.Options.EnableLowHealthAlertSounds)
  self.cbEnableTextNotifications:SetChecked(Safeguard_Settings.Options.EnableTextNotifications)
  self.cbEnableTextNotificationsCombatSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsCombatSelf)
  self.cbEnableTextNotificationsCombatGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsCombatGroup)
  self.cbEnableTextNotificationsConnectionSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsConnectionSelf)
  self.cbEnableTextNotificationsConnectionGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsConnectionGroup)
  self.cbEnableTextNotificationsLogout:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLogout)
  self.cbEnableTextNotificationsLowHealthSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLowHealthSelf)
  self.cbEnableTextNotificationsLowHealthGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLowHealthGroup)
  self.cbEnableTextNotificationsSpellcasts:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsSpellcasts)
  self.cbEnableTextNotificationsAurasSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsAurasSelf)
  self.cbEnableTextNotificationsAurasGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsAurasGroup)
  self.cbEnableTextNotificationsLossOfControlSelf:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLossOfControlSelf)
  self.cbEnableTextNotificationsLossOfControlGroup:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsLossOfControlGroup)
  self.cbEnableTextNotificationsPvpFlagged:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsPvpFlagged)
  self.cbEnableTextNotificationsExtraAttacksStored:SetChecked(Safeguard_Settings.Options.EnableTextNotificationsExtraAttacksStored)
  self.cbForceFloatingCombatText:SetChecked(Safeguard_Settings.Options.ForceFloatingCombatText)
  self.cbShowIconsOnRaidFrames:SetChecked(Safeguard_Settings.Options.ShowIconsOnRaidFrames)

  self.OptionsLoaded = true
end

function Safeguard_OptionWindow:SaveOptions()
  if (not self.OptionsLoaded) then
    return
  end

  if (self.ebLowHealthThreshold:GetNumber() < 2) then
    self.ebLowHealthThreshold:SetNumber(2)
  end
  
  if (self.ebCriticalHealthThreshold:GetNumber() < 1) then
    self.ebCriticalHealthThreshold:SetNumber(1)
  end
  if (self.ebCriticalHealthThreshold:GetNumber() >= self.ebLowHealthThreshold:GetNumber()) then
    self.ebCriticalHealthThreshold:SetNumber(self.ebLowHealthThreshold:GetNumber() - 1)
  end

  local shouldStartDangerousNpcCheckInterval = not Safeguard_Settings.Options.EnableDangerousNpcAlerts and self.cbEnableDangerousNpcAlerts:GetChecked()
  local shouldUpdateDangerousNpcsWindow = Safeguard_Settings.Options.EnableDangerousNpcAlerts ~= self.cbEnableDangerousNpcAlerts:GetChecked() or
    Safeguard_Settings.Options.DangerousNpcNormalLevelOffset ~= self.ebDangerousNpcNormalLevelOffset:GetNumber() or
    Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset ~= self.ebDangerousNpcSpecialLevelOffset:GetNumber() or
    Safeguard_Settings.Options.EnableDangerousNpcAlertWindow ~= self.cbEnableDangerousNpcAlertWindow:GetChecked()
  local shouldUpdateRaidFrames = Safeguard_Settings.Options.ShowIconsOnRaidFrames ~= self.cbShowIconsOnRaidFrames:GetChecked()
  
  Safeguard_Settings.Options.EnableChatMessages = self.cbEnableChatMessages:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesLogout = self.cbEnableChatMessagesLogout:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesLowHealth = self.cbEnableChatMessagesLowHealth:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesSpellCasts = self.cbEnableChatMessagesSpellCasts:GetChecked()
  Safeguard_Settings.Options.EnableChatMessagesLossOfControl = self.cbEnableChatMessagesLossOfControl:GetChecked()
  Safeguard_Settings.Options.EnableDangerousNpcAlerts = self.cbEnableDangerousNpcAlerts:GetChecked()
  Safeguard_Settings.Options.DangerousNpcNormalLevelOffset = self.ebDangerousNpcNormalLevelOffset:GetNumber()
  Safeguard_Settings.Options.DangerousNpcSpecialLevelOffset = self.ebDangerousNpcSpecialLevelOffset:GetNumber()
  Safeguard_Settings.Options.EnableDangerousNpcAlertWindow = self.cbEnableDangerousNpcAlertWindow:GetChecked()
  Safeguard_Settings.Options.EnableDangerousNpcAlertSounds = self.cbEnableDangerousNpcAlertSounds:GetChecked()
  Safeguard_Settings.Options.EnableLowHealthAlerts = self.cbEnableLowHealthAlerts:GetChecked()  
  Safeguard_Settings.Options.ThresholdForLowHealth = self.ebLowHealthThreshold:GetNumber() / 100
  Safeguard_Settings.Options.ThresholdForCriticallyLowHealth = self.ebCriticalHealthThreshold:GetNumber() / 100
  Safeguard_Settings.Options.EnableLowHealthAlertScreenFlashing = self.cbEnableLowHealthAlertScreenFlashing:GetChecked()
  Safeguard_Settings.Options.EnableLowHealthAlertSounds = self.cbEnableLowHealthAlertSounds:GetChecked()
  Safeguard_Settings.Options.EnableTextNotifications = self.cbEnableTextNotifications:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsCombatSelf = self.cbEnableTextNotificationsCombatSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsCombatGroup = self.cbEnableTextNotificationsCombatGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsConnectionSelf = self.cbEnableTextNotificationsConnectionSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsConnectionGroup = self.cbEnableTextNotificationsConnectionGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLogout = self.cbEnableTextNotificationsLogout:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLowHealthSelf = self.cbEnableTextNotificationsLowHealthSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLowHealthGroup = self.cbEnableTextNotificationsLowHealthGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsSpellcasts = self.cbEnableTextNotificationsSpellcasts:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsAurasSelf = self.cbEnableTextNotificationsAurasSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsAurasGroup = self.cbEnableTextNotificationsAurasGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLossOfControlSelf = self.cbEnableTextNotificationsLossOfControlSelf:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsLossOfControlGroup = self.cbEnableTextNotificationsLossOfControlGroup:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsPvpFlagged = self.cbEnableTextNotificationsPvpFlagged:GetChecked()
  Safeguard_Settings.Options.EnableTextNotificationsExtraAttacksStored = self.cbEnableTextNotificationsExtraAttacksStored:GetChecked()
  Safeguard_Settings.Options.ForceFloatingCombatText = self.cbForceFloatingCombatText:GetChecked()
  Safeguard_Settings.Options.ShowIconsOnRaidFrames = self.cbShowIconsOnRaidFrames:GetChecked()
  
  if (shouldStartDangerousNpcCheckInterval) then
    Safeguard_IntervalManager:CheckDangerousEnemiesInterval()
  end
  if (shouldUpdateDangerousNpcsWindow) then
    Safeguard_DangerousNpcsWindow:Update({})
    Safeguard_IntervalManager.DangerousEnemiesVariables = {}
  end
  if (shouldUpdateRaidFrames) then Safeguard_RaidFramesManager:UpdateRaidFrames() end
end

Safeguard_OptionWindow:SetScript("OnShow", function(self)
  Safeguard_OptionWindow:LoadOptions()
end)    

Safeguard_OptionWindow.name = "Safeguard"
Safeguard_OptionWindow.cancel = function() Safeguard_OptionWindow:LoadOptions() end
Safeguard_OptionWindow.default = function() print("[Safeguard] Not implemented.") end
Safeguard_OptionWindow.okay = function() Safeguard_OptionWindow:SaveOptions() end
InterfaceOptions_AddCategory(Safeguard_OptionWindow)
