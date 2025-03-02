local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Конфигурация автообновления
local FluxicConfig = {
    current_version = "3.1",
    version_url = "https://gist.githubusercontent.com/SashasherbFluxic/ca21bc9bcf22de3b8c16367acea9cf30/raw/d358eb7e8889c44332edc4694e5a27fe8133ce3a/version.lua"
}

local function CheckUpdate()
    local success, remote = pcall(function()
        return loadstring(game:HttpGet(FluxicConfig.version_url))()
    end)
    
    if not success then return end

    if remote.version ~= FluxicConfig.current_version then
        local newCode = game:HttpGet(remote.update_url)
        
        -- Проверка хеша
        if sha256(newCode) ~= remote.hash then
            error("Хеш не совпадает: "..sha256(newCode))
        end
        
        loadstring(newCode)()
        return true
    end
    return false
end

-- Запуск системы
if not CheckUpdate() then
    -- Ваш основной код
    local Window = Rayfield:CreateWindow({
        Name = "Fluxic Hub v1.0.0",
        LoadingTitle = "Инициализация...",
        LoadingSubtitle = "Хеш: d0a1f2...14d6",
        ConfigurationSaving = {Enabled = true}
    })
    
    -- ... остальной интерфейс ...
end

-- Фоновая проверка
while task.wait(600) do pcall(CheckUpdate) end
