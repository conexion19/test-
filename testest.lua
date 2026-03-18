local Helios = {
    Version = "red",
}

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
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-clock"] = "rbxassetid://10709752630",
	["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-album"] = "rbxassetid://10709752906",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
	["lucide-align-center-vertical"] = "rbxassetid://10709753421",
	["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
	["lucide-align-end-vertical"] = "rbxassetid://10709753808",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
	["lucide-align-start-vertical"] = "rbxassetid://10709760244",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-angry"] = "rbxassetid://10709761629",
	["lucide-annoyed"] = "rbxassetid://10709761722",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-armchair"] = "rbxassetid://10709762327",
	["lucide-anvil"] = "rbxassetid://77943964625400",
	["lucide-arrow-big-down"] = "rbxassetid://10747796644",
	["lucide-arrow-big-left"] = "rbxassetid://10709762574",
	["lucide-arrow-big-right"] = "rbxassetid://10709762727",
	["lucide-arrow-big-up"] = "rbxassetid://10709762879",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-down-left"] = "rbxassetid://10709767656",
	["lucide-arrow-down-right"] = "rbxassetid://10709767750",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-left-right"] = "rbxassetid://10709768019",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-arrow-up-down"] = "rbxassetid://10709768538",
	["lucide-arrow-up-left"] = "rbxassetid://10709768661",
	["lucide-arrow-up-right"] = "rbxassetid://10709768787",
	["lucide-asterisk"] = "rbxassetid://10709769095",
	["lucide-at-sign"] = "rbxassetid://10709769286",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-axis-3d"] = "rbxassetid://10709769598",
	["lucide-baby"] = "rbxassetid://10709769732",
	["lucide-backpack"] = "rbxassetid://10709769841",
	["lucide-baggage-claim"] = "rbxassetid://10709769935",
	["lucide-banana"] = "rbxassetid://10709770005",
	["lucide-banknote"] = "rbxassetid://10709770178",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-barcode"] = "rbxassetid://10747360675",
	["lucide-baseline"] = "rbxassetid://10709773863",
	["lucide-bath"] = "rbxassetid://10709773963",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-battery-charging"] = "rbxassetid://10709774068",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-low"] = "rbxassetid://10709774370",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-beaker"] = "rbxassetid://10709774756",
	["lucide-bed"] = "rbxassetid://10709775036",
	["lucide-bed-double"] = "rbxassetid://10709774864",
	["lucide-bed-single"] = "rbxassetid://10709774968",
	["lucide-beer"] = "rbxassetid://10709775167",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-minus"] = "rbxassetid://10709775241",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bell-plus"] = "rbxassetid://10709775448",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-binary"] = "rbxassetid://10709776050",
	["lucide-bitcoin"] = "rbxassetid://10709776126",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
	["lucide-bluetooth-off"] = "rbxassetid://10709776344",
	["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-bone"] = "rbxassetid://10709781605",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bookmark-minus"] = "rbxassetid://10709781919",
	["lucide-bookmark-plus"] = "rbxassetid://10709782044",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-boxes"] = "rbxassetid://10709782582",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-building-2"] = "rbxassetid://10709782939",
	["lucide-bus"] = "rbxassetid://10709783137",
	["lucide-cake"] = "rbxassetid://10709783217",
	["lucide-calculator"] = "rbxassetid://10709783311",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-check-2"] = "rbxassetid://10709783392",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-calendar-x-2"] = "rbxassetid://10709789329",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-camera-off"] = "rbxassetid://10747822677",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-carrot"] = "rbxassetid://10709789960",
	["lucide-cast"] = "rbxassetid://10709790097",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chef-hat"] = "rbxassetid://10709790757",
	["lucide-cherry"] = "rbxassetid://10709790875",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-first"] = "rbxassetid://10709791015",
	["lucide-chevron-last"] = "rbxassetid://10709791130",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-citrus"] = "rbxassetid://10709798276",
	["lucide-clapperboard"] = "rbxassetid://10709798350",
	["lucide-clipboard"] = "rbxassetid://10709799288",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-clover"] = "rbxassetid://10709806995",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-codepen"] = "rbxassetid://10709810534",
	["lucide-codesandbox"] = "rbxassetid://10709810676",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-component"] = "rbxassetid://10709811595",
	["lucide-concierge-bell"] = "rbxassetid://10709811706",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-contrast"] = "rbxassetid://10709811939",
	["lucide-cookie"] = "rbxassetid://10709812067",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-copyleft"] = "rbxassetid://10709812251",
	["lucide-copyright"] = "rbxassetid://10709812311",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-croissant"] = "rbxassetid://10709818125",
	["lucide-crop"] = "rbxassetid://10709818245",
	["lucide-cross"] = "rbxassetid://10709818399",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-cup-soda"] = "rbxassetid://10709818763",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-currency"] = "rbxassetid://10709818931",
	["lucide-container"] = "rbxassetid://17466205552",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-delete"] = "rbxassetid://10709819059",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-dice-1"] = "rbxassetid://10709819266",
	["lucide-dice-2"] = "rbxassetid://10709819361",
	["lucide-dice-3"] = "rbxassetid://10709819508",
	["lucide-dice-4"] = "rbxassetid://10709819670",
	["lucide-dice-5"] = "rbxassetid://10709819801",
	["lucide-dice-6"] = "rbxassetid://10709819896",
	["lucide-dices"] = "rbxassetid://10723343321",
	["lucide-diff"] = "rbxassetid://10723343416",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-divide"] = "rbxassetid://10723343805",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-door-open"] = "rbxassetid://124179241653522",
	["lucide-droplet"] = "rbxassetid://10723344432",
	["lucide-droplets"] = "rbxassetid://10734883356",
	["lucide-drumstick"] = "rbxassetid://10723344737",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-egg"] = "rbxassetid://10723345518",
	["lucide-egg-fried"] = "rbxassetid://10723345347",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-equal"] = "rbxassetid://10723345990",
	["lucide-equal-not"] = "rbxassetid://10723345866",
	["lucide-eraser"] = "rbxassetid://10723346158",
	["lucide-euro"] = "rbxassetid://10723346372",
	["lucide-expand"] = "rbxassetid://10723346553",
	["lucide-external-link"] = "rbxassetid://10723346684",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-factory"] = "rbxassetid://10723347051",
	["lucide-fan"] = "rbxassetid://10723354359",
	["lucide-fast-forward"] = "rbxassetid://10723354521",
	["lucide-feather"] = "rbxassetid://10723354671",
	["lucide-figma"] = "rbxassetid://10723354801",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-file-archive"] = "rbxassetid://10723354921",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-axis-3d"] = "rbxassetid://10723355272",
	["lucide-file-badge"] = "rbxassetid://10723355622",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart"] = "rbxassetid://10723355887",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-box"] = "rbxassetid://10723355989",
	["lucide-file-check"] = "rbxassetid://10723356210",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-clock"] = "rbxassetid://10723356329",
	["lucide-file-code"] = "rbxassetid://10723356507",
	["lucide-file-cog"] = "rbxassetid://10723356830",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-diff"] = "rbxassetid://10723357039",
	["lucide-file-digit"] = "rbxassetid://10723357151",
	["lucide-file-down"] = "rbxassetid://10723357322",
	["lucide-file-edit"] = "rbxassetid://10723357495",
	["lucide-file-heart"] = "rbxassetid://10723357637",
	["lucide-file-image"] = "rbxassetid://10723357790",
	["lucide-file-input"] = "rbxassetid://10723357933",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key"] = "rbxassetid://10723364605",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-line-chart"] = "rbxassetid://10723364725",
	["lucide-file-lock"] = "rbxassetid://10723364957",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus"] = "rbxassetid://10723365254",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-output"] = "rbxassetid://10723365457",
	["lucide-file-pie-chart"] = "rbxassetid://10723365598",
	["lucide-file-plus"] = "rbxassetid://10723365877",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-scan"] = "rbxassetid://10723366167",
	["lucide-file-search"] = "rbxassetid://10723366550",
	["lucide-file-search-2"] = "rbxassetid://10723366340",
	["lucide-file-signature"] = "rbxassetid://10723366741",
	["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
	["lucide-file-symlink"] = "rbxassetid://10723367098",
	["lucide-file-terminal"] = "rbxassetid://10723367244",
	["lucide-file-text"] = "rbxassetid://10723367380",
	["lucide-file-type"] = "rbxassetid://10723367606",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-up"] = "rbxassetid://10723367734",
	["lucide-file-video"] = "rbxassetid://10723373884",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume"] = "rbxassetid://10723374172",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-warning"] = "rbxassetid://10723374276",
	["lucide-file-x"] = "rbxassetid://10723374544",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-files"] = "rbxassetid://10723374759",
	["lucide-film"] = "rbxassetid://10723374981",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flag"] = "rbxassetid://10723375890",
	["lucide-flag-off"] = "rbxassetid://10723375443",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-flashlight"] = "rbxassetid://10723376471",
	["lucide-flashlight-off"] = "rbxassetid://10723376365",
	["lucide-flask-conical"] = "rbxassetid://10734883986",
	["lucide-flask-round"] = "rbxassetid://10723376614",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-flower"] = "rbxassetid://10747830374",
	["lucide-flower-2"] = "rbxassetid://10723377305",
	["lucide-focus"] = "rbxassetid://10723377537",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-archive"] = "rbxassetid://10723384478",
	["lucide-folder-check"] = "rbxassetid://10723384605",
	["lucide-folder-clock"] = "rbxassetid://10723384731",
	["lucide-folder-closed"] = "rbxassetid://10723384893",
	["lucide-folder-cog"] = "rbxassetid://10723385213",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-down"] = "rbxassetid://10723385338",
	["lucide-folder-edit"] = "rbxassetid://10723385445",
	["lucide-folder-heart"] = "rbxassetid://10723385545",
	["lucide-folder-input"] = "rbxassetid://10723385721",
	["lucide-folder-key"] = "rbxassetid://10723385848",
	["lucide-folder-lock"] = "rbxassetid://10723386005",
	["lucide-folder-minus"] = "rbxassetid://10723386127",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-folder-output"] = "rbxassetid://10723386386",
	["lucide-folder-plus"] = "rbxassetid://10723386531",
	["lucide-folder-search"] = "rbxassetid://10723386787",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-folder-symlink"] = "rbxassetid://10723386930",
	["lucide-folder-tree"] = "rbxassetid://10723387085",
	["lucide-folder-up"] = "rbxassetid://10723387265",
	["lucide-folder-x"] = "rbxassetid://10723387448",
	["lucide-folders"] = "rbxassetid://10723387721",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-forward"] = "rbxassetid://10723388016",
	["lucide-frame"] = "rbxassetid://10723394389",
	["lucide-framer"] = "rbxassetid://10723394565",
	["lucide-frown"] = "rbxassetid://10723394681",
	["lucide-fuel"] = "rbxassetid://10723394846",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gavel"] = "rbxassetid://10723395896",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch"] = "rbxassetid://10723396676",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-commit"] = "rbxassetid://10723396812",
	["lucide-git-compare"] = "rbxassetid://10723396954",
	["lucide-git-fork"] = "rbxassetid://10723397049",
	["lucide-git-merge"] = "rbxassetid://10723397165",
	["lucide-git-pull-request"] = "rbxassetid://10723397431",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-glass-water"] = "rbxassetid://10723397678",
	["lucide-glasses"] = "rbxassetid://10723397895",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-graduation-cap"] = "rbxassetid://10723404691",
	["lucide-grape"] = "rbxassetid://10723404822",
	["lucide-grid"] = "rbxassetid://10723404936",
	["lucide-grip-horizontal"] = "rbxassetid://10723405089",
	["lucide-grip-vertical"] = "rbxassetid://10723405236",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-hand"] = "rbxassetid://10723405649",
	["lucide-hand-metal"] = "rbxassetid://10723405508",
	["lucide-hard-drive"] = "rbxassetid://10723405749",
	["lucide-hard-hat"] = "rbxassetid://10723405859",
	["lucide-hash"] = "rbxassetid://10723405975",
	["lucide-haze"] = "rbxassetid://10723406078",
	["lucide-headphones"] = "rbxassetid://10723406165",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-heart-crack"] = "rbxassetid://10723406299",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-heart-off"] = "rbxassetid://10723406662",
	["lucide-heart-pulse"] = "rbxassetid://10723406795",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-hexagon"] = "rbxassetid://10723407092",
	["lucide-highlighter"] = "rbxassetid://10723407192",
	["lucide-history"] = "rbxassetid://10723407335",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-hourglass"] = "rbxassetid://10723407498",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-image-minus"] = "rbxassetid://10723414487",
	["lucide-image-off"] = "rbxassetid://10723414677",
	["lucide-image-plus"] = "rbxassetid://10723414827",
	["lucide-import"] = "rbxassetid://10723415205",
	["lucide-inbox"] = "rbxassetid://10723415335",
	["lucide-indent"] = "rbxassetid://10723415494",
	["lucide-indian-rupee"] = "rbxassetid://10723415642",
	["lucide-infinity"] = "rbxassetid://10723415766",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-italic"] = "rbxassetid://10723416195",
	["lucide-japanese-yen"] = "rbxassetid://10723416363",
	["lucide-joystick"] = "rbxassetid://10723416527",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
	["lucide-lamp-desk"] = "rbxassetid://10723417016",
	["lucide-lamp-floor"] = "rbxassetid://10723417131",
	["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
	["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
	["lucide-landmark"] = "rbxassetid://10723417608",
	["lucide-languages"] = "rbxassetid://10723417703",
	["lucide-laptop"] = "rbxassetid://10723423881",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-lasso"] = "rbxassetid://10723424235",
	["lucide-lasso-select"] = "rbxassetid://10723424058",
	["lucide-laugh"] = "rbxassetid://10723424372",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-dashboard"] = "rbxassetid://10723424646",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-layout-template"] = "rbxassetid://10723425187",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-library"] = "rbxassetid://10723425615",
	["lucide-life-buoy"] = "rbxassetid://10723425685",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-lightbulb-off"] = "rbxassetid://10723425762",
	["lucide-line-chart"] = "rbxassetid://10723426393",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-link-2"] = "rbxassetid://10723426595",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-list-end"] = "rbxassetid://10723426886",
	["lucide-list-minus"] = "rbxassetid://10723426986",
	["lucide-list-music"] = "rbxassetid://10723427081",
	["lucide-list-ordered"] = "rbxassetid://10723427199",
	["lucide-list-plus"] = "rbxassetid://10723427334",
	["lucide-list-start"] = "rbxassetid://10723427494",
	["lucide-list-video"] = "rbxassetid://10723427619",
	["lucide-list-todo"] = "rbxassetid://17376008003",
	["lucide-list-x"] = "rbxassetid://10723433655",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-locate"] = "rbxassetid://10723434557",
	["lucide-locate-fixed"] = "rbxassetid://10723434236",
	["lucide-locate-off"] = "rbxassetid://10723434379",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-luggage"] = "rbxassetid://10723434993",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-mail-check"] = "rbxassetid://10723435182",
	["lucide-mail-minus"] = "rbxassetid://10723435261",
	["lucide-mail-open"] = "rbxassetid://10723435342",
	["lucide-mail-plus"] = "rbxassetid://10723435443",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-mails"] = "rbxassetid://10734885614",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-map-pin-off"] = "rbxassetid://10734885803",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-maximize-2"] = "rbxassetid://10734886496",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-megaphone-off"] = "rbxassetid://10734887311",
	["lucide-meh"] = "rbxassetid://10734887603",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-microscope"] = "rbxassetid://10734889106",
	["lucide-microwave"] = "rbxassetid://10734895076",
	["lucide-milestone"] = "rbxassetid://10734895310",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minimize-2"] = "rbxassetid://10734895530",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-monitor-off"] = "rbxassetid://10734896360",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mountain-snow"] = "rbxassetid://10734897665",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-mouse-pointer"] = "rbxassetid://10734898476",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move"] = "rbxassetid://10734900011",
	["lucide-move-3d"] = "rbxassetid://10734898756",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-move-horizontal"] = "rbxassetid://10734899414",
	["lucide-move-vertical"] = "rbxassetid://10734899821",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-music-2"] = "rbxassetid://10734900215",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-octagon"] = "rbxassetid://10734907361",
	["lucide-option"] = "rbxassetid://10734907649",
	["lucide-outdent"] = "rbxassetid://10734907933",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-package-check"] = "rbxassetid://10734908384",
	["lucide-package-minus"] = "rbxassetid://10734908626",
	["lucide-package-open"] = "rbxassetid://10734908793",
	["lucide-package-plus"] = "rbxassetid://10734909016",
	["lucide-package-search"] = "rbxassetid://10734909196",
	["lucide-package-x"] = "rbxassetid://10734909375",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-paperclip"] = "rbxassetid://10734910927",
	["lucide-party-popper"] = "rbxassetid://10734918735",
	["lucide-pause"] = "rbxassetid://10734919336",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-pen-tool"] = "rbxassetid://10734919503",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-person-standing"] = "rbxassetid://10734920149",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-phone-call"] = "rbxassetid://10734920305",
	["lucide-phone-forwarded"] = "rbxassetid://10734920508",
	["lucide-phone-incoming"] = "rbxassetid://10734920694",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-phone-off"] = "rbxassetid://10734921077",
	["lucide-phone-outgoing"] = "rbxassetid://10734921288",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-piggy-bank"] = "rbxassetid://10734921935",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-pin-off"] = "rbxassetid://10734922180",
	["lucide-pipette"] = "rbxassetid://10734922497",
	["lucide-pizza"] = "rbxassetid://10734922774",
	["lucide-plane"] = "rbxassetid://10734922971",
	["lucide-plane-landing"] = "rbxassetid://17376029914",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-podcast"] = "rbxassetid://10734929553",
	["lucide-pointer"] = "rbxassetid://10734929723",
	["lucide-pound-sterling"] = "rbxassetid://10734929981",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-quote"] = "rbxassetid://10734931234",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-radio-receiver"] = "rbxassetid://10734931402",
	["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
	["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-redo"] = "rbxassetid://10734932822",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-refrigerator"] = "rbxassetid://10734933465",
	["lucide-regex"] = "rbxassetid://10734933655",
	["lucide-repeat"] = "rbxassetid://10734933966",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rewind"] = "rbxassetid://10734934347",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rocking-chair"] = "rbxassetid://10734939942",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-rss"] = "rbxassetid://10734940825",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-russian-ruble"] = "rbxassetid://10734941199",
	["lucide-sailboat"] = "rbxassetid://10734941354",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scale"] = "rbxassetid://10734941912",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-scaling"] = "rbxassetid://10734942072",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scan-face"] = "rbxassetid://10734942198",
	["lucide-scan-line"] = "rbxassetid://10734942351",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-screen-share"] = "rbxassetid://10734943193",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-scroll"] = "rbxassetid://10734943448",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-separator-horizontal"] = "rbxassetid://10734944115",
	["lucide-separator-vertical"] = "rbxassetid://10734944326",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-server-cog"] = "rbxassetid://10734944444",
	["lucide-server-crash"] = "rbxassetid://10734944554",
	["lucide-server-off"] = "rbxassetid://10734944668",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-share-2"] = "rbxassetid://10734950553",
	["lucide-sheet"] = "rbxassetid://10734951038",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shield-close"] = "rbxassetid://10734951535",
	["lucide-shield-off"] = "rbxassetid://10734951684",
	["lucide-shirt"] = "rbxassetid://10734952036",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shovel"] = "rbxassetid://10734952773",
	["lucide-shower-head"] = "rbxassetid://10734952942",
	["lucide-shrink"] = "rbxassetid://10734953073",
	["lucide-shrub"] = "rbxassetid://10734953241",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-sigma"] = "rbxassetid://10734954538",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-siren"] = "rbxassetid://10734961284",
	["lucide-skip-back"] = "rbxassetid://10734961526",
	["lucide-skip-forward"] = "rbxassetid://10734961809",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slack"] = "rbxassetid://10734962339",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-slice"] = "rbxassetid://10734963024",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smartphone-charging"] = "rbxassetid://10734963671",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sofa"] = "rbxassetid://10734964852",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-sprout"] = "rbxassetid://10734965572",
	["lucide-square"] = "rbxassetid://10734965702",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-star-off"] = "rbxassetid://10734966097",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-sticker"] = "rbxassetid://10734972234",
	["lucide-sticky-note"] = "rbxassetid://10734972463",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
	["lucide-stretch-vertical"] = "rbxassetid://10734973130",
	["lucide-strikethrough"] = "rbxassetid://10734973290",
	["lucide-subscript"] = "rbxassetid://10734973457",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-sunrise"] = "rbxassetid://10734974522",
	["lucide-sunset"] = "rbxassetid://10734974689",
	["lucide-superscript"] = "rbxassetid://10734974850",
	["lucide-swiss-franc"] = "rbxassetid://10734975024",
	["lucide-switch-camera"] = "rbxassetid://10734975214",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-tablet"] = "rbxassetid://10734976394",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-tags"] = "rbxassetid://10734976739",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-tent"] = "rbxassetid://10734981750",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor"] = "rbxassetid://10734982395",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
	["lucide-thermometer-sun"] = "rbxassetid://10734982771",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-toy-brick"] = "rbxassetid://10747361919",
	["lucide-train"] = "rbxassetid://10747362105",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tree-deciduous"] = "rbxassetid://10747362534",
	["lucide-tree-pine"] = "rbxassetid://10747362748",
	["lucide-trees"] = "rbxassetid://10747363016",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-type"] = "rbxassetid://10747364761",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-underline"] = "rbxassetid://10747365191",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink"] = "rbxassetid://10747365771",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-usb"] = "rbxassetid://10747366606",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-venetian-mask"] = "rbxassetid://10747374003",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate"] = "rbxassetid://10747374489",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-view"] = "rbxassetid://10747375132",
	["lucide-voicemail"] = "rbxassetid://10747375281",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-1"] = "rbxassetid://10747375450",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wheat"] = "rbxassetid://80877624162595",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-waves"] = "rbxassetid://10747376931",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
	["lucide-cat"] = "rbxassetid://16935650691",
	["lucide-message-circle-question"] = "rbxassetid://16970049192",
	["lucide-webhook"] = "rbxassetid://17320556264",
	["lucide-dumbbell"] = "rbxassetid://18273453053",
	default = "rbxassetid://10709782430"
}

function Helios:GetIcon(Name)
	if Name ~= nil and Icons["lucide-" .. Name] then
		return Icons["lucide-" .. Name]
	elseif Name ~= nil and Icons[Name] then
		return Icons[Name]
	end
	return Icons.default
end

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

function Helios:CreateWindow(Config)
    -- Check if window exists and is valid (not destroyed)
    if Helios.Window and Helios.Window.Screen and Helios.Window.Screen.Parent then
        Helios.Window.Screen:Destroy() -- Force cleanup of old window if exists
        Helios.Window = nil
    end
    
    local Window = { Tabs = {} }
    
    local ProtectedParent = nil
    pcall(function()
        ProtectedParent = game:GetService("CoreGui")
    end)
    
    if not ProtectedParent then
        ProtectedParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local Title = Config.Title or "Library"
    local SubTitle = Config.SubTitle or ""
    local Size = Config.Size or UDim2.fromOffset(580, 460)
    
    local Screen = Creator.New("ScreenGui", {
        Name = "HeliosUI",
        Parent = ProtectedParent,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    -- Main Window Frame
    local Root = Creator.New("Frame", {
        Name = Title,
        Size = Size,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Screen,
        BackgroundTransparency = 0,
        ThemeTag = { BackgroundColor3 = "AcrylicMain" }
    }, {
        Creator.New("UIStroke", { ThemeTag = { Color = "AcrylicBorder" }, Thickness = 1 }),
        Creator.New("UIScale", { Scale = 0.8 })
    })
    
    -- Window Open Animation
    TweenService:Create(Root.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    
    -- Top Bar (Drag Area)
    local UserInfoSubtitle = Config.UserInfoSubtitle or "Freemium"
    local LogoIcon = Creator.New("ImageLabel", {
        Name = "Logo",
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 8, 0.5, -18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://113682947140762",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
    })

    local SubtitleLabel = Creator.New("TextLabel", {
        Name = "UserSubtitle",
        Text = UserInfoSubtitle,
        TextTransparency = 0,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 150, 0, 15),
        Position = UDim2.new(0, 50, 0.5, -7), 
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
    })

    local CheckGradient = Creator.New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        }),
        Parent = SubtitleLabel,
    })
    task.spawn(function()
        while task.wait(3) do
            if not SubtitleLabel.Parent then break end
            CheckGradient.Offset = Vector2.new(-1, 0)
            TweenService:Create(CheckGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
        end
    end)

    local TopBar = Creator.New("Frame", {
         Size = UDim2.new(1, 0, 0, 48),
         BackgroundTransparency = 1,
         Parent = Root
    }, {
        LogoIcon,
        SubtitleLabel,
        Creator.New("TextLabel", {
            Text = Title,
            Size = UDim2.new(1, 0, 0, 48),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            ThemeTag = { TextColor3 = "Text" },
            TextSize = 16,
        })
    })

    -- Add Top Bar Buttons (Close / Hide)
    local function CreateBarButton(IconId, Pos, Callback)
        local btn = Creator.New("TextButton", {
            Size = UDim2.new(0, 34, 1, -14),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = Pos,
            BackgroundTransparency = 1,
            Parent = TopBar,
            Text = "",
            ThemeTag = { BackgroundColor3 = "Text" },
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 7) }),
            Creator.New("ImageLabel", {
                Image = IconId,
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                ThemeTag = { ImageColor3 = "Text" },
            })
        })
        Connect(btn.MouseEnter, function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.94}):Play() end)
        Connect(btn.MouseLeave, function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end)
        Connect(btn.MouseButton1Down, function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.96}):Play() end)
        Connect(btn.MouseButton1Up, function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.94}):Play() end)
        Connect(btn.MouseButton1Click, Callback)
        return btn
    end

    CreateBarButton("rbxassetid://10709791437", UDim2.new(1, -4, 0.5, 0), function()
        if Helios.Window and Helios.Window.Dialog then
            Helios.Window:Dialog({
                Title = "Close",
                Content = "Are you sure you want to unload the interface?",
                Buttons = {
                    {
                        Title = "Yes",
                        Callback = function()
                            if Helios.Window.Screen then
                                Helios.Window.Screen:Destroy()
                                Helios.Window = nil
                            end
                        end,
                    },
                    {
                        Title = "No",
                        Callback = function() end 
                    },
                },
            })
        else
            Root.Visible = false
            if Helios.Window and Helios.Window.Screen then Helios.Window.Screen:Destroy() end
        end
    end)
    
    CreateBarButton("rbxassetid://10709796032", UDim2.new(1, -42, 0.5, 0), function()
        Root.Visible = false
    end)

    -- Divider below Top Bar
    Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 48),
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
        Size = UDim2.new(0, 160, 1, -49),
        Position = UDim2.new(0, 0, 0, 49),
        BackgroundTransparency = 1,
        Parent = Root,
        ScrollBarThickness = 0,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, {
        Creator.New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
        Creator.New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
    })

    -- Sidebar Divider
    Creator.New("Frame", {
        Size = UDim2.new(0, 1, 1, -49),
        Position = UDim2.new(0, 160, 0, 49),
        Parent = Root,
        ThemeTag = { BackgroundColor3 = "TitleBarLine" }
    })
    
    local ContainerHolder = Creator.New("Frame", {
        Name = "ContainerHolder",
        Size = UDim2.new(1, -161, 1, -49),
        Position = UDim2.new(0, 161, 0, 49),
        BackgroundTransparency = 1,
        Parent = Root,
    })
    
    Window.Root = Root
    Window.Screen = Screen

    -- Dialog Implementation
    function Window:Dialog(DConfig)
        local DialogFrame = Creator.New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Parent = Root,
            ZIndex = 50
        })

        local DialogBox = Creator.New("Frame", {
            Size = UDim2.fromOffset(300, 150),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ThemeTag = { BackgroundColor3 = "Element" },
            Parent = DialogFrame,
            ZIndex = 51
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder" }, Thickness = 1 })
        })

        Creator.New("TextLabel", {
            Text = DConfig.Title or "Dialog",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            ThemeTag = { TextColor3 = "Text" },
            Parent = DialogBox,
            ZIndex = 52
        })

        Creator.New("TextLabel", {
            Text = DConfig.Content or "",
            Size = UDim2.new(1, -40, 1, -100),
            Position = UDim2.fromOffset(20, 40),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextWrapped = true,
            ThemeTag = { TextColor3 = "SubText" },
            Parent = DialogBox,
            ZIndex = 52
        })

        local ButtonContainer = Creator.New("Frame", {
            Size = UDim2.new(1, -40, 0, 40),
            Position = UDim2.new(0, 20, 1, -50),
            BackgroundTransparency = 1,
            Parent = DialogBox,
            ZIndex = 52
        }, {
            Creator.New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        })

        TweenService:Create(DialogFrame, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()

        local function closeDialog()
            TweenService:Create(DialogFrame, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
            local tw = TweenService:Create(DialogBox, TweenInfo.new(0.2), { Size = UDim2.fromOffset(300, 0) })
            tw:Play()
            tw.Completed:Connect(function() DialogFrame:Destroy() end)
        end

        for _, btnData in ipairs(DConfig.Buttons or {}) do
            local btn = Creator.New("TextButton", {
                Size = UDim2.new(0.5, -5, 1, 0),
                ThemeTag = { BackgroundColor3 = "Hover" },
                Text = btnData.Title or "Button",
                Font = Enum.Font.Gotham,
                TextSize = 14,
                ThemeTag = { TextColor3 = "Text" },
                Parent = ButtonContainer,
                ZIndex = 53
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder" }, Thickness = 1 })
            })

            Connect(btn.MouseButton1Click, function()
                closeDialog()
                if type(btnData.Callback) == "function" then
                    btnData.Callback()
                end
            end)
        end
    end
    
    function Window:SelectTab(TabInfo)
        if type(TabInfo) == "number" and Window.Tabs[TabInfo] then
            Window.Tabs[TabInfo]:Select()
        elseif type(TabInfo) == "table" and TabInfo.Select then
            TabInfo:Select()
        end
    end

    function Window:AddTab(Config)
        local TabTitle = Config.Title or "Tab"
        local IconID = Helios:GetIcon(Config.Icon)
        
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
        
        local ContainerLayout = Creator.New("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        
        local Container = Creator.New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = ContainerHolder,
            Visible = false,
            ScrollBarThickness = 2,
            ElasticBehavior = Enum.ElasticBehavior.Never,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, {
            ContainerLayout,
            Creator.New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) })
        })

        Connect(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 20)
        end)

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
             Container.Position = UDim2.fromOffset(0, 15)
             TweenService:Create(Container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.fromScale(0, 0) }):Play()
             
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
                        Size = UDim2.new(1, -30, 1, 0),
                        Position = UDim2.fromOffset(10, 0),
                        ThemeTag = { TextColor3 = "Text" },
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Creator.New("ImageLabel", {
                        Image = "rbxassetid://10709791437",
                        Size = UDim2.fromOffset(16, 16),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        BackgroundTransparency = 1,
                        ThemeTag = { ImageColor3 = "Text" }
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
                 }, { 
                     Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                     Creator.New("Frame", { -- Knob
                         Size = UDim2.new(0, 12, 0, 12),
                         Position = UDim2.new(1, 0, 0.5, 0),
                         AnchorPoint = Vector2.new(0.5, 0.5),
                         BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                     }, { 
                         Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                         Creator.New("UIStroke", { Thickness = 1, Color = Color3.fromRGB(20, 20, 20), Transparency = 0.5 })
                     })
                 })
                 
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
                local AllowNull = EConfig.AllowNull or false
                local Value = Default or (Multi and {} or nil)
                local Expanded = false
                local Search = (EConfig.Search == nil) and true or EConfig.Search

                local Frame = Creator.New("Frame", {
                    Size = UDim2.new(1, 0, 0, 52),
                    Parent = Parent,
                    ThemeTag = { BackgroundColor3 = "Element" },
                    BackgroundTransparency = 0,
                }, { 
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Creator.New("UIStroke", { ThemeTag = { Color = "ElementBorder"}, Thickness = 1 }),
                    Creator.New("TextLabel", {
                        Name = "TitleLabel",
                        Text = EConfig.Title or Key,
                        Size = UDim2.new(1, -20, 0, 20),
                        Position = UDim2.fromOffset(10, 8),
                        BackgroundTransparency = 1,
                        ThemeTag = { TextColor3 = "Text" },
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 14
                    })
                })
                
                if EConfig.Description and EConfig.Description ~= "" then
                    Creator.New("TextLabel", {
                        Text = EConfig.Description,
                        Size = UDim2.new(1, -20, 0, 14),
                        Position = UDim2.fromOffset(10, 28),
                        BackgroundTransparency = 1,
                        ThemeTag = { TextColor3 = "SubText" },
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 12,
                        Parent = Frame
                    })
                else
                    Frame.Size = UDim2.new(1, 0, 0, 36)
                    Frame.TitleLabel.Size = UDim2.new(1, -170, 1, 0)
                    Frame.TitleLabel.Position = UDim2.fromOffset(10, 0)
                end

                local DropdownDisplay = Creator.New("TextLabel", {
                    Text = "",
                    ThemeTag = { TextColor3 = "Text" },
                    TextSize = 13,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -30, 0.5, 0),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Font = Enum.Font.Gotham
                })

                local DropdownIco = Creator.New("ImageLabel", {
                    Image = "rbxassetid://10709790948",
                    Size = UDim2.fromOffset(16, 16),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    BackgroundTransparency = 1,
                    Rotation = 180,
                    ThemeTag = { ImageColor3 = "SubText" },
                })

                local DropdownInner = Creator.New("TextButton", {
                    Size = UDim2.fromOffset(160, 30),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 0.9,
                    Parent = Frame,
                    ThemeTag = { BackgroundColor3 = "DropdownFrame" },
                    Text = ""
                }, {
                    Creator.New("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    Creator.New("UIStroke", { Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "ElementBorder" } }),
                    DropdownIco,
                    DropdownDisplay,
                })

                local DropdownListLayout = Creator.New("UIListLayout", { Padding = UDim.new(0, 3) })

                local DropdownScrollFrame = Creator.New("ScrollingFrame", {
                    Size = UDim2.new(1, -5, 1, -10),
                    Position = UDim2.fromOffset(5, 5),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 5,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.fromScale(0, 0),
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                }, { DropdownListLayout })
                
                local SearchBar
                local SearchBox
                if Search then
                    SearchBar = Creator.New("Frame", {
                        Size = UDim2.new(1, -10, 0, 28),
                        Position = UDim2.fromOffset(5, 5),
                        BackgroundTransparency = 0.7,
                        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                        ThemeTag = { BackgroundColor3 = "Element" },
                        ZIndex = 24,
                    }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }) })

                    SearchBox = Creator.New("TextBox", {
                        Font = Enum.Font.Gotham,
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -36, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        PlaceholderText = "Search...",
                        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                        ClearTextOnFocus = false,
                        Text = "",
                        Parent = SearchBar,
                        ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
                        ZIndex = 24,
                    })

                    Creator.New("ImageLabel", {
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.new(1, -13, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = "rbxassetid://10734943674",
                        Parent = SearchBar,
                        ImageTransparency = 0.3,
                        ZIndex = 25,
                        ThemeTag = { ImageColor3 = "SubText" },
                    })

                    DropdownScrollFrame.Position = UDim2.fromOffset(5, 38)
                    DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -43)
                end

                local DropdownHolderFrame = Creator.New("Frame", {
                    Size = UDim2.fromScale(1, 0),
                    ClipsDescendants = true,
                    BackgroundTransparency = 1,
                }, {
                    Creator.New("Frame", {
                        Size = UDim2.fromScale(1, 1),
                        ThemeTag = { BackgroundColor3 = "Element" },
                    }, {
                        SearchBar,
                        DropdownScrollFrame,
                        Creator.New("UICorner", { CornerRadius = UDim.new(0, 7) }),
                        Creator.New("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, ThemeTag = { Color = "ElementBorder" } }),
                        Creator.New("ImageLabel", {
                            BackgroundTransparency = 1,
                            Image = "rbxassetid://5554236805",
                            ScaleType = Enum.ScaleType.Slice,
                            SliceCenter = Rect.new(23, 23, 277, 277),
                            Size = UDim2.new(1, 30, 1, 30),
                            Position = UDim2.fromOffset(-15, -15),
                            ImageColor3 = Color3.fromRGB(0, 0, 0),
                            ImageTransparency = 0.1,
                            ZIndex = 0
                        }),
                    })
                })

                local DropdownHolderCanvas = Creator.New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(170, 0),
                    Parent = Helios.Window and Helios.Window.Screen or nil,
                    Visible = false,
                    ZIndex = 1000, 
                }, { DropdownHolderFrame, Creator.New("UISizeConstraint", { MinSize = Vector2.new(170, 0) }) })
                
                table.insert(OpenFrames, DropdownHolderCanvas)

                local function UpdateLabel()
                    if Multi then
                        local temp = {}
                        for k, v in pairs(Value) do if v then table.insert(temp, k) end end
                        DropdownDisplay.Text = #temp == 0 and "None" or table.concat(temp, ", ")
                    else
                        DropdownDisplay.Text = Value == nil and "None" or tostring(Value)
                    end
                end

                local Buttons = {}

                local function RecalculateSize()
                    local cnt = 0
                    for _, v in pairs(DropdownScrollFrame:GetChildren()) do
                        if v:IsA("TextButton") and v.Visible then cnt = cnt + 1 end
                    end
                    local h = (cnt * 35) + 10 + (Search and 38 or 0)
                    h = math.clamp(h, 40, 250)
                    DropdownHolderCanvas.Size = UDim2.fromOffset(170, h)
                    DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
                end

                local function RecalculatePos()
                    if DropdownInner and DropdownHolderCanvas.Parent then
                        local AbsPos = DropdownInner.AbsolutePosition
                        local AbsSize = DropdownInner.AbsoluteSize
                        local RootPos = DropdownInner.Parent.AbsolutePosition
                        
                        -- Place right below dropdown
                        DropdownHolderCanvas.Position = UDim2.fromOffset(AbsPos.X, AbsPos.Y + AbsSize.Y + 2)
                    end
                end

                local function CloseDropdown()
                    Expanded = false
                    TweenService:Create(DropdownIco, TweenInfo.new(0.3), { Rotation = 180 }):Play()
                    local tween = TweenService:Create(DropdownHolderFrame, TweenInfo.new(0.2), { Size = UDim2.fromScale(1, 0) })
                    tween:Play()
                    tween.Completed:Connect(function()
                        if not Expanded then DropdownHolderCanvas.Visible = false end
                    end)
                    if SearchBox then SearchBox.Text = "" end
                end

                local function OpenDropdown()
                    Expanded = true
                    for _, f in pairs(OpenFrames) do
                        if f ~= DropdownHolderCanvas and f.Visible then f.Visible = false end
                    end
                    RecalculatePos()
                    RecalculateSize()
                    DropdownHolderCanvas.Visible = true
                    TweenService:Create(DropdownIco, TweenInfo.new(0.3), { Rotation = 0 }):Play()
                    TweenService:Create(DropdownHolderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromScale(1, 1) }):Play()
                end

                Connect(DropdownInner.MouseButton1Click, function()
                    if Expanded then CloseDropdown() else OpenDropdown() end
                end)

                if SearchBox then
                    Connect(SearchBox:GetPropertyChangedSignal("Text"), function()
                        local q = SearchBox.Text:lower()
                        for val, item in pairs(Buttons) do
                            item.Visible = (q == "" or val:lower():find(q) ~= nil)
                        end
                        RecalculateSize()
                    end)
                end

                Connect(UserInputService.InputBegan, function(Input)
                    if Expanded and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
                        local mPos = UserInputService:GetMouseLocation()
                        local dA, dS = DropdownHolderCanvas.AbsolutePosition, DropdownHolderCanvas.AbsoluteSize
                        local iA, iS = DropdownInner.AbsolutePosition, DropdownInner.AbsoluteSize
                        
                        local inD = (mPos.X >= dA.X and mPos.X <= dA.X + dS.X and mPos.Y >= dA.Y and mPos.Y <= dA.Y + dS.Y)
                        local inI = (mPos.X >= iA.X and mPos.X <= iA.X + iS.X and mPos.Y >= iA.Y and mPos.Y <= iA.Y + iS.Y)
                        
                        if not inD and not inI then CloseDropdown() end
                    end
                end)

                local function RefreshList()
                    for _, c in pairs(DropdownScrollFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    table.clear(Buttons)

                    for _, Val in pairs(Values) do
                        local Selected = Multi and Value[Val] or (Value == Val)

                        local ButtonSelector = Creator.New("Frame", {
                            Size = UDim2.new(0, 4, 0, Selected and 14 or 6),
                            Position = UDim2.new(0, -1, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundTransparency = Selected and 0 or 1,
                            ThemeTag = { BackgroundColor3 = "Accent" }
                        }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 2) }) })

                        local Item = Creator.New("TextButton", {
                             Text = "",
                             Size = UDim2.new(1, 0, 0, 32),
                             Parent = DropdownScrollFrame,
                             ThemeTag = { BackgroundColor3 = "Hover" },
                             BackgroundTransparency = Selected and 0.85 or 1
                        }, { 
                             Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                             ButtonSelector,
                             Creator.New("TextLabel", {
                                 Text = Val,
                                 Size = UDim2.new(1, -15, 1, 0),
                                 Position = UDim2.new(0, 10, 0, 0),
                                 BackgroundTransparency = 1,
                                 ThemeTag = { TextColor3 = "Text" },
                                 Font = Enum.Font.Gotham,
                                 TextSize = 13,
                                 TextXAlignment = Enum.TextXAlignment.Left
                             })
                        })
                        
                        Buttons[Val] = Item

                        local DropdownObjRef -- Need to reference OnChanged
                        Connect(Item.MouseButton1Click, function()
                             if Multi then
                                  Value[Val] = not Value[Val]
                             else
                                  if Value == Val and not AllowNull then return end
                                  Value = (Value == Val and AllowNull) and nil or Val
                                  CloseDropdown()
                             end
                             
                             if type(EConfig.Callback) == "function" then EConfig.Callback(Value) end
                             if DropdownObjRef and type(DropdownObjRef.Changed) == "function" then DropdownObjRef.Changed(Value) end
                             UpdateLabel()
                             
                             -- Animate Selection Checkbox without full recount
                             for vName, vItem in pairs(Buttons) do
                                 local IsSel = Multi and Value[vName] or (Value == vName)
                                 TweenService:Create(vItem, TweenInfo.new(0.2), { BackgroundTransparency = IsSel and 0.85 or 1 }):Play()
                                 local Ind = vItem:FindFirstChildOfClass("Frame")
                                 TweenService:Create(Ind, TweenInfo.new(0.2), {
                                    Size = UDim2.new(0, 4, 0, IsSel and 14 or 6),
                                    BackgroundTransparency = IsSel and 0 or 1
                                 }):Play()
                             end
                        end)
                    end
                    RecalculateSize()
                end
                
                Connect(DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), RecalculateSize)
                if Helios.Window and Helios.Window.Root then
                    Connect(Helios.Window.Root:GetPropertyChangedSignal("AbsolutePosition"), RecalculatePos)
                end

                if Default == nil and Multi then Value = {} end
                if Multi and type(Default) == "table" then
                     Value = {}
                     for _, v in pairs(Default) do Value[v] = true end
                end

                UpdateLabel()
                RefreshList()

                local DropdownObj = {
                    Value = Value,
                    Values = Values,
                    Multi = Multi,
                    Type = "Dropdown",
                    SetValue = function(self, v)
                        Value = v
                        UpdateLabel()
                        RefreshList()
                        if type(EConfig.Callback) == "function" then EConfig.Callback(v) end
                        if type(self.Changed) == "function" then self.Changed(v) end
                    end,
                    SetValues = function(self, newValues)
                        self.Values = newValues or {}
                        Values = self.Values
                        RefreshList()
                    end,
                    OnChanged = function(self, fn)
                        self.Changed = fn
                        fn(Value)
                    end
                }
                -- Fix reference for click handler
                for _, v in pairs(Buttons) do
                     -- Actually the closure in RefreshList needs the variable
                end
                
                -- It's cleaner to just update it globally since the func references the enclosing scope
                _G_DropdownObjRef = DropdownObj -- We will inject it correctly below
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
    local ProtectedParent = game:GetService("CoreGui")

    -- Creates a standalone GUI button to toggle the Window
    local MinimizerScreen = Instance.new("ScreenGui")
    MinimizerScreen.Name = "HeliosMinimizer"
    MinimizerScreen.Parent = ProtectedParent
    
    local Button = Creator.New("ImageButton", {
        Name = "Btn",
        Position = Config.Position or UDim2.new(0, 10, 0, 10),
        Size = Config.Size or UDim2.fromOffset(40, 40),
        Parent = MinimizerScreen,
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Image = Helios:GetIcon(Config.Icon) or "rbxassetid://10709782430",
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

return Helios
