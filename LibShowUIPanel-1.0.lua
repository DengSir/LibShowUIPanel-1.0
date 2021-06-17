-- LibShowUIPanel-1.0.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 6/15/2021, 11:20:01 PM
--
local MAJOR, MINOR = 'LibShowUIPanel-1.0', 2

---@class LibShowUIPanel-1.0
local Lib = LibStub:NewLibrary(MAJOR, MINOR)
if not Lib then
    return
end

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    Lib.ShowUIPanel = ShowUIPanel
    Lib.HideUIPanel = HideUIPanel
else

    local ShowUIPanel = ShowUIPanel
    local HideUIPanel = HideUIPanel

    local InCombatLockdown = InCombatLockdown

    local Delegate = (function()
        local frame = EnumerateFrames()
        while frame do
            if frame.SetUIPanel and issecurevariable(frame, 'SetUIPanel') then
                return frame
            end
            frame = EnumerateFrames(frame)
        end
    end)()

    local function GetUIPanelWindowInfo(frame, name)
        if not frame:GetAttribute('UIPanelLayout-defined') then
            local info = UIPanelWindows[frame:GetName()]
            if not info then
                return
            end
            frame:SetAttribute('UIPanelLayout-defined', true)
            for k, v in pairs(info) do
                frame:SetAttribute('UIPanelLayout-' .. k, v)
            end
        end
        return frame:GetAttribute('UIPanelLayout-' .. name)
    end

    function Lib.ShowUIPanel(frame, force)
        if not InCombatLockdown() then
            return ShowUIPanel(frame)
        end

        if not frame or frame:IsShown() then
            return
        end

        if not GetUIPanelWindowInfo(frame, 'area') then
            frame:Show()
            return
        end

        Delegate:SetAttribute('panel-force', force)
        Delegate:SetAttribute('panel-frame', frame)
        Delegate:SetAttribute('panel-show', true)
    end

    function Lib.HideUIPanel(frame, skipSetPoint)
        if not InCombatLockdown() then
            return HideUIPanel(frame)
        end

        if not frame or not frame:IsShown() then
            return
        end

        if not GetUIPanelWindowInfo(frame, 'area') then
            frame:Hide()
            return
        end

        Delegate:SetAttribute('panel-frame', frame)
        Delegate:SetAttribute('panel-skipSetPoint', skipSetPoint)
        Delegate:SetAttribute('panel-hide', true)
    end
end
