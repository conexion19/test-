local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Helios = {
	Version = "1.1.0",
	OpenFrames = {},
	Options = {},
	Themes = {},
	Window = nil,
	WindowFrame = nil,
	Unloaded = false,
	Theme = "Slate",
	UseAcrylic = false,
	Acrylic = false,
	Transparency = false,
	MinimizeKey = Enum.KeyCode.LeftControl,
	Loaded = false,
}

local Themes = {
	Slate = {
		Name = "Slate",
		Accent = Color3.fromRGB(0, 85, 255),
		AcrylicMain = Color3.fromRGB(40, 20, 25),
		AcrylicBorder = Color3.fromRGB(60, 30, 40),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(30, 15, 20), Color3.fromRGB(40, 20, 25)),
		AcrylicNoise = 0.95,
		TitleBarLine = Color3.fromRGB(80, 40, 50),
		Tab = Color3.fromRGB(100, 50, 60),
		Element = Color3.fromRGB(40, 20, 25),
		ElementBorder = Color3.fromRGB(60, 30, 40),
		InElementBorder = Color3.fromRGB(60, 30, 40),
		ElementTransparency = 0.92,
		ToggleSlider = Color3.fromRGB(80, 40, 50),
		ToggleToggled = Color3.fromRGB(255, 255, 255),
		SliderRail = Color3.fromRGB(80, 40, 50),
		DropdownFrame = Color3.fromRGB(80, 40, 50),
		DropdownHolder = Color3.fromRGB(40, 20, 25),
		DropdownBorder = Color3.fromRGB(60, 30, 40),
		DropdownOption = Color3.fromRGB(80, 40, 50),
		Keybind = Color3.fromRGB(80, 40, 50),
		Input = Color3.fromRGB(80, 40, 50),
		InputFocused = Color3.fromRGB(30, 15, 20),
		InputIndicator = Color3.fromRGB(80, 40, 50),
		Dialog = Color3.fromRGB(40, 20, 25),
		DialogHolder = Color3.fromRGB(40, 20, 25),
		DialogHolderLine = Color3.fromRGB(60, 30, 40),
		DialogButton = Color3.fromRGB(50, 25, 30),
		DialogButtonBorder = Color3.fromRGB(60, 30, 40),
		DialogBorder = Color3.fromRGB(60, 30, 40),
		DialogInput = Color3.fromRGB(40, 20, 25),
		DialogInputLine = Color3.fromRGB(100, 50, 60),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(200, 160, 170),
		Hover = Color3.fromRGB(80, 40, 50),
		HoverChange = 0.03,
	},
	Dark = {
		Name = "Dark",
		Accent = Color3.fromRGB(96, 205, 255),
		AcrylicMain = Color3.fromRGB(60, 60, 60),
		AcrylicBorder = Color3.fromRGB(90, 90, 90),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(40, 40, 40)),
		AcrylicNoise = 0.9,
		TitleBarLine = Color3.fromRGB(75, 75, 75),
		Tab = Color3.fromRGB(120, 120, 120),
		Element = Color3.fromRGB(120, 120, 120),
		ElementBorder = Color3.fromRGB(35, 35, 35),
		InElementBorder = Color3.fromRGB(90, 90, 90),
		ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(120, 120, 120),
		ToggleToggled = Color3.fromRGB(42, 42, 42),
		SliderRail = Color3.fromRGB(120, 120, 120),
		DropdownFrame = Color3.fromRGB(160, 160, 160),
		DropdownHolder = Color3.fromRGB(45, 45, 45),
		DropdownBorder = Color3.fromRGB(35, 35, 35),
		DropdownOption = Color3.fromRGB(120, 120, 120),
		Keybind = Color3.fromRGB(120, 120, 120),
		Input = Color3.fromRGB(160, 160, 160),
		InputFocused = Color3.fromRGB(10, 10, 10),
		InputIndicator = Color3.fromRGB(150, 150, 150),
		Dialog = Color3.fromRGB(45, 45, 45),
		DialogHolder = Color3.fromRGB(35, 35, 35),
		DialogHolderLine = Color3.fromRGB(30, 30, 30),
		DialogButton = Color3.fromRGB(45, 45, 45),
		DialogButtonBorder = Color3.fromRGB(80, 80, 80),
		DialogBorder = Color3.fromRGB(70, 70, 70),
		DialogInput = Color3.fromRGB(55, 55, 55),
		DialogInputLine = Color3.fromRGB(160, 160, 160),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(120, 120, 120),
		HoverChange = 0.07,
	},
}

Helios.Themes = {}
for k, v in pairs(Themes) do table.insert(Helios.Themes, k) end

local Creator = {
	Registry = {},
	Signals = {},
	TransparencyMotors = {},
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			TextSize = 14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
		},
		CanvasGroup = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
	},
}

-- [Flipper Implementation - Compact]
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

-- [Creator Implementation - Compact]
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

function Creator.SpringMotor(Initial, Instance, Prop)
    local Motor = Flipper.SingleMotor.new(Initial)
    Motor:onStep(function(value) Instance[Prop] = value end)
    return Motor, function(v) Motor:setGoal(Flipper.Spring.new(v, {frequency = 8})) end
end

-- [Library Signals]
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
    ResetOnSpawn = false,
})
Helios.GUI = ScreenGui

-- [Window Component]
function Helios:CreateWindow(Config)
    if Helios.Window then return Helios.Window end
    
    local Window = {
        Tabs = {},
    }
    
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
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    Connect(Root.InputChanged, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)
    Connect(UserInputService.InputChanged, function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Root.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    
    -- Structure
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
    Window.TabHolder = TabHolder
    Window.ContainerHolder = ContainerHolder
    
    function Window:AddTab(Config)
        local Title = Config.Title or "Tab"
        local Icon = Config.Icon or ""
        
        local TabButton = Creator.New("TextButton", {
            Text = Title,
            Size = UDim2.new(1, -10, 0, 30),
            Parent = TabHolder,
            ThemeTag = { BackgroundColor3 = "Tab", TextColor3 = "Text" }
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) })
        })
        
        local Container = Creator.New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = ContainerHolder,
            Visible = false,
            ScrollBarThickness = 2,
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
            
            function Items:AddButton(Config)
                local Btn = Creator.New("TextButton", {
                    Text = Config.Title or "Button",
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Section,
                    ThemeTag = { BackgroundColor3 = "Element", TextColor3 = "Text" }
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }) })
                Connect(Btn.MouseButton1Click, Config.Callback or function() end)
            end
            
            function Items:AddToggle(Key, Config)
                local Toggled = Config.Default or false
                local Btn = Creator.New("TextButton", {
                    Text = (Config.Title or Key),
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Section,
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
                    if Config.Callback then Config.Callback(Toggled) end
                end
                
                Connect(Btn.MouseButton1Click, function()
                    Toggled = not Toggled
                    Update()
                end)
                
                local Toggle = { 
                    Value = Toggled, 
                    SetValue = function(self, v) 
                        Toggled = v; 
                        Update() 
                    end,
                    Type = "Toggle"
                }
                Helios.Options[Key] = Toggle
                return Toggle
            end

            function Items:AddSlider(Key, Config)
                 local Min, Max = Config.Min or 0, Config.Max or 100
                 local Default = Config.Default or Min
                 local Value = Default
                 local Rounding = Config.Rounding or 0

                 local Frame = Creator.New("Frame", {
                     Size = UDim2.new(1, 0, 0, 40),
                     Parent = Section,
                     ThemeTag = { BackgroundColor3 = "Element" }
                 }, {
                     Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                     Creator.New("TextLabel", {
                         Text = (Config.Title or Key) .. ": " .. Value,
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
                     if Rounding == 0 then
                        NewValue = math.floor(NewValue + 0.5)
                     else
                        NewValue = math.floor(NewValue * (10^Rounding) + 0.5) / (10^Rounding)
                     end
                     Value = NewValue
                     Fill.Size = UDim2.fromScale(Scale, 1)
                     Frame.TextLabel.Text = (Config.Title or Key) .. ": " .. Value
                     if Config.Callback then Config.Callback(Value) end
                 end
                 
                 local Dragging = false
                 Connect(SliderBar.InputBegan, function(Input)
                     if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                         Dragging = true
                         Update(Input)
                     end
                 end)
                 Connect(UserInputService.InputEnded, function(Input)
                     if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
                 end)
                 Connect(UserInputService.InputChanged, function(Input)
                     if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end
                 end)

                 local SliderObj = { 
                     Value = Value, 
                     SetValue = function(self, v) 
                        Value = v
                        Fill.Size = UDim2.fromScale(math.clamp((Value - Min)/(Max - Min), 0, 1), 1)
                        Frame.TextLabel.Text = (Config.Title or Key) .. ": " .. Value
                        if Config.Callback then Config.Callback(Value) end
                     end,
                     Type = "Slider"
                 }
                 Helios.Options[Key] = SliderObj
                 return SliderObj
            end
            
            function Items:AddDropdown(Key, Config)
                local Values = Config.Values or {}
                local Default = Config.Default
                local Multi = Config.Multi or false
                local Value = Default or (Multi and {} or Values[1])
                local Expanded = false

                local Frame = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = Section,
                    ThemeTag = { BackgroundColor3 = "Element" },
                    ClipsDescendants = true
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                
                local Button = Creator.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = (Config.Title or Key) .. ": " .. (type(Value) == "table" and table.concat(Value, ", ") or tostring(Value)),
                    ThemeTag = { TextColor3 = "Text" }
                }, { Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10)})})
                
                local List = Creator.New("Frame", {
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = Frame
                }, { 
                   Creator.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                   Creator.New("UIPadding", { PaddingBottom = UDim.new(0, 5)})
                })
                
                local function RefreshList()
                    for _, c in pairs(List:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    
                    for i, Val in pairs(Values) do
                        local Item = Creator.New("TextButton", {
                             Text = Val,
                             Size = UDim2.new(1, 0, 0, 25),
                             Parent = List,
                             ThemeTag = { BackgroundColor3 = "DropdownOption", TextColor3 = "Text" }
                        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                        
                        Connect(Item.MouseButton1Click, function()
                             if Multi then
                                  if table.find(Value, Val) then
                                      for idx, v in pairs(Value) do if v == Val then table.remove(Value, idx) end end
                                  else
                                      table.insert(Value, Val)
                                  end
                                  Button.Text = (Config.Title or Key) .. ": " .. table.concat(Value, ", ")
                                  if Config.Callback then Config.Callback(Value) end
                             else
                                  Value = Val
                                  Button.Text = (Config.Title or Key) .. ": " .. tostring(Value)
                                  Expanded = false
                                  Frame.Size = UDim2.new(1, 0, 0, 35)
                                  if Config.Callback then Config.Callback(Value) end
                             end
                        end)
                    end
                    local h = (#Values * 25) + 40
                    if Expanded then Frame.Size = UDim2.new(1, 0, 0, h) end
                end
                
                Connect(Button.MouseButton1Click, function()
                    Expanded = not Expanded
                    if Expanded then
                        RefreshList()
                    else
                        Frame.Size = UDim2.new(1, 0, 0, 35)
                    end
                end)
                
                local DropdownObj = {
                    Value = Value,
                    SetValues = function(self, NewVal) Values = NewVal; if Expanded then RefreshList() end end,
                    SetValue = function(self, V) Value = V; Button.Text = (Config.Title or Key) .. ": " .. (type(Value) == "table" and table.concat(Value, ", ") or tostring(Value)) end,
                    Type = "Dropdown",
                    Multi = Multi
                }
                Helios.Options[Key] = DropdownObj
                return DropdownObj
            end
            
            function Items:AddInput(Key, Config)
                local Frame = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = Section,
                    ThemeTag = { BackgroundColor3 = "Element" } 
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4)}) })
                
                Creator.New("TextLabel", {
                    Text = Config.Title or Key,
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local TextBox = Creator.New("TextBox", {
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 5, 0, 20),
                    BackgroundTransparency = 1,
                    Text = Config.Default or "",
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false
                })
                
                Connect(TextBox.FocusLost, function(Enter)
                    if Config.Callback then Config.Callback(TextBox.Text) end
                end)
                
                local InputObj = {
                    Value = TextBox.Text,
                    SetValue = function(self, v) TextBox.Text = v end,
                    Type = "Input"
                }
                Helios.Options[Key] = InputObj
                return InputObj
            end

            function Items:AddKeybind(Key, Config)
                local Binding = Config.Default or Enum.KeyCode.Unknown
                local Mode = Config.Mode or "Toggle" 
                local Callback = Config.Callback or function() end
                
                local Frame = Creator.New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Section,
                    ThemeTag = { BackgroundColor3 = "Element" },
                    Text = ""
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}),
                    Creator.New("UIPadding", { PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
                })
                
                local Label = Creator.New("TextLabel", {
                    Text = (Config.Title or Key),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local BindLabel = Creator.New("TextLabel", {
                    Text = "[" .. Binding.Name .. "]",
                    Size = UDim2.new(0.3, 0, 1, 0),
                    Position = UDim2.new(0.7, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Accent" },
                    TextXAlignment = Enum.TextXAlignment.Right,
                })
                
                local Listening = false
                Connect(Frame.MouseButton1Click, function()
                    Listening = true
                    BindLabel.Text = "[...]"
                end)
                
                Connect(UserInputService.InputBegan, function(Input)
                    if Listening then
                        if Input.UserInputType == Enum.UserInputType.Keyboard then
                            Binding = Input.KeyCode
                            BindLabel.Text = "[" .. Binding.Name .. "]"
                            Listening = false
                            if Config.ChangedCallback then Config.ChangedCallback(Binding) end
                        elseif Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseButton2 then
                             Binding = Enum.KeyCode.Unknown
                             BindLabel.Text = "[None]"
                             Listening = false
                        end
                    elseif Input.KeyCode == Binding and Binding ~= Enum.KeyCode.Unknown then
                        Callback()
                    end
                end)
                
                local KeybindObj = {
                    Value = Binding,
                    Mode = Mode,
                    SetValue = function(self, key, mode) 
                         Binding = (typeof(key) == "EnumItem") and key or Enum.KeyCode[key]
                         BindLabel.Text = "[" .. Binding.Name .. "]"
                         Mode = mode or Mode
                    end,
                    GetState = function() return false end, 
                    Type = "Keybind"
                }
                Helios.Options[Key] = KeybindObj
                return KeybindObj
            end
            
            function Items:AddColorpicker(Key, Config)
                -- Simplified Colorpicker: RGB sliders
                local Color = Config.Default or Color3.fromRGB(255, 255, 255)
                local Frame = Creator.New("Frame", {
                     Size = UDim2.new(1, 0, 0, 110),
                     Parent = Section,
                     ThemeTag = { BackgroundColor3 = "Element" }
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4)}) })
                
                Creator.New("TextLabel", {
                    Text = Config.Title or Key,
                    Size = UDim2.new(1, -50, 0, 20),
                    Position = UDim2.new(0, 5, 0, 5),
                    BackgroundTransparency = 1,
                    Parent = Frame,
                    ThemeTag = { TextColor3 = "Text" },
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Preview = Creator.New("Frame", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -45, 0, 5),
                    BackgroundColor3 = Color,
                    Parent = Frame,
                }, { Creator.New("UICorner", { CornerRadius = UDim.new(0,4) }) })
                
                local function CreateSlider(Y, ColorComp, MaxVal)
                     local SliderBg = Creator.New("Frame", {
                         Size = UDim2.new(1, -20, 0, 4),
                         Position = UDim2.new(0, 10, 0, Y),
                         Parent = Frame,
                         BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                     })
                     local Fill = Creator.New("Frame", {
                         Size = UDim2.fromScale(1, 1),
                         BackgroundColor3 = Color3.new(1,1,1),
                         Parent = SliderBg
                     })
                     local Btn = Creator.New("TextButton", {
                         Text = "",
                         Size = UDim2.new(1, 0, 1, 0),
                         BackgroundTransparency = 1,
                         Parent = SliderBg
                     })
                     return Btn, Fill
                end
                
                local R, G, B = math.floor(Color.R*255), math.floor(Color.G*255), math.floor(Color.B*255)
                
                local rBtn, rFill = CreateSlider(35, "R", 255)
                rFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                rFill.Size = UDim2.fromScale(R/255, 1)
                
                local gBtn, gFill = CreateSlider(60, "G", 255)
                gFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                gFill.Size = UDim2.fromScale(G/255, 1)
                
                local bBtn, bFill = CreateSlider(85, "B", 255)
                bFill.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
                bFill.Size = UDim2.fromScale(B/255, 1)

                local function UpdateColor()
                    Color = Color3.fromRGB(R, G, B)
                    Preview.BackgroundColor3 = Color
                    if Config.Callback then Config.Callback(Color) end
                end
                
                local function HandleInput(Input, Btn, Mode)
                    local Scale = math.clamp((Input.Position.X - Btn.AbsolutePosition.X) / Btn.AbsoluteSize.X, 0, 1)
                    if Mode == "R" then R = math.floor(Scale * 255); rFill.Size = UDim2.fromScale(Scale, 1) end
                    if Mode == "G" then G = math.floor(Scale * 255); gFill.Size = UDim2.fromScale(Scale, 1) end
                    if Mode == "B" then B = math.floor(Scale * 255); bFill.Size = UDim2.fromScale(Scale, 1) end
                    UpdateColor()
                end
                
                local DraggingR, DraggingG, DraggingB = false, false, false
                
                Connect(rBtn.InputBegan, function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then DraggingR = true; HandleInput(I, rBtn, "R") end end)
                Connect(gBtn.InputBegan, function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then DraggingG = true; HandleInput(I, gBtn, "G") end end)
                Connect(bBtn.InputBegan, function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then DraggingB = true; HandleInput(I, bBtn, "B") end end)
                
                Connect(UserInputService.InputEnded, function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then DraggingR=false; DraggingG=false; DraggingB=false end end)
                Connect(UserInputService.InputChanged, function(I) 
                    if I.UserInputType == Enum.UserInputType.MouseMovement then
                        if DraggingR then HandleInput(I, rBtn, "R") end
                        if DraggingG then HandleInput(I, gBtn, "G") end
                        if DraggingB then HandleInput(I, bBtn, "B") end
                    end 
                end)
                
                local ColorObj = {
                    Value = Color,
                    Transparency = 0,
                    SetValueRGB = function(self, rgb) Color = rgb; R=math.floor(rgb.R*255); G=math.floor(rgb.G*255); B=math.floor(rgb.B*255); UpdateColor() end,
                    Type = "Colorpicker"
                }
                Helios.Options[Key] = ColorObj
                return ColorObj
            end

            return Items
        end
        return Tab
    end
    
    Helios.Window = Window
    Helios.Loaded = true
    return Window
end

-- Theme management
function Helios:SetTheme(ThemeName)
    if Themes[ThemeName] then
        Helios.Theme = ThemeName
        Creator.UpdateTheme()
    end
end

function Helios:Destroy()
    if Helios.GUI then Helios.GUI:Destroy() end
    Helios.Loaded = false
end

-- Notifications (Mock)
function Helios:Notify(Config)
    -- TODO: Implement notifications
    print("[Helios] Notification:", Config.Title, Config.Content)
end

function Helios:CreateMinimizer(Config)
    -- Stub for mobile minimizer
    local Frame = Instance.new("Frame")
    Frame.Name = "MinimizerStub"
    Frame.Visible = false
    Frame.Parent = Helios.GUI
    return Frame
end

return Helios
