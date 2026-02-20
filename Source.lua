--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Main Window
local Window = Library:Window({
    Title = "Kew Hub",
    Desc = "Desenvolvido por 51872",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.K,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "N"
    }
})

-- Global variables
local ForceWhitelist = {}
local SavedCheckpoint = nil

-- Sidebar Vertical Separator
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui")

-- Visuals Tab
local Visuals = Window:Tab({Title = "Visuais", Icon = "eye"}) do
    Visuals:Section({Title = "Visuais"})

    local headlessConnection = nil

    Visuals:Toggle({
        Title = "Sem Cabeça",
        Desc = "Ativar para esconder a cabeça do personagem (apenas visual)",
        Value = false,
        Callback = function(state)
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            if not player then return end

            local function applyHeadless(character)
                if not character then return end
                local head = character:FindFirstChild("Head")
                if not head then return end
                if not head:FindFirstChild("__headless_meta") then
                    local meta = Instance.new("Folder")
                    meta.Name = "__headless_meta"
                    meta.Parent = head
                    local t = Instance.new("NumberValue")
                    t.Name = "OriginalTransparency"
                    t.Value = head.Transparency
                    t.Parent = meta
                    local decals = Instance.new("Folder")
                    decals.Name = "OriginalDecals"
                    decals.Parent = meta
                    for _, child in ipairs(head:GetDescendants()) do
                        if child:IsA("Decal") or child:IsA("Texture") then
                            local dv = Instance.new("NumberValue")
                            dv.Name = child.Name
                            dv.Value = child.Transparency
                            dv.Parent = decals
                        end
                    end
                end
                head.Transparency = 1
                head.CanCollide = false
                for _, child in ipairs(head:GetDescendants()) do
                    if child:IsA("BasePart") and child ~= head then
                        child.Transparency = 1
                    elseif child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = 1
                    end
                end
            end

            local function removeHeadless(character)
                if not character then return end
                local head = character:FindFirstChild("Head")
                if not head then return end
                local meta = head:FindFirstChild("__headless_meta")
                if meta then
                    local original = meta:FindFirstChild("OriginalTransparency")
                    if original then
                        head.Transparency = original.Value
                    else
                        head.Transparency = 0
                    end
                    local decalsMeta = meta:FindFirstChild("OriginalDecals")
                    if decalsMeta then
                        for _, dv in ipairs(decalsMeta:GetChildren()) do
                            local child = head:FindFirstChild(dv.Name, true)
                            if child and (child:IsA("Decal") or child:IsA("Texture")) then
                                child.Transparency = dv.Value
                            end
                        end
                    end
                    head.CanCollide = true
                    for _, child in ipairs(head:GetDescendants()) do
                        if child:IsA("BasePart") and child ~= head then
                            child.Transparency = 0
                        end
                    end
                    meta:Destroy()
                else
                    head.Transparency = 0
                    for _, child in ipairs(head:GetDescendants()) do
                        if child:IsA("BasePart") and child ~= head then
                            child.Transparency = 0
                        elseif child:IsA("Decal") or child:IsA("Texture") then
                            child.Transparency = 0
                        end
                    end
                    head.CanCollide = true
                end
            end

            if headlessConnection and headlessConnection.Disconnect then
                headlessConnection:Disconnect()
                headlessConnection = nil
            end

            if state then
                if player.Character then applyHeadless(player.Character) end
                headlessConnection = player.CharacterAdded:Connect(function(char) applyHeadless(char) end)
            else
                if player.Character then removeHeadless(player.Character) end
            end
        end
    })

    -- Korblox Right Leg
    local KORBLOX_ASSET = 139607718
    local korbloxModel = nil
    local korbloxConnection = nil

    local function applyKorblox(character)
        if not character then return end
        local targetPart = character:WaitForChild("RightUpperLeg", 5) or character:WaitForChild("Right Leg", 5)
        if not targetPart then return end
        if korbloxModel and korbloxModel.Parent then korbloxModel:Destroy() end

        local legParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
        for _, partName in ipairs(legParts) do
            local part = character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.Transparency = 1
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
                        child.Transparency = 1
                    end
                end
            end
        end

        local obj = nil
        local success, res = pcall(function()
            return game:GetObjects("rbxassetid://"..KORBLOX_ASSET)
        end)
        if success and res and #res > 0 then
            obj = res[1]
        end
        if not obj then return end

        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
                part.CanCollide = false
                part.Massless = true
                part.CFrame = targetPart.CFrame
                local weld = Instance.new("Weld")
                weld.Part0 = targetPart
                weld.Part1 = part
                weld.C0 = CFrame.new()
                weld.C1 = part.CFrame:ToObjectSpace(targetPart.CFrame)
                weld.Parent = part
            end
        end
        obj.Parent = character
        korbloxModel = obj
    end

    local function removeKorblox(character)
        if korbloxModel and korbloxModel.Parent then
            korbloxModel:Destroy()
            korbloxModel = nil
        end
        if korbloxConnection then
            korbloxConnection:Disconnect()
            korbloxConnection = nil
        end
        if character then
            local legParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
            for _, partName in ipairs(legParts) do
                local part = character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.Transparency = 0
                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
                            child.Transparency = 0
                        end
                    end
                end
            end
        end
    end

    Visuals:Toggle({
        Title = "Perna Direita Korblox",
        Desc = "Anexar perna direita do Korblox Deathspeaker ao seu personagem",
        Value = false,
        Callback = function(state)
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            if not player then return end

            if state then
                if player.Character then applyKorblox(player.Character) end
                korbloxConnection = player.CharacterAdded:Connect(function(char) applyKorblox(char) end)
            else
                removeKorblox(player.Character)
            end
        end
    })

    -- Badge (cargo) system
    -- Mapeamento de usuário -> cargo (constante)
    local TESTER_BADGES = {
        ["din1z7x"] = "Desenvolvedor",
        -- Adicione mais usuários aqui, ex: ["username"] = "Testers"
    }

    local badgeConnection = nil
    local badgeEnabled = false

    local function applyBadge(character)
        if not character then return end
        local Players = game:GetService("Players")
        local plr = Players.LocalPlayer
        if not plr then return end
        local role = TESTER_BADGES[plr.Name] or "Tester"

        -- Remove badge antigo se existir
        local head = character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso")
        if not head then return end
        local existing = head:FindFirstChild("__Kew_badge")
        if existing then existing:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "__Kew_badge"
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 220, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.3, 0)
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        -- fundo transparente: apenas texto
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 32
        label.Text = role
        label.TextScaled = true
        label.Parent = billboard

        -- traçado azul visível (UIStroke)
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 2
        stroke.Parent = label

        -- Rainbow effect for all roles
        task.spawn(function()
            while label and label.Parent do
                for hue = 0, 1, 0.01 do
                    if not label or not label.Parent then break end
                    label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    task.wait(0.05)
                end
            end
        end)
    end

    local function removeBadge(character)
        if not character then return end
        local head = character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso")
        if not head then return end
        local badge = head:FindFirstChild("__Kew_badge")
        if badge then badge:Destroy() end
    end

    Visuals:Toggle({
        Title = "Emblema (Cargo)",
        Desc = "Mostrar ou esconder o cargo acima do seu personagem",
        Value = false,
        Callback = function(state)
            badgeEnabled = state
            local Players = game:GetService("Players")
            local plr = Players.LocalPlayer
            if not plr then return end

            if state then
                if plr.Character then applyBadge(plr.Character) end
                -- reaplicar no spawn
                badgeConnection = plr.CharacterAdded:Connect(function(char)
                    if badgeEnabled then
                        -- pequeno delay para garantir que Head exista
                        wait(0.1)
                        applyBadge(char)
                    end
                end)
            else
                removeBadge(plr.Character)
                if badgeConnection then
                    badgeConnection:Disconnect()
                    badgeConnection = nil
                end
            end
        end
    })

    -- Shaders
    Visuals:Dropdown({
        Title = "Shaders",
        Desc = "Selecionar preset de shaders",
        List = {"Nenhum", "Shaders v1", "Shaders v2", "Shaders v3"},
        Value = "Nenhum",
        Callback = function(value)
            if value == "Shaders v1" then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Shaders.xml"))()
                Window:Notify({Title = "Visuais", Desc = "Shaders v1 ativados!", Time = 2})
            elseif value == "Shaders v2" then
                -- Credits to Instance Serializer for helping me convert the Tokyowami shrine whatever thing to luau
                if not game:IsLoaded() then
                    game.Loaded:Wait()
                end
                local Bloom = Instance.new("BloomEffect")
                Bloom.Intensity = 0.1
                Bloom.Threshold = 0
                Bloom.Size = 100

                local Tropic = Instance.new("Sky")
                Tropic.Name = "Tropic"
                Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
                Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
                Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
                Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
                Tropic.StarCount = 100
                Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
                Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
                Tropic.Parent = Bloom

                local Sky = Instance.new("Sky")
                Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
                Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
                Sky.CelestialBodiesShown = false
                Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
                Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
                Sky.Parent = Bloom

                Bloom.Parent = game:GetService("Lighting")

                local Bloom = Instance.new("BloomEffect")
                Bloom.Enabled = false
                Bloom.Intensity = 0.35
                Bloom.Threshold = 0.2
                Bloom.Size = 56

                local Tropic = Instance.new("Sky")
                Tropic.Name = "Tropic"
                Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
                Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
                Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
                Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
                Tropic.StarCount = 100
                Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
                Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
                Tropic.Parent = Bloom

                local Sky = Instance.new("Sky")
                Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
                Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
                Sky.CelestialBodiesShown = false
                Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
                Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
                Sky.Parent = Bloom

                Bloom.Parent = game:GetService("Lighting")
                local Blur = Instance.new("BlurEffect")
                Blur.Size = 2

                Blur.Parent = game:GetService("Lighting")
                local Efecto = Instance.new("BlurEffect")
                Efecto.Name = "Efecto"
                Efecto.Enabled = false
                Efecto.Size = 2

                Efecto.Parent = game:GetService("Lighting")
                local Inaritaisha = Instance.new("ColorCorrectionEffect")
                Inaritaisha.Name = "Inari taisha"
                Inaritaisha.Saturation = 0.05
                Inaritaisha.TintColor = Color3.fromRGB(255, 224, 219)

                Inaritaisha.Parent = game:GetService("Lighting")
                local Normal = Instance.new("ColorCorrectionEffect")
                Normal.Name = "Normal"
                Normal.Enabled = false
                Normal.Saturation = -0.2
                Normal.TintColor = Color3.fromRGB(255, 232, 215)

                Normal.Parent = game:GetService("Lighting")
                local SunRays = Instance.new("SunRaysEffect")
                SunRays.Intensity = 0.05

                SunRays.Parent = game:GetService("Lighting")
                local Sunset = Instance.new("Sky")
                Sunset.Name = "Sunset"
                Sunset.SkyboxUp = "rbxassetid://323493360"
                Sunset.SkyboxLf = "rbxassetid://323494252"
                Sunset.SkyboxBk = "rbxassetid://323494035"
                Sunset.SkyboxFt = "rbxassetid://323494130"
                Sunset.SkyboxDn = "rbxassetid://323494368"
                Sunset.SunAngularSize = 14
                Sunset.SkyboxRt = "rbxassetid://323494067"

                Sunset.Parent = game:GetService("Lighting")
                local Takayama = Instance.new("ColorCorrectionEffect")
                Takayama.Name = "Takayama"
                Takayama.Enabled = false
                Takayama.Saturation = -0.3
                Takayama.Contrast = 0.1
                Takayama.TintColor = Color3.fromRGB(235, 214, 204)

                Takayama.Parent = game:GetService("Lighting")
                local L = game:GetService("Lighting")
                L.Brightness = 2.14
                L.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
                L.ColorShift_Top = Color3.fromRGB(240, 127, 14)
                L.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
                L.ClockTime = 6.7
                L.FogColor = Color3.fromRGB(94, 76, 106)
                L.FogEnd = 1000
                L.FogStart = 0
                L.ExposureCompensation = 0.24
                L.ShadowSoftness = 0
                L.Ambient = Color3.fromRGB(59, 33, 27)

                local Bloom = Instance.new("BloomEffect")
                Bloom.Intensity = 0.1
                Bloom.Threshold = 0
                Bloom.Size = 100

                local Tropic = Instance.new("Sky")
                Tropic.Name = "Tropic"
                Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
                Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
                Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
                Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
                Tropic.StarCount = 100
                Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
                Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
                Tropic.Parent = Bloom

                local Sky = Instance.new("Sky")
                Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
                Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
                Sky.CelestialBodiesShown = false
                Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
                Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
                Sky.Parent = Bloom

                Bloom.Parent = game:GetService("Lighting")

                local Bloom = Instance.new("BloomEffect")
                Bloom.Enabled = false
                Bloom.Intensity = 0.35
                Bloom.Threshold = 0.2
                Bloom.Size = 56

                local Tropic = Instance.new("Sky")
                Tropic.Name = "Tropic"
                Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
                Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
                Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
                Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
                Tropic.StarCount = 100
                Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
                Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
                Tropic.Parent = Bloom

                local Sky = Instance.new("Sky")
                Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
                Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
                Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
                Sky.CelestialBodiesShown = false
                Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
                Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
                Sky.Parent = Bloom

                Bloom.Parent = game:GetService("Lighting")
                local Blur = Instance.new("BlurEffect")
                Blur.Size = 2

                Blur.Parent = game:GetService("Lighting")
                local Efecto = Instance.new("BlurEffect")
                Efecto.Name = "Efecto"
                Efecto.Enabled = false
                Efecto.Size = 2

                Efecto.Parent = game:GetService("Lighting")
                local Inaritaisha = Instance.new("ColorCorrectionEffect")
                Inaritaisha.Name = "Inari taisha"
                Inaritaisha.Saturation = 0.05
                Inaritaisha.TintColor = Color3.fromRGB(255, 224, 219)

                Inaritaisha.Parent = game:GetService("Lighting")
                local Normal = Instance.new("ColorCorrectionEffect")
                Normal.Name = "Normal"
                Normal.Enabled = false
                Normal.Saturation = -0.2
                Normal.TintColor = Color3.fromRGB(255, 232, 215)

                Normal.Parent = game:GetService("Lighting")
                local SunRays = Instance.new("SunRaysEffect")
                SunRays.Intensity = 0.05

                SunRays.Parent = game:GetService("Lighting")
                local Sunset = Instance.new("Sky")
                Sunset.Name = "Sunset"
                Sunset.SkyboxUp = "rbxassetid://323493360"
                Sunset.SkyboxLf = "rbxassetid://323494252"
                Sunset.SkyboxBk = "rbxassetid://323494035"
                Sunset.SkyboxFt = "rbxassetid://323494130"
                Sunset.SkyboxDn = "rbxassetid://323494368"
                Sunset.SunAngularSize = 14
                Sunset.SkyboxRt = "rbxassetid://323494067"

                Sunset.Parent = game:GetService("Lighting")
                local Takayama = Instance.new("ColorCorrectionEffect")
                Takayama.Name = "Takayama"
                Takayama.Enabled = false
                Takayama.Saturation = -0.3
                Takayama.Contrast = 0.1
                Takayama.TintColor = Color3.fromRGB(235, 214, 204)

                Takayama.Parent = game:GetService("Lighting")
                local L = game:GetService("Lighting")
                L.Brightness = 2.14
                L.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
                L.ColorShift_Top = Color3.fromRGB(240, 127, 14)
                L.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
                L.ClockTime = 6.7
                L.FogColor = Color3.fromRGB(94, 76, 106)
                L.FogEnd = 1000
                L.FogStart = 0
                L.ExposureCompensation = 0.24
                L.ShadowSoftness = 0
                L.Ambient = Color3.fromRGB(59, 33, 27)
                Window:Notify({Title = "Visuais", Desc = "Shaders v2 ativados!", Time = 2})
            elseif value == "Shaders v3" then
                -- Advanced Detailed Shaders v3
                if not game:IsLoaded() then
                    game.Loaded:Wait()
                end

                -- Multiple Bloom Effects for layered glow
                local Bloom1 = Instance.new("BloomEffect")
                Bloom1.Intensity = 0.15
                Bloom1.Threshold = 0.1
                Bloom1.Size = 120
                Bloom1.Parent = game:GetService("Lighting")

                local Bloom2 = Instance.new("BloomEffect")
                Bloom2.Intensity = 0.25
                Bloom2.Threshold = 0.3
                Bloom2.Size = 80
                Bloom2.Parent = game:GetService("Lighting")

                local Bloom3 = Instance.new("BloomEffect")
                Bloom3.Intensity = 0.05
                Bloom3.Threshold = 0.5
                Bloom3.Size = 50
                Bloom3.Parent = game:GetService("Lighting")

                -- Depth of Field for cinematic blur
                local DoF = Instance.new("DepthOfFieldEffect")
                DoF.FarIntensity = 0.3
                DoF.FocusDistance = 50
                DoF.InFocusRadius = 20
                DoF.NearIntensity = 0.1
                DoF.Parent = game:GetService("Lighting")

                -- Multiple Blur Effects
                local Blur1 = Instance.new("BlurEffect")
                Blur1.Size = 1.5
                Blur1.Parent = game:GetService("Lighting")

                local Blur2 = Instance.new("BlurEffect")
                Blur2.Name = "SecondaryBlur"
                Blur2.Enabled = false
                Blur2.Size = 3
                Blur2.Parent = game:GetService("Lighting")

                -- Enhanced Color Corrections
                local CC1 = Instance.new("ColorCorrectionEffect")
                CC1.Name = "PrimaryCC"
                CC1.Brightness = 0.1
                CC1.Contrast = 0.2
                CC1.Saturation = 0.1
                CC1.TintColor = Color3.fromRGB(250, 230, 210)
                CC1.Parent = game:GetService("Lighting")

                local CC2 = Instance.new("ColorCorrectionEffect")
                CC2.Name = "SecondaryCC"
                CC2.Brightness = -0.05
                CC2.Contrast = 0.15
                CC2.Saturation = -0.1
                CC2.TintColor = Color3.fromRGB(220, 200, 180)
                CC2.Parent = game:GetService("Lighting")

                local CC3 = Instance.new("ColorCorrectionEffect")
                CC3.Name = "TertiaryCC"
                CC3.Enabled = false
                CC3.Brightness = 0.05
                CC3.Contrast = -0.1
                CC3.Saturation = 0.2
                CC3.TintColor = Color3.fromRGB(255, 240, 220)
                CC3.Parent = game:GetService("Lighting")

                -- Sun Rays with varying intensities
                local SunRays1 = Instance.new("SunRaysEffect")
                SunRays1.Intensity = 0.08
                SunRays1.Spread = 0.5
                SunRays1.Parent = game:GetService("Lighting")

                local SunRays2 = Instance.new("SunRaysEffect")
                SunRays2.Name = "SecondarySunRays"
                SunRays2.Intensity = 0.03
                SunRays2.Spread = 0.8
                SunRays2.Parent = game:GetService("Lighting")

                -- Custom Skybox
                local CustomSky = Instance.new("Sky")
                CustomSky.Name = "CustomSkyV3"
                CustomSky.SkyboxUp = "rbxassetid://600830446"
                CustomSky.SkyboxLf = "rbxassetid://600831635"
                CustomSky.SkyboxBk = "rbxassetid://600832720"
                CustomSky.SkyboxFt = "rbxassetid://600830446"
                CustomSky.SkyboxDn = "rbxassetid://600835177"
                CustomSky.SkyboxRt = "rbxassetid://600833862"
                CustomSky.CelestialBodiesShown = true
                CustomSky.StarCount = 3000
                CustomSky.Parent = game:GetService("Lighting")

                -- Advanced Lighting Settings
                local L = game:GetService("Lighting")
                L.Brightness = 2.5
                L.ColorShift_Bottom = Color3.fromRGB(20, 10, 30)
                L.ColorShift_Top = Color3.fromRGB(255, 150, 50)
                L.OutdoorAmbient = Color3.fromRGB(50, 20, 60)
                L.ClockTime = 7.0
                L.FogColor = Color3.fromRGB(120, 90, 130)
                L.FogEnd = 1500
                L.FogStart = 100
                L.ExposureCompensation = 0.3
                L.ShadowSoftness = 0.2
                L.Ambient = Color3.fromRGB(70, 40, 50)
                L.GlobalShadows = true
                L.EnvironmentDiffuseScale = 0.8
                L.EnvironmentSpecularScale = 0.5

                Window:Notify({Title = "Visuais", Desc = "Shaders v3 ativados!", Time = 2})
            else
                local light = game.Lighting
                local ter = workspace.Terrain
                -- Destroy shader effects
                for _, effect in ipairs(light:GetChildren()) do
                    if effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect:Destroy()
                    end
                end
                -- Reset terrain to approximate defaults
                ter.WaterColor = Color3.new(0.5, 0.5, 1)
                ter.WaterWaveSize = 0.5
                ter.WaterWaveSpeed = 10
                ter.WaterTransparency = 0.3
                ter.WaterReflectance = 1
                -- Reset lighting to approximate defaults
                light.Ambient = Color3.new(0.5, 0.5, 0.5)
                light.Brightness = 1
                light.ColorShift_Bottom = Color3.new(0, 0, 0)
                light.ColorShift_Top = Color3.new(0, 0, 0)
                light.ExposureCompensation = 0
                light.FogColor = Color3.new(0.75, 0.75, 0.75)
                light.GlobalShadows = true
                light.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
                light.Outlines = false
                Window:Notify({Title = "Visuais", Desc = "Shaders desativados!", Time = 2})
            end
        end
    })
end

-- Animations Tab
local Animations = Window:Tab({Title = "Animações", Icon = "activity"})
Animations:Section({Title = "Pacotes de Animação"})

local function applyAnimPack(idle1, idle2, walk, run, jump, climb, fall)
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    if not plr or not plr.Character then return end
    
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local animate = plr.Character:FindFirstChild("Animate")
    if not animate then return end
    
    -- Stop current animations
    local animTracks = humanoid:GetPlayingAnimationTracks()
    for _, track in ipairs(animTracks) do
        track:Stop()
    end
    
    -- Disable animate script temporarily
    animate.Disabled = true
    
    -- Apply new animations
    if animate.idle and animate.idle.Animation1 then
        animate.idle.Animation1.AnimationId = "rbxassetid://"..idle1
    end
    if animate.idle and animate.idle.Animation2 then
        animate.idle.Animation2.AnimationId = "rbxassetid://"..idle2
    end
    if animate.walk and animate.walk.WalkAnim then
        animate.walk.WalkAnim.AnimationId = "rbxassetid://"..walk
    end
    if animate.run and animate.run.RunAnim then
        animate.run.RunAnim.AnimationId = "rbxassetid://"..run
    end
    if animate.jump and animate.jump.JumpAnim then
        animate.jump.JumpAnim.AnimationId = "rbxassetid://"..jump
    end
    if animate.climb and animate.climb.ClimbAnim then
        animate.climb.ClimbAnim.AnimationId = "rbxassetid://"..climb
    end
    if animate.fall and animate.fall.FallAnim then
        animate.fall.FallAnim.AnimationId = "rbxassetid://"..fall
    end
    
    -- Re-enable animate script
    animate.Disabled = false
    
    -- Force animation refresh by changing state
    humanoid:ChangeState(Enum.HumanoidStateType.Falling)
    wait(0.1)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

Animations:Button({
    Title = "Zumbi",
    Desc = "Aplicar pacote de animação Zumbi",
    Callback = function()
        applyAnimPack(616158929, 616160636, 616168032, 616163682, 616161997, 616156119, 616157476)
    end
})

Animations:Button({
    Title = "Cartoon",
    Desc = "Aplicar pacote de animação Cartoon",
    Callback = function()
        applyAnimPack(742637544, 742638445, 742640026, 742638842, 742637942, 742636889, 742637151)
    end
})

Animations:Button({
    Title = "Vampire",
    Desc = "Aplicar pacote de animação Vampire",
    Callback = function()
        applyAnimPack(1083445855, 1083450166, 1083473930, 1083462077, 1083455352, 1083439238, 1083443587)
    end
})

Animations:Button({
    Title = "Hero",
    Desc = "Aplicar pacote de animação Hero",
    Callback = function()
        applyAnimPack(616111295, 616113536, 616122287, 616117076, 616115533, 616104706, 616108001)
    end
})

Animations:Button({
    Title = "Mage",
    Desc = "Aplicar pacote de animação Mage",
    Callback = function()
        applyAnimPack(707742142, 707855907, 707897309, 707861613, 707853694, 707826056, 707829716)
    end
})

Animations:Button({
    Title = "Ghost",
    Desc = "Aplicar pacote de animação Ghost",
    Callback = function()
        applyAnimPack(616006778, 616008087, 616010382, 616013216, 616008936, 616003713, 616005863)
    end
})

Animations:Button({
    Title = "Elder",
    Desc = "Aplicar pacote de animação Elder",
    Callback = function()
        applyAnimPack(845397899, 845400520, 845403856, 845386501, 845398858, 845392038, 845396048)
    end
})

Animations:Button({
    Title = "Levitation",
    Desc = "Aplicar pacote de animação Levitation",
    Callback = function()
        applyAnimPack(616006778, 616008087, 616013216, 616010382, 616008936, 616003713, 616005863)
    end
})

Animations:Button({
    Title = "Astronaut",
    Desc = "Aplicar pacote de animação Astronaut",
    Callback = function()
        applyAnimPack(891621366, 891633237, 891667138, 891636393, 891627522, 891609353, 891617961)
    end
})

Animations:Button({
    Title = "Ninja",
    Desc = "Aplicar pacote de animação Ninja",
    Callback = function()
        applyAnimPack(656117400, 656118341, 656121766, 656118852, 656117878, 656114359, 656115606)
    end
})

Animations:Button({
    Title = "Werewolf",
    Desc = "Aplicar pacote de animação Werewolf",
    Callback = function()
        applyAnimPack(1083195517, 1083214717, 1083178339, 1083216690, 1083218792, 1083182000, 1083189019)
    end
})

Animations:Button({
    Title = "Resetar Animações",
    Desc = "Resetar para animações padrão",
    Callback = function()
        local Players = game:GetService("Players")
        local plr = Players.LocalPlayer
        if not plr or not plr.Character then return end
        
        local animate = plr.Character:FindFirstChild("Animate")
        if not animate then return end
        
        -- Disable and re-enable to reset
        animate.Disabled = true
        wait(0.1)
        animate.Disabled = false
        
        -- Force refresh
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Falling)
            wait(0.1)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
})

-- Teleports Tab
local Teleports = Window:Tab({Title = "Teleportes", Icon = "map"}) do
    Teleports:Section({Title = "Locais Rápidos"})

    -- Lista de opções: Osso 1..10 e Cabana
    local boneList = {}
    for i = 1, 10 do table.insert(boneList, "Osso "..i) end
    table.insert(boneList, "Cabana")

    local selectedBone = boneList[1]

    -- Constantes únicas para todos os locais (substitua pelos valores do seu jogo)
    local TELEPORT_CONSTS = {
        bones = {
            ["Cabana"] = {x = 287.00, y = 29.32, z = 314.00},
            ["Osso 1"] = {x = 439.00, y = 3.69, z = 779.00},
            ["Osso 2"] = {x = 517.00, y = 8.30, z = 424.00},
            ["Osso 3"] = {x = 489.00, y = 21.40, z = 291.00},
            ["Osso 4"] = {x = 353.00, y = 25.29, z = -223.00},
            ["Osso 5"] = {x = -262.00, y = 1.76, z = 8.00},
            ["Osso 6"] = {x = -352.00, y = 16.45, z = -294.00},
            ["Osso 7"] = {x = -726.00, y = 8.84, z = -259.00},
            ["Osso 8"] = {x = -562.88, y = -5.53, z = -23.05},
            ["Osso 9"] = {x = -788.00, y = 14.98, z = 217.00},
            ["Osso 10"] = {x = -582.00, y = 9.20, z = 566.00},
        },
        specials = {
            ponte = {x = 103.80, y = 3.07, z = 829.37},
            ceu = {x = 21.00, y = 341.03, z = 645.00},
            sacreficio = {x = 465.55, y = 14.45, z = 491.69},
            dragao = {x = -634.00, y = 11.03, z = -331.00},
            caverna = {x = 402.00, y = 0.73, z = -391.00},
        },
        baus = {}
    }

    -- preencher baús com constantes de exemplo (substituir conforme necessário)
    for i = 1, 13 do
        TELEPORT_CONSTS.baus["Bau "..i] = {x = i * 10, y = 5, z = i * 15}
    end

    -- Função utilitária de teleporte
    local function teleportTo(coords)
        if not coords then return end
        local Players = game:GetService("Players")
        local plr = Players.LocalPlayer
        if not plr or not plr.Character then return end
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
        if not hrp then return end
        pcall(function()
            hrp.CFrame = CFrame.new(coords.x, coords.y, coords.z)
        end)
    end

    -- Evita teleporte automático no momento da criação do dropdown (algumas UIs chamam o callback imediatamente)
    local suppressBoneTeleport = true

    -- Dropdown para selecionar o osso — teleporta imediatamente ao selecionar (exceto no primeiro callback)
    Teleports:Dropdown({
        Title = "Local de osso",
        Desc = "Selecione para teleportar",
        List = boneList,
        Value = selectedBone,
        Callback = function(value)
            -- Ignora o primeiro evento que acontece na criação
            if suppressBoneTeleport then
                suppressBoneTeleport = false
                selectedBone = value
                return
            end
            selectedBone = value
            local c = TELEPORT_CONSTS.bones[selectedBone] or {x = 0, y = 0, z = 0}
            teleportTo(c)
            Window:Notify({Title = "Teleportado", Desc = "Indo para "..selectedBone, Time = 2})
        end
    })

    -- Botões rápidos adicionais

    Teleports:Button({
        Title = "Ponte",
        Desc = "Teleporta para a ponte",
        Callback = function()
            teleportTo(TELEPORT_CONSTS.specials.ponte)
            Window:Notify({Title = "Teleportado", Desc = "Ponte", Time = 2})
        end
    })

    Teleports:Button({
        Title = "Dragão",
        Desc = "Teleporta para o dragão",
        Callback = function()
            teleportTo(TELEPORT_CONSTS.specials.dragao)
            Window:Notify({Title = "Teleportado", Desc = "Dragão", Time = 2})
        end
    })
    Teleports:Button({
        Title = "Caverna",
        Desc = "Teleporta para a caverna",
        Callback = function()
            teleportTo(TELEPORT_CONSTS.specials.caverna)
            Window:Notify({Title = "Teleportado", Desc = "Caverna", Time = 2})
        end
    })

    Teleports:Button({
        Title = "Céu",
        Desc = "Teleporta para o céu",
        Callback = function()
            teleportTo(TELEPORT_CONSTS.specials.ceu)
            Window:Notify({Title = "Teleportado", Desc = "Céu", Time = 2})
        end
    })

    Teleports:Button({
        Title = "Sacrifício",
        Desc = "Teleporta para o local de sacrifício",
        Callback = function()
            teleportTo(TELEPORT_CONSTS.specials.sacreficio)
            Window:Notify({Title = "Teleportado", Desc = "Sacrifício", Time = 2})
        end
    })

    -- Dropdown de Baús (13 opções) com constantes
    local bauList = {}
    for i = 1, 10 do table.insert(bauList, "Bau "..i) end

    -- Exemplo: define coordenadas de exemplo para Bau 1 (substitua pelas reais se quiser)
    TELEPORT_CONSTS.baus["Bau 1"] = {x = -238.00, y = 9.38, z = 938.00} 
    TELEPORT_CONSTS.baus["Bau 2"] = {x = -229.94, y = -2.41, z = 769.05}
    TELEPORT_CONSTS.baus["Bau 3"] = {x = -495.00, y = 0.98, z = 739.00}
    TELEPORT_CONSTS.baus["Bau 4"] = {x = -789.00, y = 21.31, z = 14.00}    
    TELEPORT_CONSTS.baus["Bau 5"] = {x = -692.00, y = 12.71, z = -301.00}
    TELEPORT_CONSTS.baus["Bau 6"] = {x = 7.00, y = 2.98, z = -197.00}
    TELEPORT_CONSTS.baus["Bau 7"] ={x = -726.00, y = 8.84, z = -259.00}
    TELEPORT_CONSTS.baus["Bau 8"] = {x = 130.00, y = 3.03, z = -210.00}
    TELEPORT_CONSTS.baus["Bau 9"] = {x = 379.00, y = 2.96, z = -203.00}
    TELEPORT_CONSTS.baus["Bau 10"] = {x = -13.00, y = 2.73, z = 846.00}
    -- Adicione mais coordenadas conforme necessário

    local selectedBau = bauList[1]

    local suppressBauTeleport = true

    Teleports:Dropdown({
        Title = "Baús",
        Desc = "Selecione um baú para teleportar",
        List = bauList,
        Value = selectedBau,
        Callback = function(value)
            -- Ignora o primeiro callback automático
            if suppressBauTeleport then
                suppressBauTeleport = false
                selectedBau = value
                return
            end
            selectedBau = value
            local c = TELEPORT_CONSTS.baus[selectedBau] or {x = 0, y = 0, z = 0}
            teleportTo(c)
            Window:Notify({Title = "Teleportado", Desc = "Indo para "..selectedBau, Time = 2})
        end
    })

    Teleports:Button({
        Title = "Salvar Checkpoint",
        Desc = "Salva a posição atual para respawn",
        Callback = function()
            if plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
                if hrp then
                    SavedCheckpoint = hrp.Position
                    Window:Notify({Title = "Teleportado", Desc = "Checkpoint salvo!", Time = 2})
                end
            end
        end
    })

    Teleports:Button({
        Title = "Limpar Checkpoint",
        Desc = "Remove o checkpoint salvo",
        Callback = function()
            SavedCheckpoint = nil
            Window:Notify({Title = "Teleportado", Desc = "Checkpoint limpo!", Time = 2})
        end
    })
end

-- Target functions
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local function GetPing()
    return (game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())/1000
end

local function GetRoot(Player)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        return Player.Character.HumanoidRootPart
    end
end

local function PredictionTP(player, method)
    local root = GetRoot(player)
    if not root then return end
    local pos = root.Position
    local vel = root.Velocity
    GetRoot(plr).CFrame = CFrame.new((pos.X)+(vel.X)*(GetPing()*3.5),(pos.Y)+(vel.Y)*(GetPing()*2),(pos.Z)+(vel.Z)*(GetPing()*3.5))
    if method == "safe" then
        task.wait()
        GetRoot(plr).CFrame = CFrame.new(pos)
        task.wait()
        GetRoot(plr).CFrame = CFrame.new((pos.X)+(vel.X)*(GetPing()*3.5),(pos.Y)+(vel.Y)*(GetPing()*2),(pos.Z)+(vel.Z)*(GetPing()*3.5))
    end
end

local flingEnabled = false
local function ToggleFling(bool)
    flingEnabled = bool
    task.spawn(function()
        if bool then
            local RVelocity = nil
            while flingEnabled do
                pcall(function()
                    RVelocity = GetRoot(plr).Velocity 
                    GetRoot(plr).Velocity = Vector3.new(math.random(-150,150),-25000,math.random(-150,150))
                    RunService.RenderStepped:wait()
                    GetRoot(plr).Velocity = RVelocity
                end)
                RunService.Heartbeat:wait()
            end
        end
    end)
end

local function GetPush()
    local TempPush = nil
    pcall(function()
        if plr.Backpack:FindFirstChild("Push") then
            local PushTool = plr.Backpack.Push
            PushTool.Parent = plr.Character
            TempPush = PushTool
        end
        for i,v in pairs(Players:GetPlayers()) do
            if v.Character:FindFirstChild("Push") then
                TempPush = v.Character.Push
            end
        end
    end)
    return TempPush
end

local function Push(Target)
    local Push = GetPush()
    local FixTool = nil
    if Push ~= nil then
        local args = {[1] = Target.Character}
        Push.PushTool:FireServer(unpack(args))
    end
    if plr.Character:FindFirstChild("Push") then
        plr.Character.Push.Parent = plr.Backpack
    end
    if plr.Character:FindFirstChild("ModdedPush") then
        FixTool = plr.Character:FindFirstChild("ModdedPush")
        FixTool.Parent = plr.Backpack
        FixTool.Parent = plr.Character
    end
    if plr.Character:FindFirstChild("ClickTarget") then
        FixTool = plr.Character:FindFirstChild("ClickTarget")
        FixTool.Parent = plr.Backpack
        FixTool.Parent = plr.Character
    end
    if plr.Character:FindFirstChild("potion") then
        FixTool = plr.Character:FindFirstChild("potion")
        FixTool.Parent = plr.Backpack
        FixTool.Parent = plr.Character
    end
end

-- Target Tab
local Target = Window:Tab({Title = "Target", Icon = "target"}) do
    Target:Section({Title = "Selecionar Alvo"})

    local targetedPlayer = nil
    local viewEnabled = false
    local flingTargetEnabled = false
    local focusEnabled = false

    Target:Textbox({
        Title = "Target Name",
        Desc = "Digite o nome de exibição do jogador para target",
        Value = "",
        Callback = function(value)
            local foundPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player.DisplayName == value then
                    foundPlayer = player
                    break
                end
            end
            if foundPlayer then
                targetedPlayer = foundPlayer
                Window:Notify({Title = "Alvo", Desc = "Alvo definido para " .. foundPlayer.DisplayName .. " (" .. foundPlayer.Name .. ")", Time = 2})
            else
                Window:Notify({Title = "Alvo", Desc = "Jogador não encontrado", Time = 2})
            end
        end
    })

    Target:Toggle({
        Title = "View Target",
        Desc = "Visualizar o target continuamente",
        Value = false,
        Callback = function(state)
            viewEnabled = state
            if state then
                task.spawn(function()
                    while viewEnabled and targetedPlayer do
                        pcall(function()
                            game.Workspace.CurrentCamera.CameraSubject = targetedPlayer.Character.Humanoid
                        end)
                        task.wait(0.5)
                    end
                end)
                Window:Notify({Title = "Alvo", Desc = "Visualizando " .. targetedPlayer.Name, Time = 2})
            else
                game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
                Window:Notify({Title = "Alvo", Desc = "Parou de visualizar", Time = 2})
            end
        end
    })

    Target:Toggle({
        Title = "Fling Target",
        Desc = "Flingar o target com prediction",
        Value = false,
        Callback = function(state)
            flingTargetEnabled = state
            if state then
                local OldPos = GetRoot(plr).Position
                ToggleFling(true)
                task.spawn(function()
                    while flingTargetEnabled and targetedPlayer do
                        pcall(function()
                            PredictionTP(targetedPlayer, "safe")
                        end)
                        task.wait()
                    end
                end)
                Window:Notify({Title = "Alvo", Desc = "Flingando " .. targetedPlayer.Name, Time = 2})
            else
                ToggleFling(false)
                GetRoot(plr).CFrame = CFrame.new(OldPos.X, OldPos.Y, OldPos.Z)
                Window:Notify({Title = "Alvo", Desc = "Parou de fling", Time = 2})
            end
        end
    })

    Target:Toggle({
        Title = "Focus Target",
        Desc = "Focar e buggar o target",
        Value = false,
        Callback = function(state)
            focusEnabled = state
            if state then
                task.spawn(function()
                    while focusEnabled and targetedPlayer do
                        pcall(function()
                            local target = targetedPlayer
                            if target and target.Character then
                                local targetRoot = GetRoot(target)
                                local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
                                
                                if targetRoot and targetHumanoid then
                                    targetRoot.CFrame = CFrame.new(0, -500, 0)
                                    targetHumanoid.PlatformStand = true
                                    targetHumanoid.WalkSpeed = 0
                                    targetHumanoid.JumpPower = 0
                                    targetRoot.Velocity = Vector3.new(0, 0, 0)
                                    targetRoot.CFrame = targetRoot.CFrame * CFrame.Angles(math.rad(math.random(-10, 10)), math.rad(math.random(-10, 10)), math.rad(math.random(-10, 10)))
                                end
                            end
                        end)
                        task.wait(0.1)
                    end
                end)
                Window:Notify({Title = "Alvo", Desc = "Focando " .. targetedPlayer.Name, Time = 2})
            else
                Window:Notify({Title = "Alvo", Desc = "Parou de focar", Time = 2})
            end
        end
    })

    Target:Button({
        Title = "Empurrar Alvo",
        Desc = "Empurrar o alvo",
        Callback = function()
            if targetedPlayer then
                Push(targetedPlayer)
                Window:Notify({Title = "Alvo", Desc = "Empurrou " .. targetedPlayer.Name, Time = 2})
            end
        end
    })

    Target:Button({
        Title = "Teleportar para Alvo",
        Desc = "Teleportar para o alvo",
        Callback = function()
            if targetedPlayer and targetedPlayer.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHrp = targetedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and targetHrp then
                    hrp.CFrame = targetHrp.CFrame
                    Window:Notify({Title = "Alvo", Desc = "Teleportado para " .. targetedPlayer.Name, Time = 2})
                end
            end
        end
    })

    Target:Button({
        Title = "Whitelistar Alvo",
        Desc = "Adicionar alvo à whitelist",
        Callback = function()
            if targetedPlayer then
                if not table.find(ForceWhitelist, targetedPlayer.UserId) then
                    table.insert(ForceWhitelist, targetedPlayer.UserId)
                    Window:Notify({Title = "Alvo", Desc = "Whitelistado " .. targetedPlayer.Name, Time = 2})
                end
            end
        end
    })

    Target:Button({
        Title = "Sentar na Cabeça do Alvo",
        Desc = "Sentar na cabeça do alvo",
        Callback = function()
            if targetedPlayer and targetedPlayer.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHead = targetedPlayer.Character:FindFirstChild("Head")
                if hrp and targetHead then
                    hrp.CFrame = targetHead.CFrame * CFrame.new(0, 1, 0)
                    Window:Notify({Title = "Alvo", Desc = "Sentando na cabeça de " .. targetedPlayer.Name, Time = 2})
                end
            end
        end
    })

    Target:Button({
        Title = "Ficar em Cima do Alvo",
        Desc = "Ficar em cima do alvo",
        Callback = function()
            if targetedPlayer and targetedPlayer.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHrp = targetedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and targetHrp then
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 3, 0)
                    Window:Notify({Title = "Alvo", Desc = "Em cima de " .. targetedPlayer.Name, Time = 2})
                end
            end
        end
    })

    Target:Button({
        Title = "Nas Costas",
        Desc = "Ficar nas costas do alvo",
        Callback = function()
            if targetedPlayer and targetedPlayer.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHrp = targetedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and targetHrp then
                    local offset = targetHrp.CFrame.LookVector * -1
                    hrp.CFrame = CFrame.new(targetHrp.Position + offset) * targetHrp.CFrame.Rotation
                    Window:Notify({Title = "Alvo", Desc = "Nas costas de " .. targetedPlayer.Name, Time = 2})
                end
            end
        end
    })

    Target:Button({
        Title = "Frente nas Costas",
        Desc = "Ficar nas costas do alvo virado para frente",
        Callback = function()
            if targetedPlayer and targetedPlayer.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHrp = targetedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and targetHrp then
                    local offset = targetHrp.CFrame.LookVector * -1
                    hrp.CFrame = CFrame.new(targetHrp.Position + offset) * targetHrp.CFrame.Rotation * CFrame.Angles(0, math.pi, 0)
                    Window:Notify({Title = "Alvo", Desc = "Frente nas costas de " .. targetedPlayer.Name, Time = 2})
                end
            end
        end
    })

    Target:Section({Title = "Animações"})

    Target:Button({
        Title = "Bang",
        Desc = "Reproduzir animação Bang",
        Callback = function()
            PlayAnim(5918726674, 0, 1)
        end
    })

    Target:Button({
        Title = "Stand",
        Desc = "Reproduzir animação Stand",
        Callback = function()
            PlayAnim(13823324057, 4, 0)
        end
    })

    Target:Button({
        Title = "Doggy",
        Desc = "Reproduzir animação Doggy",
        Callback = function()
            PlayAnim(13694096724, 3.4, 0)
        end
    })

    Target:Button({
        Title = "Drag",
        Desc = "Reproduzir animação Drag",
        Callback = function()
            PlayAnim(10714360343, 0.5, 0)
        end
    })

    Target:Button({
        Title = "Parar Animação",
        Desc = "Parar a animação atual",
        Callback = function()
            StopAnim()
        end
    })
end

-- Fly variables and functions
local ctrl = {f=0,b=0,l=0,r=0}
local lastctrl = {f=0,b=0,l=0,r=0}
local flying = false
local speed = 0
local KeyDownFunction
local KeyUpFunction
local FlySpeed = 50
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

local function PlayAnim(id,time,speed)
    pcall(function()
        plr.Character.Animate.Disabled = false
        local hum = plr.Character.Humanoid
        local animtrack = hum:GetPlayingAnimationTracks()
        for i,track in pairs(animtrack) do
            track:Stop()
        end
        plr.Character.Animate.Disabled = true
        local Anim = Instance.new("Animation")
        Anim.AnimationId = "rbxassetid://"..id
        local loadanim = hum:LoadAnimation(Anim)
        loadanim:Play()
        loadanim.TimePosition = time
        loadanim:AdjustSpeed(speed)
        loadanim.Stopped:Connect(function()
            plr.Character.Animate.Disabled = false
            for i, track in pairs (animtrack) do
                track:Stop()
            end
        end)
    end)
end

local function StopAnim()
    plr.Character.Animate.Disabled = false
    local animtrack = plr.Character.Humanoid:GetPlayingAnimationTracks()
    for i, track in pairs (animtrack) do
        track:Stop()
    end
end

local function Fly()
    local bg = Instance.new("BodyGyro", plr.Character.UpperTorso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = plr.Character.UpperTorso.CFrame
    local bv = Instance.new("BodyVelocity", plr.Character.UpperTorso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    PlayAnim(10714347256,4,0)
    repeat task.wait()
        plr.Character.Humanoid.PlatformStand = true
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed+FlySpeed*0.10
            if speed > FlySpeed then
                speed = FlySpeed
            end
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = speed-FlySpeed*0.10
            if speed < 0 then
                speed = 0
            end
        end
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
        else
            bv.velocity = Vector3.new(0,0.1,0)
        end
        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/FlySpeed),0,0)
    until not flying
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    bg:Destroy()
    bv:Destroy()
    plr.Character.Humanoid.PlatformStand = false
end

-- Exploit Tab
local Exploit = Window:Tab({Title = "Explorar", Icon = "zap"}) do
    Exploit:Section({Title = "Ferramentas AFK"})

    local AFKConnections = {}
    local AFKEventRef = nil
    local AntiAFKConnection = nil

    local function findAFKEvent()
        local ok, ev = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local assets = rs:FindFirstChild("AFKAssets") or rs:WaitForChild("AFKAssets", 2)
            if assets then
                return assets:FindFirstChild("AFKEvent")
            end
            return nil
        end)
        if ok and ev then return ev end
        -- fallback: try to find named event in ReplicatedStorage
        local rs = game:GetService("ReplicatedStorage")
        for _, child in ipairs(rs:GetChildren()) do
            if child.Name and child.Name:lower():find("afk") then
                local maybe = child:FindFirstChild("AFKEvent")
                if maybe then return maybe end
            end
        end
        return nil
    end

    local function enableForceAFK()
        AFKEventRef = findAFKEvent()
        if not AFKEventRef then
            Window:Notify({Title = "Explorar", Desc = "AFKEvent não encontrado em ReplicatedStorage", Time = 3})
            return
        end
        local UserInputService = game:GetService("UserInputService")
        AFKConnections[1] = UserInputService.WindowFocusReleased:Connect(function()
            pcall(function() AFKEventRef:FireServer(true) end)
        end)
        AFKConnections[2] = UserInputService.WindowFocused:Connect(function()
            pcall(function() AFKEventRef:FireServer(false) end)
        end)
        -- Força AFK imediatamente
        pcall(function() AFKEventRef:FireServer(true) end)
        Window:Notify({Title = "Explorar", Desc = "Force AFK ativado", Time = 2})
    end

    local function disableForceAFK()
        for _, c in ipairs(AFKConnections) do
            if c and c.Disconnect then
                c:Disconnect()
            end
        end
        AFKConnections = {}
        if AFKEventRef then pcall(function() AFKEventRef:FireServer(false) end) end
        AFKEventRef = nil
        Window:Notify({Title = "Explorar", Desc = "Force AFK desativado", Time = 2})
    end

    Exploit:Toggle({
        Title = "Ícone AFK Forçado",
        Desc = "Força o ícone AFK usando AFKEvent do servidor",
        Value = false,
        Callback = function(state)
            if state then
                enableForceAFK()
            else
                disableForceAFK()
            end
        end
    })

    Exploit:Toggle({
        Title = "Anti AFK",
        Desc = "Previne kick por inatividade simulando cliques",
        Value = false,
        Callback = function(state)
            if state then
                AntiAFKConnection = plr.Idled:Connect(function()
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                Window:Notify({Title = "Explorar", Desc = "Anti AFK ativado", Time = 2})
            else
                if AntiAFKConnection then
                    AntiAFKConnection:Disconnect()
                    AntiAFKConnection = nil
                end
                Window:Notify({Title = "Explorar", Desc = "Anti AFK desativado", Time = 2})
            end
        end
    })

    -- Anti Void
    local function ToggleVoidProtection(bool)
        if bool then
            game.Workspace.FallenPartsDestroyHeight = 0/0
        else
            game.Workspace.FallenPartsDestroyHeight = -500
        end
    end

    Exploit:Toggle({
        Title = "Anti Vazio",
        Desc = "Alternar proteção contra vazio (usa função segura local)",
        Value = false,
        Callback = function(v)
            ToggleVoidProtection(v)
            Window:Notify({Title = "Explorar", Desc = "Anti Vazio: "..tostring(v), Time = 2})
        end
    })

    -- Anti Algema
    local function ToggleAlgema(bool)
        pcall(function()
            local Players = game:GetService("Players")
            local plr = Players.LocalPlayer
            if not plr or not plr.Character then return end
            local char = plr.Character
            local names = {"Algema", "Handcuff", "Cuff", "Arrest"}
            for _, name in ipairs(names) do
                local scr = char:FindFirstChild(name)
                if scr and (scr:IsA("LocalScript") or scr:IsA("Script")) then
                    scr.Disabled = bool
                end
            end
        end)
    end

    Exploit:Toggle({
        Title = "Anti Algema",
        Desc = "Desabilita scripts de algema (local)",
        Value = false,
        Callback = function(v)
            ToggleAlgema(v)
            Window:Notify({Title = "Explorar", Desc = "Anti Algema: "..tostring(v), Time = 2})
        end
    })

    -- Fly Speed Slider
    Exploit:Slider({
        Title = "Fly Speed",
        Desc = "Ajusta a velocidade do voo",
        Min = 10,
        Max = 200,
        Value = 50,
        Callback = function(value)
            FlySpeed = value
        end
    })

    Exploit:Toggle({
        Title = "Fly",
        Desc = "Ativa voo avançado com animações",
        Value = false,
        Callback = function(state)
            if state then
                flying = true
                KeyDownFunction = mouse.KeyDown:connect(function(key)
                    if key:lower() == "w" then
                        ctrl.f = 1
                        PlayAnim(10714177846,4.65,0)
                    elseif key:lower() == "s" then
                        ctrl.b = -1
                        PlayAnim(10147823318,4.11,0)
                    elseif key:lower() == "a" then
                        ctrl.l = -1
                        PlayAnim(10147823318,3.55,0)
                    elseif key:lower() == "d" then
                        ctrl.r = 1
                        PlayAnim(10147823318,4.81,0)
                    end
                end)
                KeyUpFunction = mouse.KeyUp:connect(function(key)
                    if key:lower() == "w" then
                        ctrl.f = 0
                        PlayAnim(10714347256,4,0)
                    elseif key:lower() == "s" then
                        ctrl.b = 0
                        PlayAnim(10714347256,4,0)
                    elseif key:lower() == "a" then
                        ctrl.l = 0
                        PlayAnim(10714347256,4,0)
                    elseif key:lower() == "d" then
                        ctrl.r = 0
                        PlayAnim(10714347256,4,0)
                    end
                end)
                Fly()
                Window:Notify({Title = "Explorar", Desc = "Fly ativado!", Time = 2})
            else
                flying = false
                if KeyDownFunction then KeyDownFunction:Disconnect() end
                if KeyUpFunction then KeyUpFunction:Disconnect() end
                StopAnim()
                Window:Notify({Title = "Explorar", Desc = "Fly desativado!", Time = 2})
            end
        end
    })
end

-- Sons Tab
local Sons = Window:Tab({Title = "Sons", Icon = "music"}) do
    Sons:Section({Title = "Boombox"})

    local boomboxTool = nil
    local soundId = ""

    Sons:Textbox({
        Title = "ID da Música",
        Desc = "Digite o ID do som do Roblox",
        Value = "",
        Callback = function(value)
            soundId = value
        end
    })

    Sons:Button({
        Title = "Equipar Boombox",
        Desc = "Equipa uma boombox na mão",
        Callback = function()
            if boomboxTool then boomboxTool:Destroy() end
            boomboxTool = Instance.new("Tool")
            boomboxTool.Name = "Boombox"
            boomboxTool.RequiresHandle = true
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1, 1, 1)
            handle.Anchored = false
            handle.CanCollide = false
            handle.Transparency = 1
            handle.Parent = boomboxTool
            local sound = Instance.new("Sound")
            sound.Name = "Music"
            sound.Volume = 10
            sound.Looped = true
            sound.Parent = handle
            boomboxTool.Parent = plr.Backpack
            Window:Notify({Title = "Sons", Desc = "Boombox equipada!", Time = 2})
        end
    })

    Sons:Button({
        Title = "Tocar Música",
        Desc = "Toca a música para todos ouvirem",
        Callback = function()
            if boomboxTool and boomboxTool.Handle then
                local sound = boomboxTool.Handle:FindFirstChild("Music")
                if sound and soundId ~= "" then
                    sound.SoundId = "rbxassetid://" .. soundId
                    sound:Play()
                    Window:Notify({Title = "Sons", Desc = "Música tocando!", Time = 2})
                else
                    Window:Notify({Title = "Sons", Desc = "ID inválido ou boombox não equipada!", Time = 2})
                end
            end
        end
    })

    Sons:Button({
        Title = "Pausar Música",
        Desc = "Pausa a música",
        Callback = function()
            if boomboxTool and boomboxTool.Handle then
                local sound = boomboxTool.Handle:FindFirstChild("Music")
                if sound then
                    sound:Pause()
                    Window:Notify({Title = "Sons", Desc = "Música pausada!", Time = 2})
                end
            end
        end
    })
end

-- Checkpoint respawn handler
plr.CharacterAdded:Connect(function(character)
    task.wait(GetPing() + 0.1)
    character:WaitForChild("Humanoid")
    if SavedCheckpoint then
        local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if hrp then
            pcall(function()
                hrp.CFrame = CFrame.new(SavedCheckpoint)
            end)
        end
    end
end)

-- Final Notification
Window:Notify({
    Title = "Kew Hub",
    Desc = "Carregado com sucesso!",
    Time = 4
})
