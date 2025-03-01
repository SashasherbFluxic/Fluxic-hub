local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UserInputService = game:GetService("UserInputService")

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- НАСТРОЙКИ ИНТЕРФЕЙСА
local Window = Rayfield:CreateWindow({
    Name = "Fluxic Hub",
    LoadingTitle = "Loading hub...",
    LoadingSubtitle = "By Fluxic",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FluxicConfigs",
        FileName = "MainSettings"
    }
})

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- ОСНОВНЫЕ ПЕРЕМЕННЫЕ
local Humanoid, RootPart
local DefaultWalk = 16
local FlySpeed = 50
local FlightActive = false
local BodyGyro, BodyVelocity

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- ИНИЦИАЛИЗАЦИЯ ПЕРСОНАЖА
local function SafeCharacterInit()
    local chr = game.Players.LocalPlayer.Character
    if not chr then return end
    
    Humanoid = chr:FindFirstChildOfClass("Humanoid")
    RootPart = chr:FindFirstChild("HumanoidRootPart") or chr:FindFirstChild("UpperTorso")
    
    if Humanoid and RootPart then
        DefaultWalk = Humanoid.WalkSpeed
    else
        Rayfield:Notify({
            Title = "Ошибка инициализации",
            Content = "Не найден Humanoid или RootPart",
            Duration = 5
        })
    end
end

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- СИСТЕМА ХОДЬБЫ
local MovementTab = Window:CreateTab("WalkSpeed", 4483362458)
MovementTab:CreateSection("Управление скоростью")

local WalkSlider = MovementTab:CreateSlider({
    Name = "Скорость ходьбы",
    Range = {1, 250},
    Increment = 1,
    Suffix = "юнитов/сек",
    CurrentValue = DefaultWalk,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

MovementTab:CreateButton({
    Name = "Обычная скорость",
    Callback = function()
        if Humanoid then
            WalkSlider:Set(DefaultWalk)
        end
    end
})

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- СИСТЕМА ПОЛЁТА
local FlyTab = Window:CreateTab("Fly Settings", 4483362458)
FlyTab:CreateSection("Управление полётом")

local function ToggleFlight(State)
    if not Humanoid or not RootPart then return end

    if State then
        -- Создаём физические компоненты
        BodyGyro = Instance.new("BodyGyro")
        BodyVelocity = Instance.new("BodyVelocity")
        
        -- Настройка BodyGyro
        BodyGyro.P = 9000
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.CFrame = RootPart.CFrame
        BodyGyro.Parent = RootPart
        
        -- Настройка BodyVelocity
        BodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = RootPart
        
        -- Блокировка стандартных состояний
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    else
        -- Удаление компонентов
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        
        -- Восстановление состояний
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    FlightActive = State
end

-- Ползунок скорости полёта
FlyTab:CreateSlider({
    Name = "Скорость полёта",
    Range = {1, 100},
    Increment = 1,
    Suffix = "юнитов/сек",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end
})

-- Кнопки управления
FlyTab:CreateButton({
    Name = "Включить полёт",
    Callback = function()
        ToggleFlight(true)
    end
})

FlyTab:CreateButton({
    Name = "Выключить полёт",
    Callback = function()
        ToggleFlight(false)
    end
})

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- СИСТЕМА УПРАВЛЕНИЯ
game:GetService("RunService").Heartbeat:Connect(function()
    if FlightActive and BodyGyro and BodyVelocity then
        local Camera = workspace.CurrentCamera
        local MoveVector = Vector3.new(
            UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
            UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0,
            UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
        )
        
        BodyGyro.CFrame = Camera.CFrame
        BodyVelocity.Velocity = Camera.CFrame:VectorToWorldSpace(MoveVector) * FlySpeed
    end
end)

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- АВТОМАТИЧЕСКАЯ ИНИЦИАЛИЗАЦИЯ
game.Players.LocalPlayer.CharacterAdded:Connect(SafeCharacterInit)
SafeCharacterInit()
