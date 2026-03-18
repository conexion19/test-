-- [Bypass Anti-Cheat]
if not getgenv().HeliosBypass then
    getgenv().HeliosBypass = true
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

local Helios = {
    Version = "Inspired",
}

-- [Services]
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local OpenFrames = {}
local Options = {}
Helios.Options = Options
Helios.Theme = "Slate"
Helios.Window = nil

local Themes = {
    Dark = {
        Name = "Slate",
        Accent = Color3.fromRGB(114, 137, 218), -- Modern Blurple
        AcrylicMain = Color3.fromRGB(18, 18, 20),
        AcrylicBorder = Color3.fromRGB(45, 45, 50),
        Background = Color3.fromRGB(13, 13, 15),
        TitleBarLine = Color3.fromRGB(35, 35, 40),
        Tab = Color3.fromRGB(22, 22, 25),
        TabHover = Color3.fromRGB(30, 30, 35),
        Element = Color3.fromRGB(26, 26, 30),
        ElementBorder = Color3.fromRGB(45, 45, 50),
        Divider = Color3.fromRGB(38, 38, 42),
        SliderRail = Color3.fromRGB(35, 35, 40),
        Text = Color3.fromRGB(250, 250, 250),
        SubText = Color3.fromRGB(150, 150, 155),
        Hover = Color3.fromRGB(35, 35, 40),
    }
}
Helios.Themes = Themes
Helios.MinimizeKeybind = "LeftAlt"

-- [Creator Implementation]
local Creator = {
    Registry = {},
    Signals = {},
    DefaultProperties = {
        ScreenGui = { ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
        Frame = { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 },
        ScrollingFrame = { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.fromRGB(80,80,80) },
        TextLabel = { BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1, 1, 1) },
        TextButton = { AutoButtonColor = false, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1, 1, 1) },
        TextBox = { ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1, 1, 1) },
        ImageLabel = { BackgroundTransparency = 1, BorderSizePixel = 0 },
        UIStroke = { Thickness = 1, Color = Color3.fromRGB(60,60,60) }
    },
}

function Creator.New(Name, Properties, Children)
    local Object = Instance.new(Name)
    local Default = Creator.DefaultProperties[Name] or {}
    for K, V in pairs(Default) do Object[K] = V end
    for K, V in pairs(Properties or {}) do 
        if K ~= "ThemeTag" then Object[K] = V end 
    end
    for _, Child in pairs(Children or {}) do Child.Parent = Object end
    
    if Properties and Properties.ThemeTag then
        Creator.AddThemeObject(Object, Properties.ThemeTag)
    end
    return Object
end

function Creator.AddThemeObject(Object, Properties)
    Creator.Registry[Object] = Properties
    Creator.UpdateTheme()
    return Object
end

function Creator.UpdateTheme()
    local Theme = Themes[Helios.Theme] or Themes.Dark
    for Object, Props in pairs(Creator.Registry) do
        for Prop, ThemeKey in pairs(Props) do
            if Theme[ThemeKey] then Object[Prop] = Theme[ThemeKey] end
        end
    end
end

local function Connect(Signal, Function)
    local Conn = Signal:Connect(Function)
    table.insert(Creator.Signals, Conn)
    return Conn
end

-- [Security / Protection]
local function GetSafeParent()
    if RunService:IsStudio() then
        return game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    local target = CoreGui
    if gethui then
        target = gethui()
    elseif syn and syn.protect_gui then
        target = CoreGui
    end
    return target
end

local function ProtectInstance(instance)
    if not RunService:IsStudio() and syn and syn.protect_gui then
        pcall(function() syn.protect_gui(instance) end)
    end
end

-- [Main GUI]
local ScreenGui = Creator.New("ScreenGui", {
    Name = "HeliosUI",
    Parent = GetSafeParent(),
})
ProtectInstance(ScreenGui)

function Helios:CreateWindow(Config)
    if Helios.Window then return Helios.Window end
    
    local Window = { Tabs = {} }
    local Title = Config.Title or "Helios"
    local SubTitle = Config.SubTitle or ""
    local Size = Config.Size or UDim2.fromOffset(580, 460)
    
    -- Main Window Frame
    local Root = Creator.New("Frame", {
        Name = "Root",
        Size = Size,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui,
        ThemeTag = { BackgroundColor3 = "AcrylicMain" }
    }, {
        Creator.New("UIStroke", { ThemeTag = { Color = "AcrylicBorder" }, Thickness = 1 }),
    })
    
    -- Top Bar (Drag Area)
    local TopBar = Creator.New("Frame", {
         Size = UDim2.new(1, 0, 0, 40),
         BackgroundTransparency = 1,
         Parent = Root
    }, {
        -- Creative element: Pulsing Status Dot with Version
        Creator.New("Frame", {
            Name = "PulseDot",
            Size = UDim2.new(0, 8, 0, 8),
            Position = UDim2.new(0, 16, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            ThemeTag = { BackgroundColor3 = "Accent" }
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            Creator.New("UIStroke", { ThemeTag = { Color = "Accent" }, Thickness = 1, Transparency = 0.2 })
        }),
        Creator.New("TextLabel", {
            Text = "v" .. Helios.Version,
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeTag = { TextColor3 = "SubText" },
            TextSize = 11
        }),
        
        -- Centered Titles
        Creator.New("TextLabel", {
            Text = Title,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 4),
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            ThemeTag = { TextColor3 = "Text" },
            TextSize = 15
        }),
        Creator.New("TextLabel", {
            Text = SubTitle,
            Size = UDim2.new(1, 0, 0, 15),
            Position = UDim2.new(0, 0, 0, 22),
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Center,
            ThemeTag = { TextColor3 = "SubText" },
            TextSize = 12
        })
    })

    -- Pulse Animation
    task.spawn(function()
        local dot = TopBar:FindFirstChild("PulseDot")
        if dot then
            local stroke = dot:FindFirstChildOfClass("UIStroke")
            while task.wait(1.5) do
                if not dot.Parent or not stroke then break end
                pcall(function()
                    TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true), { Thickness = 6, Transparency = 1 }):Play()
                end)
            end
        end
    end)

    -- Divider below Top Bar
    Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 40),
        Parent = Root,
        ThemeTag = { BackgroundColor3 = "TitleBarLine" }
    })
    
    -- Dragging Logic
    local Dragging, DragInput, DragStart, StartPos
    Connect(TopBar.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Root.Position
            Input.Changed:Connect(function() if Input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    Connect(TopBar.InputChanged, function(Input) if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end end)
    Connect(UserInputService.InputChanged, function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Root.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    
    -- Content Layout
    local TabHolder = Creator.New("ScrollingFrame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 160, 1, -41),
        Position = UDim2.new(0, 0, 0, 41),
        BackgroundTransparency = 1,
        Parent = Root,
        ScrollBarThickness = 0 
    }, {
        Creator.New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
        Creator.New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
    })

    -- Sidebar Divider
    Creator.New("Frame", {
        Size = UDim2.new(0, 1, 1, -41),
        Position = UDim2.new(0, 160, 0, 41),
        Parent = Root,
        ThemeTag = { BackgroundColor3 = "TitleBarLine" }
    })
    
    local ContainerHolder = Creator.New("Frame", {
        Name = "ContainerHolder",
        Size = UDim2.new(1, -161, 1, -41),
        Position = UDim2.new(0, 161, 0, 41),
        BackgroundTransparency = 1,
        Parent = Root,
    })
    
    -- Top Right Info (FPS, Ping, Time)
    local TopInfoLabel = Creator.New("TextLabel", {
        Size = UDim2.new(0, 0, 0, 20),
        Position = UDim2.new(1, -15, 0, 10), -- Top right corner padding
        AnchorPoint = Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Parent = Root,
        ThemeTag = { TextColor3 = "SubText" },
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 50
    })

    local FrameCount = 0
    Connect(RunService.RenderStepped, function()
        FrameCount = FrameCount + 1
    end)

    task.spawn(function()
        while task.wait(1) do
            if not ScreenGui or not ScreenGui.Parent then break end
            local ping = 0
            pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            TopInfoLabel.Text = string.format("FPS: %d   |   Ping: %dms   |   %s", FrameCount, ping, os.date("%H:%M:%S"))
            FrameCount = 0
        end
    end)
    
    Window.Root = Root
    
    function Window:SelectTab(Index)
        local tab = self.Tabs[Index]
        if tab and type(tab.Show) == "function" then
            tab.Show()
        end
    end

    -- Window aliases
    function Window:BuildInterfaceSection(Config)
        if #self.Tabs == 0 then self:AddTab({Title="Tab"}) end
        local Title = type(Config) == "table" and (Config.Title or Config.Name) or Config
        return self.Tabs[#self.Tabs]:AddSection(Title)
    end
    
    function Window:BuildInterfaceCategory(Config)
        return self:AddTab(type(Config) == "table" and Config or {Title = Config})
    end

    function Window:AddTab(Config)
        local TabTitle = Config.Title or "Tab"
        
        local TabButton = Creator.New("TextButton", {
            Text = "",
            Size = UDim2.new(1, 0, 0, 36),
            Parent = TabHolder,
            ThemeTag = { BackgroundColor3 = "Tab" },
            BackgroundTransparency = 1, 
        }, { 
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Creator.New("TextLabel", {
                 Text = TabTitle,
                 Size = UDim2.new(1, -20, 1, 0),
                 Position = UDim2.new(0, 10, 0, 0),
                 ThemeTag = { TextColor3 = "Text" },
                 TextXAlignment = Enum.TextXAlignment.Left,
                 Font = Enum.Font.GothamMedium,
                 TextSize = 14
            })
        })
        
        local Container = Creator.New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = ContainerHolder,
            Visible = false,
            ScrollBarThickness = 2,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }),
            Creator.New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) })
        })

        -- Tab Selection Logic
        local function Select()
             for _, T in pairs(Window.Tabs) do 
                 T.Container.Visible = false 
                 TweenService:Create(T.Button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                 T.Button.TextLabel.TextColor3 = Themes.Dark.SubText
             end
             Container.Visible = true
             TweenService:Create(TabButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.92 }):Play() -- Subtle highlight
             TabButton.TextLabel.TextColor3 = Themes.Dark.Text
        end

        Connect(TabButton.MouseButton1Click, Select)
        
        -- Default selection
        if #Window.Tabs == 0 then 
            Container.Visible = true 
            TweenService:Create(TabButton, TweenInfo.new(0), { BackgroundTransparency = 0.92 }):Play()
        else
            TabButton.TextLabel.TextColor3 = Themes.Dark.SubText
        end
        
        local Tab = { Container = Container, Button = TabButton, Show = Select }
        table.insert(Window.Tabs, Tab)

        function Tab:Select()
            self.Show()
        end

        local function CreateElement(Parent, Type, EConfig, Key)
            if Type == "Button" then
                 local BtnFrame = Creator.New("TextButton", {
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" }
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                    Creator.New("TextLabel", {
                        Text = EConfig.Title or "Button",
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = { TextColor3 = "Text" },
                        Font = Enum.Font.GothamMedium,
                        TextSize = 13,
                    })
                })
                Connect(BtnFrame.MouseButton1Click, EConfig.Callback or function() end)
                return BtnFrame

            elseif Type == "Toggle" then
                local Toggled = EConfig.Default or false
                local Btn = Creator.New("TextButton", {
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" },
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                    Creator.New("TextLabel", {
                        Text = (EConfig.Title or Key),
                        Size = UDim2.new(1, -50, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        ThemeTag = { TextColor3 = "Text" },
                        Font = Enum.Font.GothamMedium,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    })
                })
                
                -- Toggle Switch UI
                local SwitchBg = Creator.New("Frame", {
                     Size = UDim2.new(0, 36, 0, 18),
                     Position = UDim2.new(1, -46, 0.5, -9),
                     Parent = Btn,
                     BackgroundColor3 = Toggled and Themes.Dark.Accent or Color3.fromRGB(60,60,60),
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                
                local SwitchKnob = Creator.New("Frame", {
                     Size = UDim2.new(0, 14, 0, 14),
                     Position = UDim2.new(0, Toggled and 20 or 2, 0.5, -7),
                     Parent = SwitchBg,
                     BackgroundColor3 = Color3.fromRGB(255,255,255)
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                
                local function Update()
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), { BackgroundColor3 = Toggled and Themes.Dark.Accent or Color3.fromRGB(60,60,60) }):Play()
                    TweenService:Create(SwitchKnob, TweenInfo.new(0.2), { Position = UDim2.new(0, Toggled and 20 or 2, 0.5, -7) }):Play()
                    if EConfig.Callback then EConfig.Callback(Toggled) end
                end
                
                Connect(Btn.MouseButton1Click, function() Toggled = not Toggled; Update() end)
                
                local Toggle = { 
                    Value = Toggled, 
                    SetValue = function(self, v) Toggled = v; Update() end,
                    Type = "Toggle"
                }
                Helios.Options[Key] = Toggle
                return Toggle

            elseif Type == "Slider" then
                 local Min, Max = EConfig.Min or 0, EConfig.Max or 100
                 local Default = EConfig.Default or Min
                 local Value = Default
                 local Rounding = EConfig.Rounding or 0
                 
                 local Frame = Creator.New("Frame", {
                     Size = UDim2.new(1, 0, 0, 50),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" }
                 }, {
                     Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                     Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                     Creator.New("TextLabel", {
                         Text = (EConfig.Title or Key),
                         Size = UDim2.new(1, -10, 0, 20),
                         Position = UDim2.fromOffset(10, 8),
                         ThemeTag = { TextColor3 = "Text" },
                         Font = Enum.Font.Gotham,
                         TextXAlignment = Enum.TextXAlignment.Left
                     }),
                     Creator.New("TextLabel", {
                         Name = "ValueLabel",
                         Text = tostring(Value),
                         Size = UDim2.new(0, 40, 0, 20),
                         Position = UDim2.new(1, -50, 0, 8),
                         ThemeTag = { TextColor3 = "SubText" },
                         Font = Enum.Font.Gotham,
                         TextXAlignment = Enum.TextXAlignment.Right
                     })
                 })
                 
                 local SliderBar = Creator.New("TextButton", {
                     Text = "",
                     Size = UDim2.new(1, -20, 0, 4),
                     Position = UDim2.new(0, 10, 0, 35),
                     Parent = Frame,
                     ThemeTag = { BackgroundColor3 = "SliderRail" }
                 }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                 
                 local Fill = Creator.New("Frame", {
                     Size = UDim2.fromScale((Value - Min)/(Max - Min), 1),
                     ThemeTag = { BackgroundColor3 = "Accent" },
                     Parent = SliderBar
                 }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                 
                 local function Update(Input)
                     local Scale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                     local NewValue = Min + ((Max - Min) * Scale)
                     if Rounding == 0 then NewValue = math.floor(NewValue + 0.5)
                     else NewValue = math.floor(NewValue * (10^Rounding) + 0.5) / (10^Rounding) end
                     Value = NewValue
                     Fill.Size = UDim2.fromScale(Scale, 1)
                     Frame.ValueLabel.Text = tostring(Value)
                     if EConfig.Callback then EConfig.Callback(Value) end
                 end
                 
                 local Dragging = false
                 Connect(SliderBar.InputBegan, function(Input)
                     if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; Update(Input) end
                 end)
                 Connect(UserInputService.InputEnded, function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                 Connect(UserInputService.InputChanged, function(Input) if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end end)

                 local SliderObj = { 
                     Value = Value, 
                     SetValue = function(self, v) 
                        Value = v; Fill.Size = UDim2.fromScale(math.clamp((Value - Min)/(Max - Min), 0, 1), 1)
                        Frame.ValueLabel.Text = tostring(Value)
                        if EConfig.Callback then EConfig.Callback(Value) end
                     end,
                     Type = "Slider"
                 }
                 Helios.Options[Key] = SliderObj
                 return SliderObj

            elseif Type == "Dropdown" then
                local Values = EConfig.Values or {}
                local Default = EConfig.Default
                local Multi = EConfig.Multi or false
                local Value = Default or (Multi and {} or Values[1])
                local Expanded = false

                local Frame = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" },
                    ClipsDescendants = true
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 })
                })
                
                local Button = Creator.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = (EConfig.Title or Key),
                    ThemeTag = { TextColor3 = "Text" },
                    Font = Enum.Font.Gotham
                }, { Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10)})})

                local ValLabel = Creator.New("TextLabel", {
                    Text = (type(Value) == "table" and table.concat(Value, ", ") or tostring(Value)),
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(1, -120, 0, 0),
                    Parent = Button,
                    ThemeTag = { TextColor3 = "SubText" },
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                Creator.New("ImageLabel", {
                    Image = "rbxassetid://9873138319", -- Chevron Down
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -25, 0.5, -8),
                    Parent = Button,
                    ThemeTag = { ImageColor3 = "SubText" }
                })
                
                local List = Creator.New("Frame", {
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, 45),
                    BackgroundTransparency = 1,
                    Parent = Frame
                }, { Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }) })
                
                local function RefreshList()
                    for _, c in pairs(List:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, Val in pairs(Values) do
                        local Item = Creator.New("TextButton", {
                             Text = Val,
                             Size = UDim2.new(1, 0, 0, 25),
                             Parent = List,
                             ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "SubText" },
                             Font = Enum.Font.Gotham,
                             BackgroundTransparency = 0.5
                        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4)}) })
                        Connect(Item.MouseButton1Click, function()
                             if Multi then
                                  if table.find(Value, Val) then for idx, v in pairs(Value) do if v == Val then table.remove(Value, idx) end end
                                  else table.insert(Value, Val) end
                                  ValLabel.Text = table.concat(Value, ", ")
                                  if EConfig.Callback then EConfig.Callback(Value) end
                             else
                                  Value = Val
                                  ValLabel.Text = tostring(Value)
                                  Expanded = false
                                  TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 40) }):Play()
                                  if EConfig.Callback then EConfig.Callback(Value) end
                             end
                        end)
                    end
                    if Expanded then 
                        local h = (#Values * 30) + 50
                        TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, h) }):Play()
                    end
                end
                
                Connect(Button.MouseButton1Click, function()
                    Expanded = not Expanded
                    if Expanded then RefreshList() else 
                        TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 40) }):Play()
                    end
                end)
                
                local DropdownObj = {
                    Value = Value,
                    Type = "Dropdown"
                }
                Helios.Options[Key] = DropdownObj
                return DropdownObj

            elseif Type == "Input" then
                local Frame = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" } 
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 })
                })
                
                Creator.New("TextLabel", {
                    Text = EConfig.Title or Key,
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local InputBg = Creator.New("Frame", {
                    Size = UDim2.new(0, 140, 0, 26),
                    Position = UDim2.new(1, -150, 0.5, -13),
                    Parent = Frame,
                    BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                local TextBox = Creator.New("TextBox", {
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = EConfig.Default or "",
                    Parent = InputBg,
                    ThemeTag = { TextColor3 = "Text" },
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Connect(TextBox.FocusLost, function() if EConfig.Callback then EConfig.Callback(TextBox.Text) end end)
                
                local InputObj = { Value = TextBox.Text, SetValue = function(self, v) TextBox.Text = v end, Type = "Input" }
                Helios.Options[Key] = InputObj
                return InputObj

            elseif Type == "Paragraph" then
                 local PConfig = EConfig or {}
                 local Wrapper = Creator.New("Frame", {
                     Size = UDim2.new(1, 0, 0, 60), -- AutomaticSize applied later
                     AutomaticSize = Enum.AutomaticSize.Y,
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" }
                 }, {
                     Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                     Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                     Creator.New("UIPadding", { PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) }),
                     Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
                 })
                 
                 Creator.New("TextLabel", {
                     Text = PConfig.Title or "Paragraph",
                     Size = UDim2.new(1, 0, 0, 18),
                     BackgroundTransparency = 1,
                     Parent = Wrapper,
                     ThemeTag = { TextColor3 = "Text" },
                     Font = Enum.Font.GothamBold,
                     TextXAlignment = Enum.TextXAlignment.Left,
                     TextSize = 15
                 })
                 
                 Creator.New("TextLabel", {
                     Text = PConfig.Content or "",
                     Size = UDim2.new(1, 0, 0, 0),
                     AutomaticSize = Enum.AutomaticSize.Y,
                     BackgroundTransparency = 1,
                     Parent = Wrapper,
                     ThemeTag = { TextColor3 = "SubText" },
                     TextXAlignment = Enum.TextXAlignment.Left,
                     TextWrapped = true,
                     Font = Enum.Font.Gotham,
                     TextSize = 13
                 })
                 return Wrapper
                 
            elseif Type == "Colorpicker" then
                -- Simplified Colorpicker
                local Color = EConfig.Default or Color3.fromRGB(255, 255, 255)
                local Frame = Creator.New("Frame", {
                     Size = UDim2.new(1, 0, 0, 40),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" }
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 })
                })
                
                Creator.New("TextLabel", {
                    Text = (EConfig.Title or Key),
                    Size = UDim2.new(1, -50, 0, 30),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Preview = Creator.New("Frame", {
                    Size = UDim2.new(0, 30, 0, 20),
                    Position = UDim2.new(1, -40, 0.5, -10),
                    BackgroundColor3 = Color,
                    Parent = Frame,
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4) }) })
                
                local ColorObj = {
                    Value = Color,
                    SetValueRGB = function(self, rgb) Color = rgb; Preview.BackgroundColor3 = rgb; end,
                    Type = "Colorpicker"
                }
                Helios.Options[Key] = ColorObj
                return ColorObj
                
            elseif Type == "Keybind" then
                 local Binding = EConfig.Default
                 if type(Binding) == "string" then
                     Binding = Enum.KeyCode[Binding] or Enum.KeyCode.Unknown
                 end
                 local Frame = Creator.New("TextButton", {
                     Size = UDim2.new(1, 0, 0, 40),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" },
                     Text = "",
                 }, { 
                     Creator.New("UICorner", { CornerRadius = UDim.new(0,8) }),
                     Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                 })
                 
                 Creator.New("TextLabel", {
                     Text = (EConfig.Title or Key),
                     Size = UDim2.new(1, -60, 1, 0),
                     Position = UDim2.new(0,12,0,0),
                     ThemeTag = { TextColor3 = "Text" },
                     Font = Enum.Font.GothamMedium,
                     TextSize = 13,
                     TextXAlignment = Enum.TextXAlignment.Left,
                     Parent = Frame
                 })

                 local BindLabel = Creator.New("TextLabel", {
                     Text = "["..(Binding.Name or "None").."]",
                     Size = UDim2.new(0, 60, 1, 0),
                     Position = UDim2.new(1,-70,0,0),
                     ThemeTag = { TextColor3 = "SubText" },
                     Font = Enum.Font.GothamMedium,
                     TextSize = 13,
                     TextXAlignment = Enum.TextXAlignment.Right,
                     Parent = Frame
                 })
                 
                 local KeybindObj = { Value = Binding, Type = "Keybind" }
                 
                 local Listening = false
                 Connect(Frame.MouseButton1Click, function()
                     Listening = true
                     BindLabel.Text = "[...]"
                 end)
                 
                 Connect(UserInputService.InputBegan, function(Input)
                     if Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
                         Listening = false
                         Binding = Input.KeyCode
                         KeybindObj.Value = Binding
                         BindLabel.Text = "["..Binding.Name.."]"
                         if EConfig.Callback then
                             pcall(EConfig.Callback, Binding.Name)
                         end
                     end
                 end)
                 
                 Helios.Options[Key] = KeybindObj
                 function KeybindObj:SetValue(keyName)
                     pcall(function()
                         Binding = Enum.KeyCode[keyName]
                         KeybindObj.Value = Binding
                         BindLabel.Text = "["..Binding.Name.."]"
                     end)
                 end
                 return KeybindObj
            end
        end

        function Tab:AddParagraph(Config) return CreateElement(Container, "Paragraph", Config, nil) end
        function Tab:AddButton(Config) return CreateElement(Container, "Button", Config, nil) end
        function Tab:AddToggle(Key, Config) return CreateElement(Container, "Toggle", Config, Key) end
        function Tab:AddSlider(Key, Config) return CreateElement(Container, "Slider", Config, Key) end
        function Tab:AddDropdown(Key, Config) return CreateElement(Container, "Dropdown", Config, Key) end
        function Tab:AddInput(Key, Config) return CreateElement(Container, "Input", Config, Key) end
        function Tab:AddColorpicker(Key, Config) return CreateElement(Container, "Colorpicker", Config, Key) end
        function Tab:AddKeybind(Key, Config) return CreateElement(Container, "Keybind", Config, Key) end

        function Tab:AddSection(Title)
            local SectionCont = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = Container,
            }, {
                 Creator.New("TextLabel", {
                    Text = Title,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    ThemeTag = { TextColor3 = "SubText" },
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 13
                 }),
                 Creator.New("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }),
            })
            
            local Items = {}
            function Items:AddParagraph(Config) return CreateElement(SectionCont, "Paragraph", Config, nil) end
            function Items:AddButton(Config) return CreateElement(SectionCont, "Button", Config, nil) end
            function Items:AddToggle(Key, Config) return CreateElement(SectionCont, "Toggle", Config, Key) end
            function Items:AddSlider(Key, Config) return CreateElement(SectionCont, "Slider", Config, Key) end
            function Items:AddDropdown(Key, Config) return CreateElement(SectionCont, "Dropdown", Config, Key) end
            function Items:AddInput(Key, Config) return CreateElement(SectionCont, "Input", Config, Key) end
            function Items:AddColorpicker(Key, Config) return CreateElement(SectionCont, "Colorpicker", Config, Key) end
            function Items:AddKeybind(Key, Config) return CreateElement(SectionCont, "Keybind", Config, Key) end
            
            Items.BuildInterfaceSection = function(self, Title) return Tab:AddSection(Title) end
            
            return Items
        end
        
        Tab.BuildInterfaceSection = Tab.AddSection
        Tab.BuildInterfaceCategory = function(self, Config) return Window:AddTab(Config) end
        
        return Tab
    end
    
    Connect(UserInputService.InputBegan, function(Input, Processed)
        if type(Helios.MinimizeKeybind) == "string" then
            if Input.KeyCode.Name == Helios.MinimizeKeybind or Input.KeyCode.Value == Helios.MinimizeKeybind then
                if Window and Window.Root then
                    Window.Root.Visible = not Window.Root.Visible
                end
            end
        elseif type(Helios.MinimizeKeybind) == "table" and Helios.MinimizeKeybind.Value then
            if Input.KeyCode.Name == Helios.MinimizeKeybind.Value or Input.KeyCode.Value == Helios.MinimizeKeybind.Value then
                if Window and Window.Root then
                    Window.Root.Visible = not Window.Root.Visible
                end
            end
        end
    end)

    Helios.Window = Window
    return Window
end

local MinimizerScreen

-- [CreateMinimizer Implementation]
function Helios:CreateMinimizer(Config)
    -- Creates a standalone GUI button to toggle the Window
    MinimizerScreen = Instance.new("ScreenGui")
    MinimizerScreen.Name = "HeliosMinimizer"
    MinimizerScreen.Parent = GetSafeParent()
    ProtectInstance(MinimizerScreen)
    
    local Button = Creator.New("ImageButton", {
        Name = "MinimizerBtn",
        Position = Config.Position or UDim2.new(0, 10, 0, 10),
        Size = Config.Size or UDim2.fromOffset(40, 40),
        Parent = MinimizerScreen,
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Image = Config.Icon or "rbxassetid://10709782430", -- Default home icon
        Active = true,
        Draggable = Config.Draggable or true
    }, {
         Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
         Creator.New("UIStroke", { Thickness = 2, Color = Color3.fromRGB(0, 255, 214) }) -- Accent Color
    })
    
    Connect(Button.MouseButton1Click, function()
        if Helios.Window and Helios.Window.Root then
            Helios.Window.Root.Visible = not Helios.Window.Root.Visible
        end
    end)
    
    return Button
end

function Helios:SetTheme(ThemeName)
    if Themes[ThemeName] then
        Helios.Theme = ThemeName
        Creator.UpdateTheme()
    end
end

function Helios:Notify(Config)
    local ParentFrame = Helios.Window and Helios.Window.Root and Helios.Window.Root.Parent or ScreenGui
    local NotifyFrame = Creator.New("Frame", {
        Size = UDim2.new(0, 260, 0, 60),
        Position = UDim2.new(1, 300, 0.9, 0), -- Off screen start
        Parent = ParentFrame,
        ThemeTag = { BackgroundColor3 = "AcrylicMain" },
        ZIndex = 1100
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Creator.New("UIStroke", { ThemeTag = { Color = "AcrylicBorder" }, Thickness = 1 }),
        Creator.New("TextLabel", {
            Text = Config.Title or "Notification",
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            ThemeTag = { TextColor3 = "Text" },
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Creator.New("TextLabel", {
            Text = Config.Content or "",
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 25),
            ThemeTag = { TextColor3 = "SubText" },
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
    })

    TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), { Position = UDim2.new(1, -280, 0.9, 0) }):Play()
    
    task.delay(Config.Duration or 3, function()
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), { Position = UDim2.new(1, 300, 0.9, 0) }):Play()
        task.wait(0.5)
        NotifyFrame:Destroy()
    end)
end

function Helios:Destroy()
    if ScreenGui then
        ScreenGui:Destroy()
    end
    
    if MinimizerScreen then
        MinimizerScreen:Destroy()
    end
    
    for _, connection in pairs(Creator.Signals) do
        if connection.Disconnect then
            connection:Disconnect()
        end
    end
    
    Creator.Signals = {}
    Helios.Window = nil
end
Helios.Unload = Helios.Destroy

return Helios
