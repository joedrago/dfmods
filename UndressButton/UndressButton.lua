-- albin
BINDING_NAME_UndressButtonName = "Dress up target";
BINDING_HEADER_UndressButtonHeader = "Undress Button";

function UndressButton_Load(self)
	if (not SideDressUpFrame) then  --4.3 changes (frame names have changed)
		self:RegisterEvent("ADDON_LOADED");
	end
end

function UndressButton_Event(self,event,...)
	local arg1 = ...;
	if (event == "ADDON_LOADED") then
		if (arg1 == "Blizzard_AuctionUI") then
			self:UnregisterEvent("ADDON_LOADED");
		end
	end
end

function UndressButton_DressUpTarget(x)



	if (not DressUpFrame:IsVisible()) then
		ShowUIPanel(DressUpFrame);
	else
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
	end
	if (x == "inspect") then
		if(UnitIsVisible("target") and UnitIsPlayer("target")) then
			SetPortraitTexture(DressUpFramePortrait, "target");
			SetDressUpTargetBackground();
			local actor = DressUpFrame.ModelScene:GetPlayerActor();
			actor:SetModelByUnit("target");
		end
	elseif (x == "dress") then
		if(UnitIsVisible("target") and UnitIsPlayer("target")) then
			local actor = DressUpFrame.ModelScene:GetPlayerActor();
			actor:SetModelByUnit("target");
			actor:Undress();
			UndressButton_Inspect("target");
		else
			-- UndressButton_Reset();
			UndressButton_Inspect("player");
		end
	end
end

function UndressButton_Inspect(unit)
	local slots = {
		"HeadSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot",
		"HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "MainHandSlot", "SecondaryHandSlot"
	}; -- "NeckSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "RangedSlot" left out for obvious reasons
	
	NotifyInspect(unit);

	for _, slot in ipairs(slots) do
		DressUpItemLink(GetInventoryItemLink(unit, GetInventorySlotInfo(slot)));
	end

	if (not InspectFrame or not InspectFrame:IsVisible()) then
		ClearInspectPlayer();
	end
end

local function DressUpTargetTexturePath()
	local race, fileName = UnitRace("target");

	if ( not fileName ) then
		fileName = "Orc";
	end

	return "Interface\\DressUpFrame\\DressUpBackground-"..fileName;
end

function SetDressUpTargetBackground()
end

local function DressUpPlayerTexturePath()
	local race, fileName = UnitRace("player");

	if ( not fileName ) then
		fileName = "Orc";
	end

	return "Interface\\DressUpFrame\\DressUpBackground-"..fileName;
end
