local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Aimbot", HidePremium = false, SaveConfig = false})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Drawing = Drawing or {}

local aimbotEnabled = false
local aimAssistEnabled = false
local FOV_RADIUS = 120
local aimAssistRange = 25

-- Get closest player within FOV
local function getClosestPlayer()
    local closest, shortest = nil, FOV_RADIUS
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        if aimbotEnabled then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
        if aimAssistEnabled then
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if dist < aimAssistRange then
                    local dir = (head.Position - Camera.CFrame.Position).Unit
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir), 0.2)
                end
            end
        end
    end
end)

local devTab = Window:MakeTab({Name = "dev", Icon = "rbxassetid://4483345998", PremiumOnly = false})
devTab:AddLabel("Made By Madara")
devTab:AddParagraph("Features", [[
- AimBot: locks camera on enemy's head
- Aim Assist: smooth tracking when close
- FOV circle is available in future updates
]])

local ctrlTab = Window:MakeTab({Name = "Controls", Icon = "rbxassetid://4483345998", PremiumOnly = false})
ctrlTab:AddToggle({Name = "Enable Aimbot", Default = false, Callback = function(val) aimbotEnabled = val end})
ctrlTab:AddToggle({Name = "Enable Aim Assist", Default = false, Callback = function(val) aimAssistEnabled = val end})

OrionLib:Init()
