
-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Slabhide", "The Stonecore")
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(43214)
mod.toggleOptions = {
	92265, --Crystal Storm
	{80801, "FLASHSHAKE"}, -- Lava Pool
	"bosskill",
}

-------------------------------------------------------------------------------
--  Localization

BCL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	-- Heroic
	self:Log("SPELL_CAST_START", "Storm", 92265)
	self:Log("SPELL_AURA_APPLIED", "StormBegun", 92265)
	-- Normal
	self:Log("SPELL_AURA_APPLIED", "LavaPool", 80801, 92658) -- XXX drycoded, needs testing

	self:Death("Win", 43214)
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Storm(_, spellId, _, _, spellName)
	self:Message(92265, LW_CL["seconds"]:format(spellName, 2.5), "Attention", spellId)
	self:Bar(92265, LW_CL["next"]:format(spellName), 2.5, spellId)
end

function mod:StormBegun(_, spellId, _, _, spellName)
	self:Bar(92265, spellName, 6, spellId)
end

function mod:LavaPool(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(80801, BCL["you"]:format(spellName), "Personal", spellId, "Alarm")
		self:FlashShake(80801)
	end
end
