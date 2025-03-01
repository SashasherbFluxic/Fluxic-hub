local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Конфигурация автообновления
local FluxicConfig = {
    current_version = "1.0.0",
    version_url = "https://gist.githubusercontent.com/SashasherbFluxic/ca21bc9bcf22de3b8c16367acea9cf30/raw/d358eb7e8889c44332edc4694e5a27fe8133ce3a/version.lua"
}

local function CheckUpdate()
    local success, remote = pcall(function()
        return loadstring(game:HttpGet(FluxicConfig.version_url))()
    end)
    
    if not success then
        Rayfield:Notify({Title = "Ошибка", Content = "Не удалось проверить обновления", Duration = 5})
        return false
    end

    if remote.version ~= FluxicConfig.current_version then
        Rayfield:Notify({
            Title = "Обновление до v"..remote.version,
            Content = "Идет загрузка...",
            Duration = 6.5
        })
        
        local newCode = game:HttpGet(remote.update_url)
        
        -- Проверка хеша (реализуйте SHA-256 функцию)
        if sha256(newCode) ~= remote.hash then
            error("Хеш не совпадает! Возможна подмена скрипта!")
        end
        
        loadstring(newCode)()
        return true
    end
    return false
end

-- Запуск системы обновлений
if not CheckUpdate() then
    -- Ваш оригинальный код из Fluxic Hub
    local Window = Rayfield:CreateWindow({
        Name = "Fluxic Hub v"..FluxicConfig.current_version,
        LoadingTitle = "Загрузка...",
        LoadingSubtitle = "by Sashasherb",
        ConfigurationSaving = {Enabled = true}
    })
    
    -- ... остальной ваш интерфейс ...
end

-- Фоновая проверка каждые 30 минут
while true do
    task.wait(1800)
    pcall(CheckUpdate)
end
