--------------------------------------
-- Namespaces
--------------------------------------

local addonName, Core = ...;
local Config = Core.Config;
local State = Config.State;

TichTichPayDB = TichTichPayDB or {
        ["Alliance"] = {
            ["eu-khazmodan"] = {
                Config = {
                    State = Config.State.Enum.INITIAL,
                    Number = 28,
                    TotalGolds = 13336
                },
                List = {
                    {
                        ["payed"] = false,
                        ["name"] = "a",
                        ["gold"] = 5,
                    }, -- [1]
                    {
                        ["payed"] = false,
                        ["name"] = "Oyyr",
                        ["gold"] = 344,
                    }, -- [2]
                    {
                        ["payed"] = false,
                        ["name"] = "dsq",
                        ["gold"] = 75,
                    }, -- [3]
                    {
                        ["payed"] = false,
                        ["name"] = "Tatva",
                        ["gold"] = 24,
                    }, -- [4]
                    {
                        ["payed"] = false,
                        ["name"] = "Ouytr",
                        ["gold"] = 24,
                    }, -- [5]
                    {
                        ["payed"] = false,
                        ["name"] = "Tmyata",
                        ["gold"] = 68,
                    }, -- [6]
                    {
                        ["payed"] = false,
                        ["name"] = "Or",
                        ["gold"] = 7,
                    }, -- [7]
                    {
                        ["payed"] = false,
                        ["name"] = "qs",
                        ["gold"] = 34,
                    }, -- [8]
                    {
                        ["payed"] = false,
                        ["name"] = "Oriu",
                        ["gold"] = 45,
                    }, -- [9]
                    {
                        ["payed"] = false,
                        ["name"] = "Toto",
                        ["gold"] = 2,
                    }, -- [10]
                    {
                        ["payed"] = false,
                        ["name"] = "Tatyta",
                        ["gold"] = 7868,
                    }, -- [11]
                    {
                        ["payed"] = false,
                        ["name"] = "Totyto",
                        ["gold"] = 54,
                    }, -- [12]
                    {
                        ["payed"] = false,
                        ["name"] = "Totuo",
                        ["gold"] = 541,
                    }, -- [13]
                    {
                        ["payed"] = false,
                        ["name"] = "Tatia",
                        ["gold"] = 32,
                    }, -- [14]
                    {
                        ["payed"] = false,
                        ["name"] = "Orvc",
                        ["gold"] = 36,
                    }, -- [15]
                    {
                        ["payed"] = false,
                        ["name"] = "gf",
                        ["gold"] = 485,
                    }, -- [16]
                    {
                        ["payed"] = false,
                        ["name"] = "Totyo",
                        ["gold"] = 78,
                    }, -- [17]
                    {
                        ["payed"] = false,
                        ["name"] = "Tata",
                        ["gold"] = 41,
                    }, -- [18]
                    {
                        ["payed"] = false,
                        ["name"] = "Toytto",
                        ["gold"] = 35,
                    }, -- [19]
                    {
                        ["payed"] = false,
                        ["name"] = "Orl",
                        ["gold"] = 654,
                    }, -- [20]
                    {
                        ["payed"] = false,
                        ["name"] = "Taytta",
                        ["gold"] = 879,
                    }, -- [21]
                    {
                        ["payed"] = false,
                        ["name"] = "Toqsto",
                        ["gold"] = 24,
                    }, -- [22]
                    {
                        ["payed"] = false,
                        ["name"] = "aez",
                        ["gold"] = 10,
                    }, -- [23]
                    {
                        ["payed"] = false,
                        ["name"] = "Naopni",
                        ["gold"] = 78,
                    }, -- [24]
                    {
                        ["payed"] = false,
                        ["name"] = "Totcwo",
                        ["gold"] = 654,
                    }, -- [25]
                    {
                        ["payed"] = false,
                        ["name"] = "Orqsd",
                        ["gold"] = 987,
                    }, -- [26]
                    {
                        ["payed"] = false,
                        ["name"] = "Tadjta",
                        ["gold"] = 245,
                    }, -- [27]
                }
            },
            ["eu-hyjal"] = {
                Config = {
                    State = Config.State.Enum.INITIAL,
                    Number = 11,
                    TotalGolds = 42
                },
                List = {
                    {
                        ["payed"] = false,
                        ["name"] = "Thalnys",
                        ["gold"] = 1,
                    }, -- [1]
                    {
                        ["payed"] = false,
                        ["name"] = "Sylfus",
                        ["gold"] = 2,
                    }, -- [2]
                    {
                        ["payed"] = false,
                        ["name"] = "Xyrhos",
                        ["gold"] = 3,
                    }, -- [3]
                    {
                        ["payed"] = false,
                        ["name"] = "Yukkî",
                        ["gold"] = 2,
                    }, -- [4]
                    {
                        ["payed"] = false,
                        ["name"] = "Fulkas",
                        ["gold"] = 4,
                    }, -- [5]
                    {
                        ["payed"] = false,
                        ["name"] = "Kronir",
                        ["gold"] = 5,
                    }, -- [6]
                    {
                        ["payed"] = false,
                        ["name"] = "Yukkî",
                        ["gold"] = 1,
                    }, -- [7]
                    {
                        ["payed"] = false,
                        ["name"] = "Mytal",
                        ["gold"] = 6,
                    }, -- [8]
                    {
                        ["payed"] = false,
                        ["name"] = "Yonu",
                        ["gold"] = 7,
                    }, -- [9]
                    {
                        ["payed"] = false,
                        ["name"] = "Hylaen",
                        ["gold"] = 8,
                    }, -- [10]
                    {
                        ["payed"] = false,
                        ["name"] = "Yukkî",
                        ["gold"] = 3,
                    }, -- [11]
                }
            }
        }
    };

function TichTichPayDB:GetList()
    return TichTichPayDB[State.CurrentFaction][State.CurrentServer].List;
end

function TichTichPayDB:GetState()
    return TichTichPayDB[State.CurrentFaction][State.CurrentServer].Config.State;
end

function TichTichPayDB:SetState(state)
    TichTichPayDB[State.CurrentFaction][State.CurrentServer].Config.State = state;
    Config:UpdateMessage();
end

function TichTichPayDB:GetPeople()
    return TichTichPayDB[State.CurrentFaction][State.CurrentServer].Config.Number;
end

function TichTichPayDB:GetGold()
    return TichTichPayDB[State.CurrentFaction][State.CurrentServer].Config.TotalGolds;
end

function TichTichPayDB:GetNextPayment()
    local res;
    local list = Core.TichTichPayDB:GetList();
    for i = 1, #list do
        if (not list[i].payed) then
            return list[i];
        end
    end
    return res;
end

Core.TichTichPayDB = TichTichPayDB;