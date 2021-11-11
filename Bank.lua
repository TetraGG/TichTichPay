----------------------
-- Namespaces
----------------------
local _, Core = ...;
Core.Bank = {};

local Config = Core.Config;
local Bank = Core.Bank;
local State = Config.State;

----------------------
-- Event Hanlers
----------------------

function Bank.OnClick(self, button, down)
    if (Bank:Bank()) then
        Core.TichTichPayDB:SetState(State.Enum.WITHDRAW);
    end
end

function Bank.OnEvent(self, event, ...)
    if (event == "GUILDBANKFRAME_OPENED") then
        if (not TichTichPayUI:IsShown()) then
            Config:Toggle();
        end

        if (Core.TichTichPayDB:GetState() == State.Enum.INITIAL) then
            Core.TichTichPayDB:SetState(State.Enum.BANK);
            self:Enable();
        end
    elseif (event == "GUILDBANKFRAME_CLOSED") then
        if (Core.TichTichPayDB:GetState() == State.Enum.BANK) then
            Core.TichTichPayDB:SetState(State.Enum.INITIAL);
            self:Disable();
        end
    end
end

----------------------
-- Functions
----------------------

function Bank:CanWithdraw()
    return CanWithdrawGuildBankMoney();
end

function Bank:Withdraw()
    local moneyAvailable = GetGuildBankMoney();
    local moneyWithdrawable = GetGuildBankWithdrawMoney();
    local need = Core.TichTichPayDB:GetGold() * 10000 + Core.TichTichPayDB:GetPeople() * GetSendMailPrice();
    if (moneyAvailable >= need and moneyWithdrawable >= need) then
        WithdrawGuildBankMoney(need);
        Core:Print("Guild bank withdraw done.");
        return true;
    else
        Core:Error("Guild bank has not enough golds available.");
        return false;
    end
end

function Bank:CloseGuildBank()
    CloseGuildBankFrame();
end

function Bank:Bank()
    local res = false;
    if (Bank:CanWithdraw()) then
        if (Core.TichTichPayDB:GetState() == Config.State.Enum.BANK) then
            res = Bank:Withdraw();
            Bank:CloseGuildBank();
        end
    else
        Core:Error("You have not permission to withdraw.")
    end
    return res;
end