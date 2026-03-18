local Helios = {
    Version = "1.2.0-FluentInspired",
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
    Slate = {
        Name = "Slate",
		Accent = Color3.fromRGB(255, 105, 180),
		AcrylicMain = Color3.fromRGB(40, 20, 25),
		AcrylicBorder = Color3.fromRGB(60, 30, 40),
		Background = Color3.fromRGB(30, 15, 20),
		TitleBarLine = Color3.fromRGB(80, 40, 50),
		Tab = Color3.fromRGB(100, 50, 60),
		TabHover = Color3.fromRGB(120, 60, 70),
		Element = Color3.fromRGB(40, 20, 25),
		ElementBorder = Color3.fromRGB(60, 30, 40),
		Divider = Color3.fromRGB(60, 30, 40),
		SliderRail = Color3.fromRGB(80, 40, 50),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(200, 160, 170),
		Hover = Color3.fromRGB(80, 40, 50),
    }
}
Helios.Themes = Themes

local Icons = {
    home = "rbxassetid://10709782430",
    flame = "rbxassetid://10709768128",
    move = "rbxassetid://10709791537",
    skull = "rbxassetid://10709819149",
    paintbrush = "rbxassetid://10709797382",
    ["settings-2"] = "rbxassetid://10734950309",
    settings = "rbxassetid://10734950309",
    default = "rbxassetid://10709782430"
}

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
    local Theme = Themes[Helios.Theme] or Themes.Slate
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

-- [Main GUI Logic]
-- Secure parent selection: Default to CoreGui with reference protection

function Helios:CreateWindow(Config)
    -- Check if window exists and is valid (not destroyed)
    if Helios.Window and Helios.Window.Root and Helios.Window.Root.Parent then
        Helios.Window.Root:Destroy() -- Force cleanup of old window if exists
        Helios.Window = nil
    end
    
    local Window = { Tabs = {} }
    
    -- [Anti-Cheat / Security]
    -- Try to use CoreGui (Secure), fallback to PlayerGui if failed
    local ProtectedParent = nil
    pcall(function()
        ProtectedParent = game:GetService("CoreGui")
        if cloneref then
            ProtectedParent = cloneref(ProtectedParent)
        end
    end)
    
    -- Fallback for environments where CoreGui is restricted
    if not ProtectedParent then
        ProtectedParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Randomize the name to avoid detection by name scanning
    local RandomName = ""
    for i = 1, math.random(12, 20) do
        RandomName = RandomName .. string.char(math.random(97, 122))
    end
    
    local Title = Config.Title or "Library"
    local SubTitle = Config.SubTitle or ""
    local Size = Config.Size or UDim2.fromOffset(580, 460)
    
    -- Main Window Frame
    local Root = Creator.New("Frame", {
        Name = RandomName, -- Randomized Name
        Size = Size,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ProtectedParent,
        ThemeTag = { BackgroundColor3 = "AcrylicMain" }
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Creator.New("UIStroke", { ThemeTag = { Color = "AcrylicBorder" }, Thickness = 1 }),
        Creator.New("UIScale", { Scale = 0.8 })
    })
    
    -- Window Open Animation
    TweenService:Create(Root.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    
    -- Top Bar (Drag Area)
    local TopBar = Creator.New("Frame", {
         Size = UDim2.new(1, 0, 0, 40),
         BackgroundTransparency = 1,
         Parent = Root
    }, {
        Creator.New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        }),
        Creator.New("TextLabel", {
            Text = Title,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            ThemeTag = { TextColor3 = "Text" },
            TextSize = 16,
            LayoutOrder = 1
        }),
        Creator.New("TextLabel", {
            Text = SubTitle,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Center,
            ThemeTag = { TextColor3 = "SubText" },
            TextSize = 14,
            LayoutOrder = 2
        })
    })

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
    
    Window.Root = Root
    
    function Window:SelectTab(TabInfo)
        if type(TabInfo) == "number" and Window.Tabs[TabInfo] then
            Window.Tabs[TabInfo]:Select()
        elseif type(TabInfo) == "table" and TabInfo.Select then
            TabInfo:Select()
        end
    end

    function Window:AddTab(Config)
        local TabTitle = Config.Title or "Tab"
        local IconID = Icons[Config.Icon] or Icons.default
        
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
                 Size = UDim2.new(1, -30, 1, 0),
                 Position = UDim2.new(0, 40, 0, 0),
                 ThemeTag = { TextColor3 = "Text" },
                 TextXAlignment = Enum.TextXAlignment.Left,
                 Font = Enum.Font.GothamMedium,
                 TextSize = 14
            }),
            Creator.New("ImageLabel", {
                 Image = IconID,
                 Size = UDim2.new(0, 20, 0, 20),
                 Position = UDim2.new(0, 10, 0.5, -10),
                 ThemeTag = { ImageColor3 = "Text" }
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

        local Tab = { Container = Container, Button = TabButton, Selected = false }
        
        local function Select()
             for _, T in pairs(Window.Tabs) do 
                 T.Container.Visible = false 
                 TweenService:Create(T.Button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                 T.Button.TextLabel.TextColor3 = Themes.Slate.SubText
                 T.Button.ImageLabel.ImageColor3 = Themes.Slate.SubText
                 T.Selected = false
             end
             Container.Visible = true
             Tab.Selected = true
             TweenService:Create(TabButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.92 }):Play() -- Subtle highlight
             TabButton.TextLabel.TextColor3 = Themes.Slate.Text
             TabButton.ImageLabel.ImageColor3 = Themes.Slate.Text
        end

        Connect(TabButton.MouseEnter, function()
            if not Tab.Selected then
                TweenService:Create(TabButton, TweenInfo.new(0.2), { BackgroundTransparency = 0.95 }):Play()
            end
        end)
        Connect(TabButton.MouseLeave, function()
            if not Tab.Selected then
                TweenService:Create(TabButton, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
            end
        end)
        
        Connect(TabButton.MouseButton1Click, Select)
        
        -- Default selection
        if #Window.Tabs == 0 then 
            Container.Visible = true 
            Tab.Selected = true
            TweenService:Create(TabButton, TweenInfo.new(0), { BackgroundTransparency = 0.92 }):Play()
            TabButton.TextLabel.TextColor3 = Themes.Slate.Text
            TabButton.ImageLabel.ImageColor3 = Themes.Slate.Text
        else
            TabButton.TextLabel.TextColor3 = Themes.Slate.SubText
            TabButton.ImageLabel.ImageColor3 = Themes.Slate.SubText
        end
        
        function Tab:Select()
            Select()
        end
        table.insert(Window.Tabs, Tab)

        -- [Element Creator Helper]
        local function CreateElement(Parent, Type, EConfig, Key)
            if Type == "Button" then
                 local BtnFrame = Creator.New("TextButton", {
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" },
                    AutoButtonColor = false
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                    Creator.New("TextLabel", {
                        Text = EConfig.Title or "Button",
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = { TextColor3 = "Text" },
                        Font = Enum.Font.Gotham,
                    })
                })
                
                Connect(BtnFrame.MouseEnter, function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.2), { BackgroundTransparency = 0.2 }):Play()
                end)
                Connect(BtnFrame.MouseLeave, function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
                    TweenService:Create(BtnFrame.UIStroke, TweenInfo.new(0.2), { Thickness = 1 }):Play()
                end)
                Connect(BtnFrame.MouseButton1Down, function()
                    TweenService:Create(BtnFrame.UIStroke, TweenInfo.new(0.1), { Thickness = 2 }):Play()
                end)
                Connect(BtnFrame.MouseButton1Up, function()
                    TweenService:Create(BtnFrame.UIStroke, TweenInfo.new(0.1), { Thickness = 1 }):Play()
                end)
                
                Connect(BtnFrame.MouseButton1Click, function() 
                    if type(EConfig.Callback) == "function" then EConfig.Callback() end 
                end)
                return BtnFrame

            elseif Type == "Toggle" then
                local Toggled = EConfig.Default or false
                local Btn = Creator.New("TextButton", {
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 36),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" },
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                    Creator.New("TextLabel", {
                        Text = (EConfig.Title or Key),
                        Size = UDim2.new(1, -50, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        ThemeTag = { TextColor3 = "Text" },
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    })
                })
                
                -- Toggle Switch UI
                local SwitchBg = Creator.New("Frame", {
                     Size = UDim2.new(0, 36, 0, 18),
                     Position = UDim2.new(1, -46, 0.5, -9),
                     Parent = Btn,
                     BackgroundColor3 = Toggled and Themes.Slate.Accent or Color3.fromRGB(60,60,60),
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                
                local SwitchKnob = Creator.New("Frame", {
                     Size = UDim2.new(0, 14, 0, 14),
                     Position = UDim2.new(0, Toggled and 20 or 2, 0.5, -7),
                     Parent = SwitchBg,
                     BackgroundColor3 = Color3.fromRGB(255,255,255)
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                
                local function Update()
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), { BackgroundColor3 = Toggled and Themes.Slate.Accent or Color3.fromRGB(60,60,60) }):Play()
                    TweenService:Create(SwitchKnob, TweenInfo.new(0.2), { Position = UDim2.new(0, Toggled and 20 or 2, 0.5, -7) }):Play()
                    if type(EConfig.Callback) == "function" then EConfig.Callback(Toggled) end
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
                     TweenService:Create(Fill, TweenInfo.new(0.1), { Size = UDim2.fromScale(Scale, 1) }):Play()
                     Frame.ValueLabel.Text = tostring(Value)
                     if type(EConfig.Callback) == "function" then EConfig.Callback(Value) end
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
                        v = tonumber(v) or v
                        Value = v; 
                        TweenService:Create(Fill, TweenInfo.new(0.2), { Size = UDim2.fromScale(math.clamp((Value - Min)/(Max - Min), 0, 1), 1) }):Play()
                        Frame.ValueLabel.Text = tostring(Value)
                        if type(EConfig.Callback) == "function" then EConfig.Callback(Value) end
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
                                  if type(EConfig.Callback) == "function" then EConfig.Callback(Value) end
                             else
                                  Value = Val
                                  ValLabel.Text = tostring(Value)
                                  Expanded = false
                                  TweenService:Create(Frame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 40) }):Play()
                                  if type(EConfig.Callback) == "function" then EConfig.Callback(Value) end
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
                    Multi = Multi,
                    Type = "Dropdown",
                    SetValue = function(self, v)
                        Value = v
                        if v == nil then
                            ValLabel.Text = "None"
                        else
                            ValLabel.Text = (type(v) == "table" and table.concat(v, ", ") or tostring(v))
                        end
                        if type(EConfig.Callback) == "function" then EConfig.Callback(v) end
                    end,
                    SetValues = function(self, newValues)
                        Values = newValues
                        RefreshList()
                    end
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
                
                Connect(TextBox.FocusLost, function() if type(EConfig.Callback) == "function" then EConfig.Callback(TextBox.Text) end end)
                
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
                    SetValueRGB = function(self, rgb) 
                        Color = rgb
                        TweenService:Create(Preview, TweenInfo.new(0.2), { BackgroundColor3 = rgb }):Play()
                    end,
                    Type = "Colorpicker"
                }
                Helios.Options[Key] = ColorObj
                return ColorObj
                
            elseif Type == "Keybind" then
                 local Binding = EConfig.Default or Enum.KeyCode.Unknown
                 local Frame = Creator.New("TextButton", {
                     Size = UDim2.new(1, 0, 0, 40),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" },
                     Text = "",
                 }, { 
                     Creator.New("UICorner", { CornerRadius = UDim.new(0,6) }),
                     Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                 })
                 
                 Creator.New("TextLabel", {
                     Text = (EConfig.Title or Key),
                     Size = UDim2.new(1, -60, 1, 0),
                     Position = UDim2.new(0,10,0,0),
                     ThemeTag = { TextColor3 = "Text" },
                     Font = Enum.Font.Gotham,
                     TextXAlignment = Enum.TextXAlignment.Left,
                     Parent = Frame
                 })

                 local KeyLabel = Creator.New("TextLabel", {
                     Text = "["..Binding.Name.."]",
                     Size = UDim2.new(0, 60, 1, 0),
                     Position = UDim2.new(1,-70,0,0),
                     ThemeTag = { TextColor3 = "SubText" },
                     Font = Enum.Font.Gotham,
                     TextXAlignment = Enum.TextXAlignment.Right,
                     Parent = Frame
                 })
                 
                 local BindingMode = false
                 local KeybindObj = { 
                     Value = Binding, 
                     Type = "Keybind",
                     SetValue = function(self, key, mode)
                         if typeof(key) == "string" then key = Enum.KeyCode[key] or key end
                         self.Value = key
                         if typeof(key) == "EnumItem" then
                             KeyLabel.Text = "["..key.Name.."]"
                         else
                             KeyLabel.Text = "["..tostring(key).."]"
                         end
                         if type(EConfig.Callback) == "function" then EConfig.Callback(key) end
                     end
                 }
                 
                 Connect(Frame.MouseButton1Click, function()
                     BindingMode = true
                     KeyLabel.Text = "[...]"
                 end)
                 
                 Connect(UserInputService.InputBegan, function(Input)
                     if BindingMode and Input.UserInputType == Enum.UserInputType.Keyboard then
                         BindingMode = false
                         KeybindObj:SetValue(Input.KeyCode)
                     end
                 end)
                 Helios.Options[Key] = KeybindObj
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
                    ThemeTag = { TextColor3 = "SubText" }, -- Section headers often subtle
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
            return Items
        end
        return Tab
    end
    
    Helios.Window = Window
    Helios.MinimizeKeybind = Enum.KeyCode.RightControl
    
    Connect(UserInputService.InputBegan, function(Input, Processed)
        if type(Helios.MinimizeKeybind) == "string" then
            local s, k = pcall(function() return Enum.KeyCode[Helios.MinimizeKeybind] end)
            if s and k then Helios.MinimizeKeybind = k end
        end
        if not Processed and Input.KeyCode == Helios.MinimizeKeybind then
            if Helios.Window and Helios.Window.Root then
                if Helios.Window.Root.Visible then
                    TweenService:Create(Helios.Window.Root.UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.8 }):Play()
                    task.wait(0.3)
                    Helios.Window.Root.Visible = false
                else
                    Helios.Window.Root.Visible = true
                    TweenService:Create(Helios.Window.Root.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
                end
            end
        end
    end)
    
    return Window
end

-- [CreateMinimizer Implementation]
function Helios:CreateMinimizer(Config)
    -- Protect Parent Reference
    local ProtectedParent = game:GetService("CoreGui")
    if cloneref then ProtectedParent = cloneref(ProtectedParent) end

    -- Creates a standalone GUI button to toggle the Window
    local MinimizerScreen = Instance.new("ScreenGui")
    MinimizerScreen.Name = string.char(math.random(97, 122)) .. string.char(math.random(97, 122)) .. string.char(math.random(97, 122)) -- Random Name
    MinimizerScreen.Parent = ProtectedParent
    
    local Button = Creator.New("ImageButton", {
        Name = "Btn",
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
            if Helios.Window.Root.Visible then
                TweenService:Create(Helios.Window.Root.UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.8 }):Play()
                task.wait(0.3)
                Helios.Window.Root.Visible = false
            else
                Helios.Window.Root.Visible = true
                TweenService:Create(Helios.Window.Root.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            end
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

function Helios:ToggleTransparency(Value)
    if Helios.Window and Helios.Window.Root then
        TweenService:Create(Helios.Window.Root, TweenInfo.new(0.2), { BackgroundTransparency = Value and 0.2 or 0 }):Play()
    end
end

function Helios:ToggleAcrylic(Value)
    -- Stub for acrylic blur, we can just alter transparency as fallback
    Helios:ToggleTransparency(Value)
end

function Helios:Notify(Config)
    -- Find a valid parent
    local ParentFrame = nil
    if Helios.Window and Helios.Window.Root and Helios.Window.Root.Parent then
        ParentFrame = Helios.Window.Root.Parent
    else
        ParentFrame = game:GetService("CoreGui")
        if cloneref then ParentFrame = cloneref(ParentFrame) end
    end

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

setmetatable(Helios, { __metatable = "Helios Library" })
return Helios
