----------------------
-- Namespaces
----------------------
local _, Core = ...;
Core.Mail = {};

local Config = Core.Config;
local Mail = Core.Mail;
local State = Config.State;

----------------------
-- Event Hanlers
----------------------

function Mail.OnClick(self, button, down)
    self:Disable();
    Core.TichTichPayDB:SetState(State.Enum.PAYING);
    Mail:SendNext();
end

function Mail.OnEvent(self, event, ...)
    if (event == "MAIL_SHOW") then
        if (not TichTichPayUI:IsShown()) then
            Config:Toggle();
        end
        if (Core.TichTichPayDB:GetState() == State.Enum.WITHDRAW) then
            Core.TichTichPayDB:SetState(State.Enum.MAIL);
            self:Enable();
        end
    elseif (event == "MAIL_CLOSED") then
        if (Core.TichTichPayDB:GetState() == State.Enum.MAIL) then
            Core.TichTichPayDB:SetState(State.Enum.WITHDRAW);
            self:Disable();
        elseif (Core.TichTichPayDB:GetState() == State.Enum.PAYING) then
            Core.TichTichPayDB:SetState(State.Enum.WITHDRAW);
        end
    elseif (event == "MAIL_SUCCESS") then
        if (Core.TichTichPayDB:GetState() == State.Enum.PAYING) then
            local payment = Core.TichTichPayDB:GetNextPayment();
            payment.payed = true;
            Core:Print(payment.name .. " payed " .. payment.gold .. " golds.");
            Mail:SendNext();
        end
        TTPScrollFrame_Update();
    elseif (event == "MAIL_FAILED") then
        itemID = ...;
        if (itemID ~= nil) then
            Core:Error("A mail failed to be sent: " .. toString(itemID));
        end
        Mail:SendNext();
    end
end

----------------------
-- Functions
----------------------

function Mail:SendNext()
    local payment = Core.TichTichPayDB:GetNextPayment();
    if (payment ~= nil) then
        Mail:SendMail(payment.name, "TichTichPay", "Dear " .. payment.name .. ",\n\nYou have done a good job over the past few weeks and deserve this salary. Please accept these " .. payment.gold .. " golds for this commitment.\nKeep working this way and see you soon.\n\nSincerely yours,\nTichTich Team", payment.gold * 10000);
    elseif (Core.TichTichPayDB:GetState() == State.Enum.PAYING) then
            Core.TichTichPayDB:SetState(State.Enum.DONE);
            Core:Print("All Payments have been completed.");
    end
end

function Mail:SendMail(target, subject, body, money)
    if (money > 0) then
        SetSendMailMoney(money)
        SetSendMailCOD(0)
    elseif (money < 0) then
        SetSendMailCOD(abs(money))
        SetSendMailMoney(0)
    else
        SetSendMailMoney(0)
        SetSendMailCOD(0)
    end
    SendMail(target, subject, body)
end

function Mail:Close()
    CloseMail()
end