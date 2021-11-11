--------------------------------------
-- Namespaces
--------------------------------------

local addonName, Core = ...;
local Config = Core.Config;
local State = Config.State;

--------------------------------------
-- Custom Slash Command
--------------------------------------

Core.commands = {
    ["help"] = function()
        print(" ");
        Core:Print("Welcome to TichTichPay AddOn")
        Core:Print("|cff00cc66/ttp|r - Toggle menu");
        Core:Print("|cff00cc66/ttp help|r - Shows this help");
        print(" ");
    end
};

local function HandleSlashCommands(str)
    if (#str == 0) then
        -- User just entered "/ttp" with no additional args.
        Config:Toggle();
        return;
    end

    local args = {};
    for _, arg in ipairs({ string.split(' ', str) }) do
        if (#arg > 0) then
            table.insert(args, arg);
        end
    end

    local path = Core.commands; -- required for updating found table.

    for id, arg in ipairs(args) do
        if (#arg > 0) then -- if string length is greater than 0.
            arg = arg:lower();
            if (path[arg]) then
                if (type(path[arg]) == "function") then
                    -- all remaining args passed to our function!
                    path[arg](select(id + 1, unpack(args)));
                    return;
                elseif (type(path[arg]) == "table") then
                    path = path[arg]; -- another sub-table found!
                end
            else
                -- does not exist!
                Core.commands.help();
                return;
            end
        end
    end
end

----------------------
-- Event Hanlers
----------------------

function Core:OnEvent(self, event, ...)
    if (self == "ADDON_LOADED") then
        if (event ~= "TichTichPay") then
            return
        end
        Core.Init(self, event, ...);
    elseif (self == "PLAYER_LOGIN") then
        Config:Toggle();
        Core:Print("Initialized");
    elseif (self == "PLAYER_LEAVING_WORLD") then
        if (Core.TichTichPayDB:GetState() == State.Enum.PAYING) then
            Core.TichTichPayDB:SetState(State.Enum.WITHDRAW);
        end
    end
end

--------------------------------------
-- Functions
--------------------------------------

function Core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "TichTichPay:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

function Core:Error(...)
    local hex = select(4, self.Config:GetErrorColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "TichTichPay:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

-- WARNING: self automatically becomes events frame!
function Core:Init(self, name)
    -- allows using left and right buttons to move through chat 'edit' box
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
    end

    ----------------------------------
    -- Register Slash Commands!
    ----------------------------------

    SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
    SlashCmdList.RELOADUI = ReloadUI;

    SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
    SlashCmdList.FRAMESTK = function()
        LoadAddOn("Blizzard_DebugTools");
        FrameStackTooltip_Toggle();
    end

    SLASH_TichTichPay1 = "/ttp";
    SLASH_TichTichPay2 = "/tichtichpay";
    SlashCmdList.TichTichPay = HandleSlashCommands;
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("PLAYER_LOGIN");
events:RegisterEvent("PLAYER_LEAVING_WORLD");
events:SetScript("OnEvent", Core.OnEvent);