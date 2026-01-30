--[[
    ADMIN TOOLS - Modern UI
    Criado para manipulação do cliente local
    Funcionalidades: WalkSpeed, JumpPower, Gravity, Fly, Noclip, ESP, Teleport e mais
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Variáveis de Estado
local AdminState = {
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    FlySpeed = 50,
    Flying = false,
    Noclip = false,
    ESP = false,
    Fullbright = false,
    InfiniteJump = false,
    ClickTP = false,
    LoopBringAll = false,
    AntiLag = false,
    RemoveParticles = false,
    Fling = false,
    Minimized = false
}

local FlyControl = {W = 0, S = 0, A = 0, D = 0}

-- Função para criar UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminToolsUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Container Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 480, 0, 520)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -260)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Corner arredondado
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame
    
    -- Sombra/Borda brilhante
    local BorderGlow = Instance.new("UIStroke")
    BorderGlow.Color = Color3.fromRGB(100, 180, 255)
    BorderGlow.Thickness = 2
    BorderGlow.Transparency = 0.3
    BorderGlow.Parent = MainFrame
    
    -- Gradiente de fundo
    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
    }
    BackgroundGradient.Rotation = 45
    BackgroundGradient.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ ADMIN TOOLS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Gradiente no título
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
    }
    TitleGradient.Parent = Title
    
    -- Botão Minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -50, 0.5, -20)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MinimizeButton.Text = "━"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Header
    
    local MinBtnCorner = Instance.new("UICorner")
    MinBtnCorner.CornerRadius = UDim.new(0, 8)
    MinBtnCorner.Parent = MinimizeButton
    
    -- Container de Conteúdo
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -80)
    ContentFrame.Position = UDim2.new(0, 10, 0, 70)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 255)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.Parent = MainFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame
    
    -- Função para criar seção
    local function CreateSection(name, parent)
        local Section = Instance.new("Frame")
        Section.Name = name .. "Section"
        Section.Size = UDim2.new(1, 0, 0, 40)
        Section.BackgroundTransparency = 1
        Section.Parent = parent
        
        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, 0, 1, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = "▸ " .. name
        SectionLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
        SectionLabel.TextSize = 16
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = Section
        
        return Section
    end
    
    -- Função para criar slider
    local function CreateSlider(name, min, max, default, callback, parent)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = name .. "Slider"
        SliderFrame.Size = UDim2.new(1, 0, 0, 70)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = parent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 10)
        SliderCorner.Parent = SliderFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0.5, -10, 0, 25)
        NameLabel.Position = UDim2.new(0, 15, 0, 10)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = name
        NameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamMedium
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.5, -10, 0, 25)
        ValueLabel.Position = UDim2.new(0.5, 0, 0, 10)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default)
        ValueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
        ValueLabel.TextSize = 14
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "SliderBar"
        SliderBar.Size = UDim2.new(1, -30, 0, 6)
        SliderBar.Position = UDim2.new(0, 15, 1, -20)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = SliderFrame
        
        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = SliderFill
        
        local SliderButton = Instance.new("ImageButton")
        SliderButton.Name = "Button"
        SliderButton.Size = UDim2.new(0, 18, 0, 18)
        SliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
        SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderButton.BorderSizePixel = 0
        SliderButton.Image = ""
        SliderButton.Parent = SliderBar
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = SliderButton
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(100, 180, 255)
        ButtonStroke.Thickness = 2
        ButtonStroke.Parent = SliderButton
        
        local dragging = false
        
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        local function UpdateSlider(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            SliderFill:TweenSize(UDim2.new(pos, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
            SliderButton:TweenPosition(UDim2.new(pos, -9, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
            ValueLabel.Text = tostring(value)
            
            callback(value)
        end
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                UpdateSlider(input)
                dragging = true
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider(input)
            end
        end)
        
        return SliderFrame
    end
    
    -- Função para criar botão toggle
    local function CreateToggle(name, default, callback, parent)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = name .. "Toggle"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 10)
        ToggleCorner.Parent = ToggleFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, -70, 1, 0)
        NameLabel.Position = UDim2.new(0, 15, 0, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = name
        NameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamMedium
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleBtn"
        ToggleButton.Size = UDim2.new(0, 50, 0, 26)
        ToggleButton.Position = UDim2.new(1, -60, 0.5, -13)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(50, 50, 60)
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame
        
        local ToggleBtnCorner = Instance.new("UICorner")
        ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
        ToggleBtnCorner.Parent = ToggleButton
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
        ToggleIndicator.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Parent = ToggleButton
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = ToggleIndicator
        
        local toggled = default
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local bgColor = toggled and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(50, 50, 60)
            local indicatorPos = toggled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = indicatorPos}):Play()
            
            callback(toggled)
        end)
        
        return ToggleFrame
    end
    
    -- Função para criar botão de ação
    local function CreateButton(name, callback, parent)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Button"
        Button.Size = UDim2.new(1, 0, 0, 45)
        Button.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamBold
        Button.BorderSizePixel = 0
        Button.Parent = parent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 10)
        ButtonCorner.Parent = Button
        
        local ButtonGradient = Instance.new("UIGradient")
        ButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 140, 255))
        }
        ButtonGradient.Rotation = 45
        ButtonGradient.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 200, 255)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 180, 255)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(callback)
        
        return Button
    end
    
    -- Criar Seções e Controles
    CreateSection("MOVIMENTO", ContentFrame)
    
    CreateSlider("WalkSpeed", 16, 200, 16, function(value)
        AdminState.WalkSpeed = value
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = value
        end
    end, ContentFrame)
    
    CreateSlider("JumpPower", 50, 300, 50, function(value)
        AdminState.JumpPower = value
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local humanoid = Player.Character.Humanoid
            -- Tenta usar ambos os sistemas para compatibilidade
            humanoid.JumpPower = value
            humanoid.UseJumpPower = true
            -- Se o jogo usa JumpHeight, converte o valor
            pcall(function()
                humanoid.JumpHeight = value / 4 -- Conversão aproximada
            end)
        end
    end, ContentFrame)
    
    CreateSlider("Gravity", 0, 196.2, 196.2, function(value)
        AdminState.Gravity = value
        workspace.Gravity = value
    end, ContentFrame)
    
    CreateSlider("Fly Speed", 10, 200, 50, function(value)
        AdminState.FlySpeed = value
    end, ContentFrame)
    
    CreateSection("HABILIDADES", ContentFrame)
    
    CreateToggle("Fly (Pressione E)", false, function(enabled)
        AdminState.Flying = enabled
    end, ContentFrame)
    
    CreateToggle("Noclip", false, function(enabled)
        AdminState.Noclip = enabled
    end, ContentFrame)
    
    CreateToggle("Infinite Jump", false, function(enabled)
        AdminState.InfiniteJump = enabled
    end, ContentFrame)
    
    CreateToggle("Loop Bring All", false, function(enabled)
        AdminState.LoopBringAll = enabled
    end, ContentFrame)
    
    CreateToggle("Fling (Arremessar Players)", false, function(enabled)
        AdminState.Fling = enabled
    end, ContentFrame)
    
    CreateSection("VISUAL", ContentFrame)
    
    CreateToggle("ESP (Jogadores)", false, function(enabled)
        AdminState.ESP = enabled
    end, ContentFrame)
    
    CreateToggle("Fullbright", false, function(enabled)
        AdminState.Fullbright = enabled
        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end, ContentFrame)
    
    CreateSection("PERFORMANCE", ContentFrame)
    
    CreateToggle("Anti-Lag (Boost FPS)", false, function(enabled)
        AdminState.AntiLag = enabled
    end, ContentFrame)
    
    CreateToggle("Remove Particles/Effects", false, function(enabled)
        AdminState.RemoveParticles = enabled
    end, ContentFrame)
    
    CreateSection("TELEPORTE", ContentFrame)
    
    CreateToggle("Click TP (Ctrl + Click)", false, function(enabled)
        AdminState.ClickTP = enabled
    end, ContentFrame)
    
    CreateButton("Reset Character", function()
        if Player.Character then
            Player.Character:BreakJoints()
        end
    end, ContentFrame)
    
    -- Funcionalidade de minimizar
    MinimizeButton.MouseButton1Click:Connect(function()
        AdminState.Minimized = not AdminState.Minimized
        
        if AdminState.Minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 280, 0, 60)
            }):Play()
            MinimizeButton.Text = "□"
            ContentFrame.Visible = false
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 480, 0, 520)
            }):Play()
            MinimizeButton.Text = "━"
            ContentFrame.Visible = true
        end
    end)
    
    -- Tornar arrastável
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Animação de entrada
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 480, 0, 520)
    }):Play()
end

-- Sistema de Fly
local function SetupFly()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.E then
            AdminState.Flying = not AdminState.Flying
        end
        
        if AdminState.Flying then
            if input.KeyCode == Enum.KeyCode.W then
                FlyControl.W = 1
            elseif input.KeyCode == Enum.KeyCode.S then
                FlyControl.S = 1
            elseif input.KeyCode == Enum.KeyCode.A then
                FlyControl.A = 1
            elseif input.KeyCode == Enum.KeyCode.D then
                FlyControl.D = 1
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            FlyControl.W = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            FlyControl.S = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            FlyControl.A = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            FlyControl.D = 0
        end
    end)
end

-- Sistema de Noclip
local function SetupNoclip()
    RunService.Stepped:Connect(function()
        if AdminState.Noclip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Sistema de Infinite Jump
local function SetupInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if AdminState.InfiniteJump and Player.Character then
            local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- Sistema de ESP
local ESPObjects = {}

local function CreateESP(player)
    if player == Player then return end
    
    local function AddESP(char)
        -- Remove ESP antigo se existir
        if ESPObjects[player.Name] then
            RemoveESP(player.Name)
        end
        
        local humanoidRoot = char:WaitForChild("HumanoidRootPart", 5)
        if not humanoidRoot then return end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP"
        billboardGui.Adornee = humanoidRoot
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = billboardGui
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
        distanceLabel.TextSize = 12
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.TextStrokeTransparency = 0.5
        distanceLabel.Parent = billboardGui
        
        billboardGui.Parent = char
        
        -- Box ESP
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(100, 180, 255)
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = char
        
        ESPObjects[player.Name] = {
            billboard = billboardGui,
            highlight = highlight,
            distanceLabel = distanceLabel,
            character = char,
            humanoidRoot = humanoidRoot
        }
    end
    
    if player.Character then
        AddESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if AdminState.ESP then
            AddESP(char)
        end
    end)
end

local function RemoveESP(playerName)
    if ESPObjects[playerName] then
        pcall(function()
            if ESPObjects[playerName].billboard then
                ESPObjects[playerName].billboard:Destroy()
            end
            if ESPObjects[playerName].highlight then
                ESPObjects[playerName].highlight:Destroy()
            end
        end)
        ESPObjects[playerName] = nil
    end
end

local function UpdateESP()
    -- Loop único otimizado para atualizar distâncias (a cada 0.1s ao invés de todo frame)
    task.spawn(function()
        while true do
            task.wait(0.1) -- Atualiza a cada 100ms ao invés de todo frame
            
            if AdminState.ESP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local myRoot = Player.Character.HumanoidRootPart
                
                for playerName, espData in pairs(ESPObjects) do
                    if espData.humanoidRoot and espData.humanoidRoot.Parent and espData.distanceLabel then
                        pcall(function()
                            local distance = (myRoot.Position - espData.humanoidRoot.Position).Magnitude
                            espData.distanceLabel.Text = math.floor(distance) .. " studs"
                        end)
                    end
                end
            end
        end
    end)
    
    -- Detecta novos jogadores instantaneamente usando evento
    Players.PlayerAdded:Connect(function(player)
        if AdminState.ESP and player ~= Player then
            -- Aguarda o personagem carregar
            if player.Character then
                CreateESP(player)
            end
            player.CharacterAdded:Connect(function()
                task.wait(0.5)
                if AdminState.ESP then
                    CreateESP(player)
                end
            end)
        end
    end)
    
    -- Adiciona ESP para jogadores já no jogo
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and AdminState.ESP then
            CreateESP(player)
        end
    end
    
    -- Remove ESP quando jogador sai
    Players.PlayerRemoving:Connect(function(player)
        RemoveESP(player.Name)
    end)
    
    -- Monitora ativação/desativação do ESP
    task.spawn(function()
        local lastESPState = AdminState.ESP
        while true do
            task.wait(0.5)
            
            if AdminState.ESP ~= lastESPState then
                if AdminState.ESP then
                    -- ESP foi ativado - adiciona para todos
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= Player then
                            CreateESP(player)
                        end
                    end
                else
                    -- ESP foi desativado - remove de todos
                    for playerName in pairs(ESPObjects) do
                        RemoveESP(playerName)
                    end
                end
                lastESPState = AdminState.ESP
            end
        end
    end)
end

-- Sistema de Fling
local FlingConnection
local OriginalVelocities = {}

local function SetupFling()
    local function StartFling()
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        local rootPart = Player.Character.HumanoidRootPart
        
        if not humanoid or not rootPart then return end
        
        -- Salva velocidades originais
        OriginalVelocities = {}
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                OriginalVelocities[part] = {
                    Velocity = part.Velocity,
                    RotVelocity = part.RotVelocity,
                    AssemblyLinearVelocity = part.AssemblyLinearVelocity,
                    AssemblyAngularVelocity = part.AssemblyAngularVelocity
                }
            end
        end
        
        -- Desabilita temporariamente a física do humanoid
        local originalState = humanoid:GetState()
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        -- Sistema de Fling otimizado
        FlingConnection = RunService.Heartbeat:Connect(function()
            if not AdminState.Fling or not Player.Character or not rootPart.Parent then
                if FlingConnection then
                    FlingConnection:Disconnect()
                    FlingConnection = nil
                end
                return
            end
            
            -- Aplica velocidade extrema de rotação
            pcall(function()
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(9e9, 9e9, 9e9)
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
                
                -- Mantém o jogador no lugar visualmente
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part ~= rootPart then
                        part.Velocity = Vector3.new(0, 0, 0)
                        part.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end)
        
        -- Sistema de detecção de colisão para fling
        task.spawn(function()
            while AdminState.Fling and Player.Character and rootPart.Parent do
                task.wait(0.05)
                
                -- Detecta jogadores próximos para fling
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = player.Character.HumanoidRootPart
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        
                        -- Se estiver próximo o suficiente, aplica força
                        if distance < 8 then
                            pcall(function()
                                local direction = (targetRoot.Position - rootPart.Position).Unit
                                local force = direction * 100 + Vector3.new(0, 50, 0)
                                
                                -- Aplica velocidade no alvo
                                targetRoot.Velocity = force
                                targetRoot.AssemblyLinearVelocity = force
                            end)
                        end
                    end
                end
            end
        end)
    end
    
    local function StopFling()
        if FlingConnection then
            FlingConnection:Disconnect()
            FlingConnection = nil
        end
        
        if Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
            
            -- Restaura velocidades
            for part, velocities in pairs(OriginalVelocities) do
                if part and part.Parent then
                    pcall(function()
                        part.Velocity = Vector3.new(0, 0, 0)
                        part.RotVelocity = Vector3.new(0, 0, 0)
                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end
            
            OriginalVelocities = {}
        end
    end
    
    -- Monitor de estado do Fling
    task.spawn(function()
        local lastFlingState = false
        while true do
            task.wait(0.1)
            
            if AdminState.Fling ~= lastFlingState then
                if AdminState.Fling then
                    StartFling()
                else
                    StopFling()
                end
                lastFlingState = AdminState.Fling
            end
        end
    end)
    
    -- Para o fling ao morrer/respawnar
    Player.CharacterAdded:Connect(function()
        AdminState.Fling = false
        StopFling()
    end)
end

-- Sistema de Anti-Lag e Performance
local function SetupAntiLag()
    local Settings = UserSettings()
    local GameSettings = Settings.GameSettings
    
    -- Função para remover partículas e efeitos
    local function RemoveEffects()
        for _, obj in pairs(workspace:GetDescendants()) do
            if AdminState.RemoveParticles then
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
                   obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Sound") then
                    pcall(function()
                        obj.Enabled = false
                    end)
                end
                
                if obj:IsA("Beam") or obj:IsA("SurfaceLight") or obj:IsA("PointLight") or 
                   obj:IsA("SpotLight") then
                    pcall(function()
                        obj.Enabled = false
                    end)
                end
            end
        end
    end
    
    -- Função principal de Anti-Lag
    local function ApplyAntiLag(enabled)
        if enabled then
            -- Reduz qualidade gráfica
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            
            -- Desativa sombras e efeitos
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or 
                   v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or 
                   v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end
            
            -- Otimiza configurações de física
            settings().Physics.AllowSleep = true
            settings().Physics.ThrottleAdjustTime = 0
            
            -- Desativa animações de terreno
            workspace.Terrain.Decoration = false
            
            -- Reduz distância de renderização
            pcall(function()
                GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)
            
            -- Remove detalhes desnecessários do workspace
            for _, obj in pairs(workspace:GetDescendants()) do
                -- Remove decals e texturas
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
                
                -- Simplifica meshes
                if obj:IsA("MeshPart") then
                    obj.RenderFidelity = Enum.RenderFidelity.Performance
                end
                
                -- Reduz qualidade de ParticleEmitters
                if obj:IsA("ParticleEmitter") then
                    obj.Rate = math.min(obj.Rate, 10)
                end
            end
            
            -- Desativa materiais do terreno (melhora muito o FPS)
            pcall(function()
                workspace.Terrain.WaterReflectance = 0
                workspace.Terrain.WaterTransparency = 0
                workspace.Terrain.WaterWaveSize = 0
                workspace.Terrain.WaterWaveSpeed = 0
            end)
            
        else
            -- Restaura configurações normais
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or 
                   v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or 
                   v:IsA("DepthOfFieldEffect") then
                    v.Enabled = true
                end
            end
            
            workspace.Terrain.Decoration = true
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 0
                end
                
                if obj:IsA("MeshPart") then
                    obj.RenderFidelity = Enum.RenderFidelity.Automatic
                end
            end
        end
    end
    
    -- Monitor de mudanças
    RunService.Heartbeat:Connect(function()
        if AdminState.AntiLag then
            ApplyAntiLag(true)
        end
        
        if AdminState.RemoveParticles then
            RemoveEffects()
        end
    end)
    
    -- Aplica anti-lag em novos objetos
    workspace.DescendantAdded:Connect(function(obj)
        if AdminState.AntiLag then
            task.wait(0.1)
            
            if obj:IsA("MeshPart") then
                obj.RenderFidelity = Enum.RenderFidelity.Performance
            end
            
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
        
        if AdminState.RemoveParticles then
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
               obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function()
                    obj.Enabled = false
                end)
            end
        end
    end)
end

-- Sistema de Click TP
local function SetupClickTP()
    Mouse.Button1Down:Connect(function()
        if AdminState.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position)
            end
        end
    end)
end

-- Sistema de Loop Bring All
local function SetupLoopBringAll()
    RunService.Heartbeat:Connect(function()
        if AdminState.LoopBringAll and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = Player.Character.HumanoidRootPart
            local myPos = myRoot.CFrame
            
            -- Pega a direção que o jogador está olhando
            local lookDirection = myRoot.CFrame.LookVector
            
            -- Posição na frente do jogador (5 studs)
            local targetPosition = myPos.Position + (lookDirection * 5)
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = player.Character.HumanoidRootPart
                    
                    -- Todos os jogadores vão para o MESMO local exato
                    pcall(function()
                        targetRoot.CFrame = CFrame.new(targetPosition, myPos.Position)
                    end)
                end
            end
        end
    end)
end

-- Loop principal do Fly
RunService.Heartbeat:Connect(function()
    if AdminState.Flying and Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            humanoid.PlatformStand = true
            
            local velocity = Vector3.new(
                (FlyControl.D - FlyControl.A) * AdminState.FlySpeed,
                0,
                (FlyControl.S - FlyControl.W) * AdminState.FlySpeed
            )
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, AdminState.FlySpeed, 0)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, AdminState.FlySpeed, 0)
            end
            
            rootPart.Velocity = Camera.CFrame:VectorToWorldSpace(velocity)
        end
    elseif Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end)

-- Manter valores ao respawnar
Player.CharacterAdded:Connect(function(char)
    wait(0.1)
    
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = AdminState.WalkSpeed
    
    -- Aplica JumpPower de forma compatível
    humanoid.JumpPower = AdminState.JumpPower
    humanoid.UseJumpPower = true
    pcall(function()
        humanoid.JumpHeight = AdminState.JumpPower / 4
    end)
    
    workspace.Gravity = AdminState.Gravity
    
    if AdminState.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

-- Inicializar sistemas
CreateUI()
SetupFly()
SetupNoclip()
SetupInfiniteJump()
UpdateESP()
SetupFling()
SetupAntiLag()
SetupClickTP()
SetupLoopBringAll()

-- Notificação de carregamento
local function CreateNotification(text)
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.ResetOnSpawn = false
    NotifGui.Parent = Player.PlayerGui
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 60)
    NotifFrame.Position = UDim2.new(0.5, -150, 1, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = NotifFrame
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(100, 180, 255)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame
    
    local NotifLabel = Instance.new("TextLabel")
    NotifLabel.Size = UDim2.new(1, -20, 1, 0)
    NotifLabel.Position = UDim2.new(0, 10, 0, 0)
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Text = text
    NotifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifLabel.TextSize = 14
    NotifLabel.Font = Enum.Font.GothamMedium
    NotifLabel.Parent = NotifFrame
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 1, -80)
    }):Play()
    
    wait(3)
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.5), {
        Position = UDim2.new(0.5, -150, 1, 0)
    }):Play()
    
    wait(0.5)
    NotifGui:Destroy()
end

CreateNotification("⚡ Admin Tools carregado com sucesso!")

print("Admin Tools v1.0 - Carregado com sucesso!")
