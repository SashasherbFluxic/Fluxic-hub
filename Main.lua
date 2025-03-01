local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UserInputService = game:GetService("UserInputService")

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- ВЕРСИЯ И ОБНОВЛЕНИЯ (НЕ ТРОГАТЬ)
local FluxicVersion = "1.0.0" -- Должно совпадать с version.lua

local function CheckUpdate()
    local versionData = loadstring(game:HttpGet("https://gist.githubusercontent.com/SashasherbFluxic/.../raw/version.lua"))()
    
    if versionData.version ~= FluxicVersion then
        Rayfield:Notify({
            Title = "Доступно обновление "..versionData.version,
            Content = "Загружаю изменения...",
            Duration = 5
        })
        
        local newCode = game:HttpGet(versionData.update_url)
        if sha256(newCode) ~= versionData.hash then
            error("Ошибка проверки целостности!")
        end
        
        loadstring(newCode)()
        return true
    end
    return false
end

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- ОСНОВНОЙ КОД (ВАШ СКРИПТ)
local Window = Rayfield:CreateWindow({
    Name = "Fluxic Hub v"..FluxicVersion,
    -- ... остальные настройки
})

-- ... ваш функционал ...

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
-- АВТООБНОВЛЕНИЕ
if not CheckUpdate() then
    -- Если обновления нет - запускаем обычный код
    -- ... ваш стартовый код ...
end

-- Проверка каждые 30 минут
while true do
    task.wait(1800)
    CheckUpdate()
end
