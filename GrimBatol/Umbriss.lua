-- XXX Ulic: Other suggestions?

-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("General Umbriss", "Grim Batol")
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(39625)
mod.toggleOptions = {
	{74670, "ICON"}, -- Blitz
	74853, -- Frenzy
	91937, -- Wound
	"bosskill",
}

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then
--@do-not-package@
L["frenzy_trigger"] = "%s goes into a frenzy!"--@localization(locale="enUS", namespace="GrimBatol/Umbriss", format="lua_additive_table", handle-unlocalized="ignore")@
end
L = mod:GetLocale()

local LCL = LibStub("AceLocale-3.0"):GetLocale("Little Wigs: Common")

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")

	self:Log("SPELL_AURA_APPIED", "Wound", 74846, 91937)
	self:Log("SPELL_AURA_REMOVED", "WoundRemoved", 74846, 91937)
	
	self:Death("Win", 39625)
end

function mod:VerifyEnable()
	if not UnitInVehicle("player") then return true end
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, player)
	if msg == L["frenzy_trigger"] then
		self:Message(74853, msg:format(self.displayName), "Attention", 74853)
	else
		self:TargetMessage(74670, GetSpellInfo(74670), player, "Urgent", 74670, "Alert")
		self:PrimaryIcon(74670, player)
		self:ScheduleTimer("clearIcon", 3.5)
	end
end

function mod:UNIT_HEALTH(event, unit)
	if GetUnitName(unit) == self.displayName then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp < 36 then
			self:Message(74853, LCL["soon"]:format(GetSpellInfo(74853)), "Attention", 74853, "Info")
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

function mod:Wound(player, spellId, _, _, spellName)
	self:Message(91937, spellName..": "..player, "Urgent", spellId)
	self:Bar(91937, player..": "..spellName, 15, spellId)
end

function mod:WoundRemoved(player, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, player..": "..spellName)
end

function mod:clearIcon()
	self:PrimaryIcon(74670)
end