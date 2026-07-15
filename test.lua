local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bracket-dev/bracket-lib/main/library.lua"))()

local Window = Library:CreateWindow({
    Name = "My Hub",
    Size = UDim2.fromOffset(500, 400),
    Theme = "Dark"
})

local MainTab = Window:CreateTab("Главная")
local FarmSec = MainTab:CreateSection("Авто Фарм")
local EggSec = MainTab:CreateSection("Авто Яйца")
local ClickSec = MainTab:CreateSection("Авто Кликер")

local FarmActive = false
local EggActive = false
local ClickActive = false

local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local SelectedEgg = "Egg 1"

-- 1. АВТО-ФАРМ
local function runFarm()
    task.spawn(function()
        while FarmActive do
            task.wait(0.5)
            pcall(function()
                local area = LP:GetAttribute("Area") or "Zone 1"
                local coins = workspace:FindFirstChild("__THINGS") and workspace.__THINGS:FindFirstChild("Coins")
                if coins then
                    for _, coin in ipairs(coins:GetChildren()) do
                        if not FarmActive then break end
                        if coin:FindFirstChild("Area") and coin.Area.Value == area then
                            game:GetService("ReplicatedStorage").Network.Pets_SetTarget:FireServer(coin.Name)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end)
end

FarmSec:CreateToggle({
    Name = "Включить Авто-Фарм",
    Default = false,
    Callback = function(val)
        FarmActive = val
        if val then runFarm() end
    end
})

-- 2. АВТО-ОТКРЫТИЕ ЯИЦ
local function runEgg()
    task.spawn(function()
        while EggActive do
            task.wait(0.1)
            pcall(function()
                game:GetService("ReplicatedStorage").Network.Eggs_RequestPurchase:InvokeServer(SelectedEgg, 1)
            end)
        end
    end)
end

EggSec:CreateTextBox({
    Name = "Название Яйца",
    Default = "Egg 1",
    Placeholder = "ID яйца...",
    Callback = function(val)
        SelectedEgg = val
    end
})

EggSec:CreateToggle({
    Name = "Авто-открытие яиц",
    Default = false,
    Callback = function(val)
        EggActive = val
        if val then runEgg() end
    end
})

-- 3. АВТО-КЛИКЕР
local function runClick()
    task.spawn(function()
        while ClickActive do
            task.wait(0.01)
            pcall(function()
                local size = workspace.CurrentCamera.ViewportSize
                local x, y = size.X / 2, size.Y / 2
                VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                task.wait(0.005)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
            end)
        end
    end)
end

ClickSec:CreateToggle({
    Name = "Быстрый кликер",
    Default = false,
    Callback = function(val)
        ClickActive = val
        if val then runClick() end
    end
})

Library:Notify("My Hub", "Готово к запуску!", 3)
