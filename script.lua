-- ================================================================= --
--                             MY HUB                                --
--                     Pet Simulator 99 Script                       --
-- ================================================================= --

-- Загрузка библиотеки интерфейса напрямую
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bracket-dev/bracket-lib/main/library.lua"))()

-- Создание главного окна
local Window = Library:CreateWindow({
    Name = "My Hub | Pet Simulator 99",
    Size = UDim2.fromOffset(500, 400),
    Theme = "Dark",
    Link = "github.com/myhub"
})

-- Вкладки меню
local MainTab = Window:CreateTab("Главная")
local AutoFarmSection = MainTab:CreateSection("Авто Фарм")
local AutoEggSection = MainTab:CreateSection("Авто Яйца")
local AutoClickerSection = MainTab:CreateSection("Авто Кликер")

-- Переменные состояния
local AutoFarmEnabled = false
local AutoEggEnabled = false
local AutoClickerEnabled = false

-- Сервисы игры
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. ФУНКЦИОНАЛ: АВТО-ФАРМ
-- ==========================================
local function startAutoFarm()
    task.spawn(function()
        while AutoFarmEnabled do
            task.wait(0.5)
            pcall(function()
                local activeArea = LocalPlayer:GetAttribute("Area") or "Zone 1"
                local coinsFolder = workspace:FindFirstChild("__THINGS") and workspace.__THINGS:FindFirstChild("Coins")
                
                if coinsFolder then
                    for _, coin in ipairs(coinsFolder:GetChildren()) do
                        if AutoFarmEnabled == false then break end
                        
                        if coin:FindFirstChild("Area") and coin.Area.Value == activeArea then
                            local coinID = coin.Name
                            game:GetService("ReplicatedStorage").Network.Pets_SetTarget:FireServer(coinID)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end)
end

AutoFarmSection:CreateToggle({
    Name = "Включить Авто-Фарм в зоне",
    Default = false,
    Callback = function(state)
        AutoFarmEnabled = state
        if state then
            startAutoFarm()
            Library:Notify("My Hub", "Авто-фарм запущен!", 3)
        else
            Library:Notify("My Hub", "Авто-фарм выключен.", 3)
        end
    end
})

-- ==========================================
-- 2. ФУНКЦИОНАЛ: БЫСТРОЕ ОТКРЫТИЕ ЯИЦ
-- ==========================================
local SelectedEgg = "Egg 1" 

local function startAutoEgg()
    task.spawn(function()
        while AutoEggEnabled do
            task.wait(0.1)
            pcall(function()
                local args = {
                    [1] = SelectedEgg,
                    [2] = 1
                }
                game:GetService("ReplicatedStorage").Network.Eggs_RequestPurchase:InvokeServer(unpack(args))
            end)
        end
    end)
end

AutoEggSection:CreateTextBox({
    Name = "Название/ID Яйца",
    Default = "Egg 1",
    Placeholder = "Введите ID яйца...",
    Callback = function(value)
        SelectedEgg = value
    end
})

AutoEggSection:CreateToggle({
    Name = "Быстрое авто-открытие",
    Default = false,
    Callback = function(state)
        AutoEggEnabled = state
        if state then
            startAutoEgg()
            Library:Notify("My Hub", "Авто-яйца активированы!", 3)
        else
            Library:Notify("My Hub", "Авто-яйца деактивированы.", 3)
        end
    end
})

-- ==========================================
-- 3. ФУНКЦИОНАЛ: АВТО-КЛИКЕР (По объектам на экране)
-- ==========================================
local function startAutoClicker()
    task.spawn(function()
        while AutoClickerEnabled do
            task.wait(0.01)
            pcall(function()
                local viewportSize = workspace.CurrentCamera.ViewportSize
                local x = viewportSize.X / 2
                local y = viewportSize.Y / 2
                
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
                task.wait(0.005)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
            end)
        end
    end)
end

AutoClickerSection:CreateToggle({
    Name = "Быстрый Авто-Кликер",
    Default = false,
    Callback = function(state)
        AutoClickerEnabled = state
        if state then
            startAutoClicker()
            Library:Notify("My Hub", "Авто-кликер включен!", 3)
        else
            Library:Notify("My Hub", "Авто-кликер выключен.", 3)
        end
    end
})

-- Уведомление о загрузке
Library:Notify("My Hub", "Скрипт успешно загружен! Наслаждайтесь игрой.", 5)
