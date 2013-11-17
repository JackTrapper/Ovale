--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2013 Johnny C. Lam

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
--]]--------------------------------------------------------------------

local _, Ovale = ...

do
	local OvaleCondition = Ovale.OvaleCondition
	local OvaleState = Ovale.OvaleState

	local ParseCondition = OvaleCondition.ParseCondition
	local TestValue = OvaleCondition.TestValue

	local auraFound = {}

	--- Get the player's damage multiplier for the given aura at the time the aura was applied on the target.
	-- @name BuffDamageMultiplier
	-- @paramsig number or boolean
	-- @param id The aura spell ID.
	-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
	-- @param number Optional. The number to compare against.
	-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
	--     Defaults to target=player.
	--     Valid values: player, target, focus, pet.
	-- @return The damage multiplier.
	-- @return A boolean value for the result of the comparison.
	-- @see DebuffDamageMultiplier
	-- @usage
	-- if target.DebuffDamageMultiplier(rake) <1 Spell(rake)

	local function BuffDamageMultiplier(condition)
		local auraId, comparator, limit = condition[1], condition[2], condition[3]
		local target, filter, mine = ParseCondition(condition)
		local state = OvaleState.state
		auraFound.snapshot = nil
		auraFound.damageMultiplier = nil
		local start, ending = state:GetAura(target, auraId, filter, mine, auraFound)
		local baseDamageMultiplier = 1
		if auraFound.snapshot and auraFound.snapshot.baseDamageMultiplier then
			baseDamageMultiplier = auraFound.snapshot.baseDamageMultiplier
		end
		local damageMultiplier = auraFound.damageMultiplier or 1
		local value = baseDamageMultiplier * damageMultiplier
		return TestValue(start, ending, value, start, 0, comparator, limit)
	end

	OvaleCondition:RegisterCondition("buffdamagemultiplier", false, BuffDamageMultiplier)
	OvaleCondition:RegisterCondition("debuffdamagemultiplier", false, BuffDamageMultiplier)
end