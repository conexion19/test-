local Helios = {
	Version = "1.1.0",
}

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local OpenFrames = {}
local Options = {}
Helios.Options = Options
Helios.Theme = "Slate"

local Themes = {
	Slate = {
		Name = "Slate",
		Accent = Color3.fromRGB(0, 85, 255),
		AcrylicMain = Color3.fromRGB(40, 20, 25),
		AcrylicBorder = Color3.fromRGB(60, 30, 40),
		TitleBarLine = Color3.fromRGB(80, 40, 50),
		Tab = Color3.fromRGB(100, 50, 60),
		Element = Color3.fromRGB(40, 20, 25),
		ElementBorder = Color3.fromRGB(60, 30, 40),
		ToggleToggled = Color3.fromRGB(255, 255, 255),
		SliderRail = Color3.fromRGB(80, 40, 50),
		DropdownOption = Color3.fromRGB(80, 40, 50),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(200, 160, 170),
	},
	Dark = {
		Name = "Dark",
		Accent = Color3.fromRGB(96, 205, 255),
		AcrylicMain = Color3.fromRGB(30, 30, 30),
		AcrylicBorder = Color3.fromRGB(60, 60, 60),
		TitleBarLine = Color3.fromRGB(75, 75, 75),
		Tab = Color3.fromRGB(45, 45, 45),
		Element = Color3.fromRGB(45, 45, 45),
		ElementBorder = Color3.fromRGB(35, 35, 35),
		ToggleToggled = Color3.fromRGB(42, 42, 42),
		SliderRail = Color3.fromRGB(120, 120, 120),
		DropdownOption = Color3.fromRGB(60, 60, 60),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
	},
}

Helios.Themes = Themes

local Creator = {
	Registry = {},
	Signals = {},
	DefaultProperties = {
		ScreenGui = { ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
		Frame = { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 },
		ScrollingFrame = { BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ScrollBarThickness = 4 },
		TextLabel = { BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1, 1, 1) },
		TextButton = { AutoButtonColor = false, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1, 1, 1) },
		TextBox = { ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1, 1, 1) },
	},
}

local Flipper = {}
do 
    local Linear = {}
    Linear.__index = Linear
    function Linear.new(target, options)
        return setmetatable({_targetValue = target, _velocity = (options or {}).velocity or 1}, Linear)
    end
    function Linear:step(state, dt)
        local pos, goal = state.value, self._targetValue
        local dPos = dt * self._velocity
        local complete = dPos >= math.abs(goal - pos)
        return { complete = complete, value = complete and goal or pos + dPos * (goal > pos and 1 or -1) }
    end

    local Spring = {}
    Spring.__index = Spring
    function Spring.new(target, options)
        return setmetatable({_targetValue = target, _freq = (options or {}).frequency or 4, _damp = (options or {}).dampingRatio or 1}, Spring)
    end
    function Spring:step(state, dt)
        local d, f, g = self._damp, self._freq * 2 * math.pi, self._targetValue
        local p0, v0 = state.value, state.velocity or 0
        local offset = p0 - g
        local decay = math.exp(-d * f * dt)
        local p1, v1
        if d == 1 then
            p1 = (offset * (1 + f * dt) + v0 * dt) * decay + g
            v1 = (v0 * (1 - f * dt) - offset * (f * f * dt)) * decay
        elseif d < 1 then
            local c = math.sqrt(1 - d * d)
            local i, j = math.cos(f * c * dt), math.sin(f * c * dt)
            p1 = (offset * (i + d * j / c) + v0 * j / (f * c)) * decay + g
            v1 = (v0 * (i - j * d / c) - offset * (j * f / c)) * decay
        else
            local c = math.sqrt(d * d - 1)
            local r1, r2 = -f * (d - c), -f * (d + c)
            local co2 = (v0 - offset * r1) / (2 * f * c)
            local co1 = offset - co2
            local e1, e2 = co1 * math.exp(r1 * dt), co2 * math.exp(r2 * dt)
            p1 = e1 + e2 + g
            v1 = e1 * r1 + e2 * r2
        end
        local complete = math.abs(v1) < 0.001 and math.abs(p1 - g) < 0.001
        return { complete = complete, value = complete and g or p1, velocity = v1 }
    end

    local Instant = {}
    Instant.__index = Instant
    function Instant.new(target) return setmetatable({_targetValue = target}, Instant) end
    function Instant:step() return { complete = true, value = self._targetValue } end

    local SingleMotor = {}
    SingleMotor.__index = SingleMotor
    function SingleMotor.new(initial)
        local self = setmetatable({_goal = nil, _state = {complete = true, value = initial}, _onStep = Instance.new("BindableEvent")}, SingleMotor)
        return self
    end
    function SingleMotor:onStep(cb) return self._onStep.Event:Connect(cb) end
    function SingleMotor:setGoal(goal)
        self._goal = goal
        self._state.complete = false
        if not self._conn then
            self._conn = RunService.RenderStepped:Connect(function(dt)
                if self._state.complete then return self._conn:Disconnect() end
                self._state = self._goal:step(self._state, dt)
                self._onStep:Fire(self._state.value)
                if self._state.complete then self._conn:Disconnect(); self._conn = nil end
            end)
        end
    end

    Flipper.SingleMotor = SingleMotor
    Flipper.Linear = Linear
    Flipper.Spring = Spring
    Flipper.Instant = Instant
end

-- [Creator Implementation]
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

-- [Main GUI]
local ScreenGui = Creator.New("ScreenGui", {
    Name = "HeliosUI",
    Parent = RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui") or CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

function Helios:CreateWindow(Config)
    if Helios.Window then return Helios.Window end
    
    local Window = { Tabs = {} }
    local Title = Config.Title or "Helios"
    local Size = Config.Size or UDim2.fromOffset(580, 460)
    
    local Root = Creator.New("Frame", {
        Name = "Root",
        Size = Size,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui,
        ThemeTag = { BackgroundColor3 = "AcrylicMain" }
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Creator.New("UIStroke", { ThemeTag = { Color = "AcrylicBorder" }, Transparency = 0.5 }),
    })
    
    -- Dragging
    local Dragging, DragInput, DragStart, StartPos
    Connect(Root.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Root.Position
            Input.Changed:Connect(function() if Input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    Connect(Root.InputChanged, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
    end)
    Connect(UserInputService.InputChanged, function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Root.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    
    local TabHolder = Creator.New("Frame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundTransparency = 1,
        Parent = Root,
    }, {
        Creator.New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
        Creator.New("UIPadding", { PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 10) })
    })
    
    local ContainerHolder = Creator.New("Frame", {
        Name = "ContainerHolder",
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.fromOffset(160, 0),
        BackgroundTransparency = 1,
        Parent = Root,
    })
    
    Window.Root = Root
    
    function Window:AddTab(Config)
        local TabTitle = Config.Title or "Tab"
        
        local TabButton = Creator.New("TextButton", {
            Text = TabTitle,
            Size = UDim2.new(1, -10, 0, 30),
            Parent = TabHolder,
            ThemeTag = { BackgroundColor3 = "Tab", TextColor3 = "Text" }
        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }) })
        
        local Container = Creator.New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = ContainerHolder,
            Visible = false,
        }, {
            Creator.New("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }),
            Creator.New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 5) })
        })

        if #Window.Tabs == 0 then Container.Visible = true end
        
        Connect(TabButton.MouseButton1Click, function()
            for _, T in pairs(Window.Tabs) do T.Container.Visible = false end
            Container.Visible = true
        end)
        
        local Tab = { Container = Container, Button = TabButton }
        table.insert(Window.Tabs, Tab)

        -- [Element Creator Helper]
        local function CreateElement(Parent, Type, EConfig, Key)
            if Type == "Button" then
                 local Btn = Creator.New("TextButton", {
                    Text = EConfig.Title or "Button",
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" }
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }) })
                Connect(Btn.MouseButton1Click, EConfig.Callback or function() end)
                return Btn

            elseif Type == "Toggle" then
                local Toggled = EConfig.Default or false
                local Btn = Creator.New("TextButton", {
                    Text = (EConfig.Title or Key),
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10) })
                })
                
                local Status = Creator.New("Frame", {
                     Size = UDim2.new(0, 20, 0, 20),
                     Position = UDim2.new(1, -30, 0.5, -10),
                     Parent = Btn,
                     BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4) }) })
                
                local function Update()
                    Status.BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    if EConfig.Callback then EConfig.Callback(Toggled) end
                end
                
                Connect(Btn.MouseButton1Click, function()
                    Toggled = not Toggled
                    Update()
                end)
                
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
                     Size = UDim2.new(1, 0, 0, 40),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" }
                 }, {
                     Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                     Creator.New("TextLabel", {
                         Text = (EConfig.Title or Key) .. ": " .. Value,
                         Size = UDim2.new(1, -10, 0, 20),
                         Position = UDim2.fromOffset(5, 0),
                         BackgroundTransparency = 1,
                         ThemeTag = { TextColor3 = "Text" },
                         TextXAlignment = Enum.TextXAlignment.Left
                     })
                 })
                 
                 local SliderBar = Creator.New("TextButton", {
                     Text = "",
                     Size = UDim2.new(1, -20, 0, 6),
                     Position = UDim2.new(0, 10, 0, 25),
                     Parent = Frame,
                     ThemeTag = { BackgroundColor3 = "SliderRail" }
                 }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 3) }) })
                 
                 local Fill = Creator.New("Frame", {
                     Size = UDim2.fromScale((Value - Min)/(Max - Min), 1),
                     ThemeTag = { BackgroundColor3 = "Accent" },
                     Parent = SliderBar
                 }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 3) }) })
                 
                 local function Update(Input)
                     local Scale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                     local NewValue = Min + ((Max - Min) * Scale)
                     if Rounding == 0 then NewValue = math.floor(NewValue + 0.5)
                     else NewValue = math.floor(NewValue * (10^Rounding) + 0.5) / (10^Rounding) end
                     Value = NewValue
                     Fill.Size = UDim2.fromScale(Scale, 1)
                     Frame.TextLabel.Text = (EConfig.Title or Key) .. ": " .. Value
                     if EConfig.Callback then EConfig.Callback(Value) end
                 end
                 
                 local Dragging = false
                 Connect(SliderBar.InputBegan, function(Input)
                     if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                         Dragging = true; Update(Input)
                     end
                 end)
                 Connect(UserInputService.InputEnded, function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                 Connect(UserInputService.InputChanged, function(Input) if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end end)

                 local SliderObj = { 
                     Value = Value, 
                     SetValue = function(self, v) 
                        Value = v; Fill.Size = UDim2.fromScale(math.clamp((Value - Min)/(Max - Min), 0, 1), 1)
                        Frame.TextLabel.Text = (EConfig.Title or Key) .. ": " .. Value
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
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" },
                    ClipsDescendants = true
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                
                local Button = Creator.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = (EConfig.Title or Key) .. ": " .. (type(Value) == "table" and table.concat(Value, ", ") or tostring(Value)),
                    ThemeTag = { TextColor3 = "Text" }
                }, { Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10)})})
                
                local List = Creator.New("Frame", {
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = Frame
                }, { Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }) })
                
                local function RefreshList()
                    for _, c in pairs(List:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, Val in pairs(Values) do
                        local Item = Creator.New("TextButton", {
                             Text = Val,
                             Size = UDim2.new(1, 0, 0, 25),
                             Parent = List,
                             ThemeTag = { BackgroundColor3 = "DropdownOption", TextColor3 = "Text" }
                        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                        Connect(Item.MouseButton1Click, function()
                             if Multi then
                                  if table.find(Value, Val) then for idx, v in pairs(Value) do if v == Val then table.remove(Value, idx) end end
                                  else table.insert(Value, Val) end
                                  Button.Text = (EConfig.Title or Key) .. ": " .. table.concat(Value, ", ")
                                  if EConfig.Callback then EConfig.Callback(Value) end
                             else
                                  Value = Val
                                  Button.Text = (EConfig.Title or Key) .. ": " .. tostring(Value)
                                  Expanded = false
                                  Frame.Size = UDim2.new(1, 0, 0, 35)
                                  if EConfig.Callback then EConfig.Callback(Value) end
                             end
                        end)
                    end
                    if Expanded then Frame.Size = UDim2.new(1, 0, 0, (#Values * 25) + 40) end
                end
                
                Connect(Button.MouseButton1Click, function()
                    Expanded = not Expanded
                    if Expanded then RefreshList() else Frame.Size = UDim2.new(1, 0, 0, 35) end
                end)
                
                local DropdownObj = {
                    Value = Value,
                    SetValues = function(self, NewVal) Values = NewVal; if Expanded then RefreshList() end end,
                    SetValue = function(self, V) Value = V; Button.Text = (EConfig.Title or Key) .. ": " .. (type(Value) == "table" and table.concat(Value, ", ") or tostring(Value)) end,
                    Type = "Dropdown"
                }
                Helios.Options[Key] = DropdownObj
                return DropdownObj

            elseif Type == "Input" then
                local Frame = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" } 
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4)}) })
                
                Creator.New("TextLabel", {
                    Text = EConfig.Title or Key,
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 5, 0, 0),
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local TextBox = Creator.New("TextBox", {
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 5, 0, 20),
                    BackgroundTransparency = 1,
                    Text = EConfig.Default or "",
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Connect(TextBox.FocusLost, function()
                    if EConfig.Callback then EConfig.Callback(TextBox.Text) end
                end)
                
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
                     Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                     Creator.New("UIPadding", { PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10) }),
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
                 })
                 
                 Creator.New("TextLabel", {
                     Text = PConfig.Content or "",
                     Size = UDim2.new(1, 0, 0, 0),
                     AutomaticSize = Enum.AutomaticSize.Y,
                     BackgroundTransparency = 1,
                     Parent = Wrapper,
                     ThemeTag = { TextColor3 = "SubText" },
                     TextXAlignment = Enum.TextXAlignment.Left,
                     TextWrapped = true
                 })
                 return Wrapper
                 
            elseif Type == "Colorpicker" then
                -- Simplified Colorpicker
                local Color = EConfig.Default or Color3.fromRGB(255, 255, 255)
                local Frame = Creator.New("Frame", {
                     Size = UDim2.new(1, 0, 0, 40),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" }
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                
                Creator.New("TextLabel", {
                    Text = (EConfig.Title or Key),
                    Size = UDim2.new(1, -50, 0, 30),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Preview = Creator.New("Frame", {
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -40, 0, 5),
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
                 local Binding = EConfig.Default or Enum.KeyCode.Unknown
                 local Frame = Creator.New("TextButton", {
                     Size = UDim2.new(1, 0, 0, 30),
                     Parent = Parent,
                     ThemeTag = { BackgroundColor3 = "Element" },
                     Text = (EConfig.Title or Key) .. " ["..Binding.Name.."]",
                     ThemeTag = { TextColor3 = "Text" }
                 }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                 
                 local KeybindObj = { Value = Binding, Type = "Keybind" }
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
            local Section = Creator.New("Frame", {
                Size = UDim2.new(1, -10, 0, 30),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = Container,
            }, {
                 Creator.New("TextLabel", {
                    Text = Title,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    ThemeTag = { TextColor3 = "Text" },
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                 }),
                 Creator.New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
            })
            
            local Items = {}
            function Items:AddParagraph(Config) return CreateElement(Section, "Paragraph", Config, nil) end
            function Items:AddButton(Config) return CreateElement(Section, "Button", Config, nil) end
            function Items:AddToggle(Key, Config) return CreateElement(Section, "Toggle", Config, Key) end
            function Items:AddSlider(Key, Config) return CreateElement(Section, "Slider", Config, Key) end
            function Items:AddDropdown(Key, Config) return CreateElement(Section, "Dropdown", Config, Key) end
            function Items:AddInput(Key, Config) return CreateElement(Section, "Input", Config, Key) end
            function Items:AddColorpicker(Key, Config) return CreateElement(Section, "Colorpicker", Config, Key) end
            function Items:AddKeybind(Key, Config) return CreateElement(Section, "Keybind", Config, Key) end
            return Items
        end
        return Tab
    end
    
    Helios.Window = Window
    return Window
end

function Helios:SetTheme(ThemeName)
    if Themes[ThemeName] then
        Helios.Theme = ThemeName
        Creator.UpdateTheme()
    end
end

function Helios:Notify(Config)
    -- Mock notification
    print("Notification:", Config.Title, Config.Content)
end

return Helios
