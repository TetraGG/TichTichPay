--------------------------------------
-- Namespaces
--------------------------------------

local addonName, Core = ...;
Core.Config = {};

local Config = Core.Config;
local UIMenu;

Config.State = {};
local State = Config.State;

State.Enum = {
    INITIAL = 1,
    BANK = 2,
    WITHDRAW = 3,
    MAIL = 4,
    PAYING = 5,
    DONE = 6
}

State.Message = {
    "Welcome, to start payments you have to go to the guild bank and open it.",
    "Now that the guild bank is open, you can press \"Withdraw\".",
    "You have withdrawn the necessary money, you can go to a mailbox and open it to continue.",
    "Now keep the mail open and press \"Pay\" to pay all people in the list.",
    "You are now paying, please wait.",
    "You have completed the payments, you can now go to another server or log out."
}

--------------------------------------
-- Defaults
--------------------------------------

local defaults = {
    theme = {
        r = 0.44705882352941176470588235294118,
        g = 0.44705882352941176470588235294118,
        b = 0.85490196078431372549019607843137,
        hex = "7289da"
    },
    error = {
        r = 0.90196078431372549019607843137255,
        g = 0,
        b = 0,
        hex = "e60000"
    },
    MainFrame = {
        height = 810,
        width = 480,
    }
}

--------------------------------------
-- Event Handlers
--------------------------------------

local function EscapeHandler(self, key)
    if (key == "ESCAPE") then
        self:SetPropagateKeyboardInput(false);
        if (self:IsShown()) then
            self:SetShown(false);
        end
    else
        self:SetPropagateKeyboardInput(true);
    end
end

--------------------------------------
-- Init functions
--------------------------------------

local function InitState(obj)
    obj.CurrentFaction, _ = UnitFactionGroup("Player");
    obj.CurrentServer = string.lower(GetCurrentRegionName() .. "-" .. GetNormalizedRealmName());
end

--------------------------------------
-- Config functions
--------------------------------------

function Config:Toggle()
    local menu = TichTichPayUI or Config:CreateMenu();
    menu:SetShown(not menu:IsShown());
end

function Config:GetThemeColor()
    local c = defaults.theme;
    return c.r, c.g, c.b, c.hex;
end

function Config:GetErrorColor()
    local c = defaults.error;
    return c.r, c.g, c.b, c.hex;
end

function Config:GetMessage()
    return State.Message[Core.TichTichPayDB:GetState()];
end

function Config:UpdateMessage()
    UIMenu.IndicationText:SetText(Config:GetMessage());
end

function Config:CreateButton(point, parentFrame, relativeFrame, relativePoint, xOffset, yOffset, text)
    local btn = CreateFrame("Button", nil, parentFrame, "GameMenuButtonTemplate");
    btn:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
    btn:SetSize(defaults.MainFrame.width * 2 / 5, defaults.MainFrame.height / 20);
    btn:SetText(text);
    btn:SetNormalFontObject("GameFontNormalLarge");
    btn:SetHighlightFontObject("GameFontHighlightLarge");
    btn:Disable();
    return btn;
end

local function FormatInteger(integer)
    local str = tostring(integer);
    local mod = #str % 3;
    local res = "";
    res = res .. str:sub(0, mod);
    for i = 1 + mod, #str, 3 do
        res = res .. " " .. str:sub(i, i + 3);
    end
    return res;
end

local function ScrollFrame_Update()
    local items = Core.TichTichPayDB:GetList();
    local buttons = HybridScrollFrame_GetButtons(TichTichPayUIScrollFrame);
    local offset = HybridScrollFrame_GetOffset(TichTichPayUIScrollFrame);

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex];
        local itemIndex = buttonIndex + offset;

        if itemIndex <= #items then
            local item = items[itemIndex];
            button.Name:SetText(item.name);
            button.Gold:SetText(FormatInteger(item.gold));
            if (item.payed) then
                button.Gold:SetTextColor(0, 0.9, 0);
            else
                button.Gold:SetTextColor(0.9, 0, 0);
            end
            button.Payed:SetChecked(item.payed);
            button:SetWidth(TichTichPayUIScrollFrame.scrollChild:GetWidth());
            button:Show();
        else
            button:Hide();
        end
    end

    local buttonHeight = TichTichPayUIScrollFrame.buttonHeight;
    local totalHeight = #items * buttonHeight;
    local shownHeight = #buttons * buttonHeight;
    HybridScrollFrame_Update(TichTichPayUIScrollFrame, totalHeight, shownHeight);
end

function Config:CreateMenu(self)
    InitState(State);

    -- Main Frame

    UIMenu = CreateFrame("Frame", "TichTichPayUI", UIParent, "PortraitFrameTemplate");
    UIMenu:SetSize(defaults.MainFrame.width, defaults.MainFrame.height);
    UIMenu:SetPoint("CENTER");
    UIMenu:SetTitle("TichTichPay");
    UIMenu.portrait:SetTexture("Interface\\Addons\\TichTichPay\\Ressources\\Icon.blp");

    UIMenu:SetMovable(true)
    UIMenu:EnableMouse(true)
    UIMenu:SetClampedToScreen(true)
    UIMenu:RegisterForDrag("LeftButton")
    UIMenu:SetScript("OnDragStart", UIMenu.StartMoving)
    UIMenu:SetScript("OnDragStop", UIMenu.StopMovingOrSizing)
    UIMenu:SetScript("OnKeyDown", EscapeHandler);

    -- Location Text

    UIMenu.LocationText = UIMenu:CreateFontString(nil, "OVERLAY", "TichTichPayBlue");
    UIMenu.LocationText:SetPoint("TOP", UIMenu.TitleBg);
    UIMenu.LocationText:SetPoint("LEFT", UIMenu, 5, 0);
    UIMenu.LocationText:SetPoint("RIGHT", UIMenu, -5, 0);
    UIMenu.LocationText:SetHeight(defaults.MainFrame.height * 1 / 20);
    UIMenu.LocationText:SetJustifyH("CENTER");
    UIMenu.LocationText:SetJustifyV("BOTTOM");
    UIMenu.LocationText:SetText("Currently on " .. State.CurrentFaction .. " " .. State.CurrentServer);

    -- Information text

    UIMenu.InformationText = UIMenu:CreateFontString(nil, "OVERLAY", "TichTichPayWhite");
    UIMenu.InformationText:SetPoint("TOPLEFT", UIMenu.LocationText, "BOTTOMLEFT")
    UIMenu.InformationText:SetPoint("TOPRIGHT", UIMenu.LocationText, "BOTTOMRIGHT")
    UIMenu.InformationText:SetText("You will pay " .. Core.TichTichPayDB:GetPeople() .. " people for a total of " .. Core.TichTichPayDB:GetGold() .. " golds.");
    UIMenu.InformationText:SetJustifyH("CENTER");
    UIMenu.InformationText:SetJustifyV("CENTER");
    UIMenu.InformationText:SetWordWrap(true);
    UIMenu.InformationText:SetHeight(defaults.MainFrame.height * 2 / 20);

    -- Header

    UIMenu.HeaderNameButton = CreateFrame("Button", "$parentHeaderNameButton", UIMenu, "WhoFrameColumnHeaderTemplate");
    UIMenu.HeaderNameButton:SetText("Name");
    UIMenu.HeaderNameButton:ClearAllPoints();
    UIMenu.HeaderNameButton:SetPoint("TOPLEFT", UIMenu.InformationText, "BOTTOMLEFT");
    UIMenu.HeaderNameButton:SetWidth(UIMenu:GetWidth() / 2 - 15 - 15);
    UIMenu.HeaderNameButton.Middle:SetWidth(UIMenu:GetWidth() / 2 - 15 - 9 - 15);
    UIMenu.HeaderGoldButton = CreateFrame("Button", "$parentHeaderGoldButton", UIMenu, "WhoFrameColumnHeaderTemplate");
    UIMenu.HeaderGoldButton:SetText("Golds");
    UIMenu.HeaderGoldButton:ClearAllPoints();
    UIMenu.HeaderGoldButton:SetPoint("TOPLEFT", UIMenu.HeaderNameButton, "TOPRIGHT", -2, 0);
    UIMenu.HeaderGoldButton:SetWidth(UIMenu:GetWidth() / 2 - 15 - 15);
    UIMenu.HeaderGoldButton.Middle:SetWidth(UIMenu:GetWidth() / 2 - 15 - 9 - 15);
    UIMenu.HeaderCheckButton = CreateFrame("Button", "$parentHeaderCheckButton", UIMenu, "WhoFrameColumnHeaderTemplate");
    UIMenu.HeaderCheckButton:SetText("P.");
    UIMenu.HeaderCheckButton:ClearAllPoints();
    UIMenu.HeaderCheckButton:SetPoint("TOPLEFT", UIMenu.HeaderGoldButton, "TOPRIGHT", -2, 0);
    UIMenu.HeaderCheckButton:SetPoint("TOPRIGHT", UIMenu.InformationText, "BOTTOMRIGHT", -21, 0);
    UIMenu.HeaderCheckButton.Middle:SetWidth(22);

    -- List of People

    UIMenu.ScrollFrame = CreateFrame('ScrollFrame', "$parentScrollFrame", UIMenu, 'HybridScrollFrameTemplate')
    UIMenu.ScrollFrame:SetPoint("TOPLEFT", UIMenu.HeaderNameButton, "BOTTOMLEFT");
    UIMenu.ScrollFrame:SetPoint("TOPRIGHT", UIMenu.HeaderCheckButton, "BOTTOMRIGHT");
    UIMenu.ScrollFrame:SetHeight(defaults.MainFrame.height * 13 / 20);
    UIMenu.ScrollFrame.buttonHeight = (defaults.MainFrame.height * 1 / 20);
    UIMenu.ScrollFrame.update = ScrollFrame_Update;
    HybridScrollFrame_SetDoNotHideScrollBar(UIMenu.ScrollFrame, true);

    UIMenu.ScrollFrame.ScrollBar = CreateFrame('Slider', "$parentScrollBar", UIMenu.ScrollFrame, 'HybridScrollBarTemplate')
    UIMenu.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIMenu.ScrollFrame, "TOPRIGHT", 0, 0);
    UIMenu.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIMenu.ScrollFrame, "BOTTOMRIGHT", 21, 0);
    HybridScrollFrame_CreateButtons(UIMenu.ScrollFrame, "TichTichScrollListButtonTemplate", 0, 0, "TOP", "TOP", 0, 0, "TOP", "BOTTOM")
    UIMenu.ScrollFrame.update();
    if (#Core.TichTichPayDB:GetList() < 18) then
        UIMenu.ScrollFrame.ScrollBar:Disable();
        TichTichPayUIScrollFrameScrollBarScrollUpButton:Disable();
        TichTichPayUIScrollFrameScrollBarScrollDownButton:Disable();
        UIMenu.ScrollFrame.ScrollBar:Show();
    end

    UIMenu.ScrollFrame.Texture = UIMenu.ScrollFrame:CreateTexture(nil, "BACKGROUND");
    UIMenu.ScrollFrame.Texture:SetPoint("TOPLEFT", UIMenu.ScrollFrame, "TOPLEFT", 1, 0);
    UIMenu.ScrollFrame.Texture:SetPoint("BOTTOM", UIMenu.ScrollFrame, "BOTTOMRIGHT");
    UIMenu.ScrollFrame.Texture:SetPoint("RIGHT", UIMenu.ScrollFrame.ScrollBar, "RIGHT");
    UIMenu.ScrollFrame.Texture:SetTexture("Interface\\FriendsFrame\\UI-Toast-Background");

    -- Indication text

    UIMenu.IndicationText = UIMenu:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    UIMenu.IndicationText:SetPoint("TOPLEFT", UIMenu.ScrollFrame, "BOTTOMLEFT")
    UIMenu.IndicationText:SetPoint("TOPRIGHT", UIMenu.ScrollFrame.ScrollBar, "BOTTOMRIGHT")
    UIMenu.IndicationText:SetText(Config:GetMessage());
    UIMenu.IndicationText:SetJustifyH("CENTER");
    UIMenu.IndicationText:SetJustifyV("CENTER");
    UIMenu.IndicationText:SetWordWrap(true);
    UIMenu.IndicationText:SetHeight(defaults.MainFrame.height * 2 / 20);

    -- Buttons

    UIMenu.WithdrawButton = Config:CreateButton("TOPLEFT", UIMenu, UIMenu.IndicationText, "BOTTOMLEFT", 0, 0, "Withdraw")
    UIMenu.WithdrawButton:RegisterEvent("GUILDBANKFRAME_OPENED");
    UIMenu.WithdrawButton:RegisterEvent("GUILDBANKFRAME_CLOSED");
    UIMenu.WithdrawButton:SetScript("OnEvent", Core.Bank.OnEvent)
    UIMenu.WithdrawButton:RegisterForClicks("AnyUp");
    UIMenu.WithdrawButton:SetScript("OnClick", Core.Bank.OnClick);

    UIMenu.PayButton = Config:CreateButton("TOPRIGHT", UIMenu, UIMenu.IndicationText, "BOTTOMRIGHT", 0, 0, "Pay")
    UIMenu.PayButton:RegisterEvent("MAIL_SHOW");
    UIMenu.PayButton:RegisterEvent("MAIL_CLOSED");
    UIMenu.PayButton:RegisterEvent("MAIL_SUCCESS");
    UIMenu.PayButton:RegisterEvent("MAIL_FAILED");
    UIMenu.PayButton:SetScript("OnEvent", Core.Mail.OnEvent)
    UIMenu.PayButton:RegisterForClicks("AnyUp");
    UIMenu.PayButton:SetScript("OnClick", Core.Mail.OnClick);

    UIMenu:Hide();
    return UIMenu;
end