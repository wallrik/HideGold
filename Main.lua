local addonName, addon, addonOptions = ...
local optionsPanel = addon.createOptionsPanel()
local buttonBackpack = addon.createOptionsButton(optionsPanel, "Hide in backpack", "Automatically hide gold in your backpack.")
local buttonVendor = addon.createOptionsButton(optionsPanel, "Hide in vendor", "Automatically hide gold in the vendor frame.")
local buttonMail = addon.createOptionsButton(optionsPanel, "Hide in mailbox", "Automatically hide gold in the send mail frame.")
local buttonBank = addon.createOptionsButton(optionsPanel, "Hide in bank", "Automatically hide gold in the bank frame.")
local buttonAuction = addon.createOptionsButton(optionsPanel, "Hide in auction house", "Automatically hide gold in the auction house frame.")
local buttonTrainer = addon.createOptionsButton(optionsPanel, "Hide in class trainer", "Automatically hide gold in the class trainer frame.")

buttonBackpack:SetPoint("TOPLEFT", 14, -80)
buttonVendor:SetPoint("TOPLEFT", buttonBackpack, "BOTTOMLEFT", 0, -8)
buttonMail:SetPoint("TOPLEFT", buttonVendor, "BOTTOMLEFT", 0, -8)
buttonBank:SetPoint("TOPLEFT", buttonMail, "BOTTOMLEFT", 0, -8)
buttonAuction:SetPoint("TOPLEFT", buttonBank, "BOTTOMLEFT", 0, -8)
buttonTrainer:SetPoint("TOPLEFT", buttonAuction, "BOTTOMLEFT", 0, -8)

_G.SLASH_HIDEGOLD1 = "/hidegold"
_G.SLASH_HIDEGOLD2 = "/goldhide"
_G.SlashCmdList["HIDEGOLD"] = function()
	if optionsPanel then
		if not _G.InterfaceOptionsFrame:IsShown() then
			_G.InterfaceOptionsFrame:Show()
		end
		_G.InterfaceOptionsFrame_OpenToCategory(optionsPanel)
	end
end

buttonBackpack.OnClick = function(_,isChecked)
	if isChecked then
		addonOptions.HideBackpack = true
	else
		addonOptions.HideBackpack = nil
	end
end
buttonVendor.OnClick = function(_,isChecked)
	if isChecked then
		addonOptions.HideVendor = true
		_G.MerchantMoneyFrame:Hide()
	else
		addonOptions.HideVendor = nil
		_G.MerchantMoneyFrame:Show()
	end
end
buttonMail.OnClick = function(_,isChecked)
	if isChecked then
		addonOptions.HideMail = true
		_G.SendMailMoneyFrame:Hide()
	else
		addonOptions.HideMail = nil
		_G.SendMailMoneyFrame:Show()
	end
end
buttonBank.OnClick = function(_,isChecked)
	if isChecked then
		addonOptions.HideBank = true
		_G.BankFrameMoneyFrame:Hide()
	else
		addonOptions.HideBank = nil
		_G.BankFrameMoneyFrame:Show()
	end
end
buttonAuction.OnClick = function(_,isChecked)
	if isChecked then
		addonOptions.HideAuction = true
		if _G.AuctionFrameMoneyFrame then
			_G.AuctionFrameMoneyFrame:Hide()
			_G.AuctionFrameMoneyFrame:SetAlpha(0)
		end
	else
		addonOptions.HideAuction = nil
		if _G.AuctionFrameMoneyFrame then
			_G.AuctionFrameMoneyFrame:Show()
			_G.AuctionFrameMoneyFrame:SetAlpha(1)
		end
	end
end
buttonTrainer.OnClick = function(_,isChecked)
	if isChecked then
		addonOptions.HideTrainer = true
		if _G.AuctionFrameMoneyFrame then
			_G.ClassTrainerMoneyFrame:Hide()
			_G.ClassTrainerMoneyFrame:SetAlpha(0)
		end
	else
		addonOptions.HideTrainer = nil
		if _G.AuctionFrameMoneyFrame then
			_G.ClassTrainerMoneyFrame:Show()
			_G.ClassTrainerMoneyFrame:SetAlpha(1)
		end
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_,_,name)
	if name == addonName then
		addonOptions = _G[addonName]
		if not addonOptions then
			addonOptions = {}
			_G[addonName] = addonOptions
		end
		if addonOptions.HideBackpack then buttonBackpack:Click() end
		if addonOptions.HideVendor then buttonVendor:Click() end
		if addonOptions.HideMail then buttonMail:Click() end
		if addonOptions.HideBank then buttonBank:Click() end
		if addonOptions.HideAuction then buttonAuction:Click() end
		if addonOptions.HideTrainer then buttonTrainer:Click() end
	elseif name == "Blizzard_AuctionUI" then
		if addonOptions.HideAuction then
			_G.AuctionFrameMoneyFrame:Hide()
			_G.AuctionFrameMoneyFrame:SetAlpha(0)
		end
	elseif name == "Blizzard_TrainerUI" then
		if addonOptions.HideTrainer then 
			_G.ClassTrainerMoneyFrame:Hide()
			_G.ClassTrainerMoneyFrame:SetAlpha(0)
		end
	end
end)

local BackpackMoneyFrame_OnShow = function(self)
	if addonOptions.HideBackpack then
		self:Hide()
	end
end

for i=1,13 do
	_G["ContainerFrame".. i .."MoneyFrame"]:HookScript("OnShow", BackpackMoneyFrame_OnShow)
end
