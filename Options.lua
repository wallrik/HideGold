local addonName, addon = ...

function addon.createOptionsPanel(title, subtext)
	local optionsPanel = CreateFrame("Frame")
	optionsPanel:Hide()
	optionsPanel.name = addonName

	local fontTitle = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	fontTitle:SetJustifyH("LEFT")
	fontTitle:SetJustifyV("TOP")
	fontTitle:SetPoint("TOPLEFT", 16, -16)
	fontTitle:SetText(title or GetAddOnMetadata(addonName,"title"))

	local fontSubText = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	fontSubText:SetNonSpaceWrap(true)
	fontSubText:SetMaxLines(3)
	fontSubText:SetJustifyH("LEFT")
	fontSubText:SetJustifyV("TOP")
	fontSubText:SetHeight(32)
	fontSubText:SetPoint("TOPLEFT", fontTitle, "BOTTOMLEFT", 0, -8)
	fontSubText:SetPoint("RIGHT", -32, 0)
	fontSubText:SetText(subtext or GetAddOnMetadata(addonName,"notes"))

	_G.InterfaceOptions_AddCategory(optionsPanel)
	return optionsPanel
end

function addon.createOptionsButton(parent, labelText, tooltipText, smallText)
	local checkButton = CreateFrame("CheckButton", nil, parent)
	checkButton:SetWidth(26)
	checkButton:SetHeight(26)
	checkButton:SetNormalTexture(130755) -- "Interface\\Buttons\\UI-CheckBox-Up"
	checkButton:SetPushedTexture(130752) -- "Interface\\Buttons\\UI-CheckBox-Down"
	checkButton:SetHighlightTexture(130753,"ADD") -- "Interface\\Buttons\\UI-CheckBox-Highlight"
	checkButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check") -- 130751
	checkButton:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled") -- 130750
	checkButton:SetHitRectInsets(0, -100, 0, 0)

	if smallText then
		checkButton.label = checkButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		checkButton.label:SetPoint("LEFT", checkButton, "RIGHT", 2, 1)
	else
		checkButton.label = checkButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
		checkButton.label:SetPoint("LEFT", checkButton, "RIGHT", 0, 1)
	end
	checkButton.label:SetText(labelText)

	checkButton:SetScript("OnDisable", function(self)
		local fontColor = _G.GRAY_FONT_COLOR
		self.label:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
	end)
	checkButton:SetScript("OnEnable", function(self)
		local fontColor = _G.HIGHLIGHT_FONT_COLOR
		self.label:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
	end)

	checkButton:SetScript("OnClick", function(self)
		if self.OnClick then
			if self:GetChecked() then
				_G.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				self:OnClick(true)
			else
				_G.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				self:OnClick(false)
			end
		end
	end)

	if tooltipText then
		checkButton:SetScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			_G.GameTooltip:SetText(tooltipText, nil, nil, nil, nil, true)
		end)
		checkButton:SetScript("OnLeave", function()
			_G.GameTooltip:Hide()
		end)
	end

	return checkButton
end
