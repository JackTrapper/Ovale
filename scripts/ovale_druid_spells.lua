local _, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_druid_spells"
	local desc = "[5.4.7] Ovale: Druid spells"
	local code = [[
# Druid spells and functions.
#	Last updated: 2014-04-24

Define(barkskin 22812)
	SpellInfo(barkskin cd=60)
	SpellInfo(barkskin addcd=-15 if_spell=malfurions_gift)
Define(berserk_cat 106951)
	SpellInfo(berserk_cat cd=180)
	SpellAddBuff(berserk_cat berserk_cat_buff=1)
Define(berserk_cat_buff 106951)
	SpellInfo(berserk_cat duration=15)
Define(cat_form 768)
Define(celestial_alignment 112071)
	SpellInfo(celestial_alignment cd=180)
	SpellAddBuff(celestial_alignment celestial_alignment_buff=1)
Define(celestial_alignment_buff 112071)
	SpellInfo(celestial_alignment_buff duration=15)
Define(cenarion_ward 102351)
	SpellInfo(cenarion_ward cd=30)
Define(cenarion_ward_talent 6)
Define(chosen_of_elune_buff 102560)
	SpellInfo(chosen_of_elune_buff duration=30)
Define(dash 1850)
	SpellInfo(dash cd=180)
	SpellInfo(dash addcd=-60 glyph=glyph_of_dash)
Define(displacer_beast 102280)
	SpellInfo(displacer_beast cd=30)
Define(displacer_beast_talent 2)
Define(dream_of_cenarius_caster_buff 145151)
	SpellInfo(dream_of_cenarius_caster_buff duration=30)
Define(dream_of_cenarius_melee_buff 145152)
	SpellInfo(dream_of_cenarius_melee_buff duration=30)
Define(dream_of_cenarius_talent 17)
Define(faerie_fire 770)
	SpellInfo(faerie_fire cd=6 if_stance=druid_bear_form)
	SpellInfo(faerie_fire cd=6 if_stance=druid_cat_form)
	SpellInfo(faerie_fire cd=15 glyph=glyph_of_fae_silence if_stance=druid_bear_form)
	SpellAddTargetDebuff(faerie_fire weakened_armor_debuff=3)
Define(faerie_swarm 102355)
	SpellInfo(faerie_swarm cd=6 if_stance=druid_bear_form)
	SpellInfo(faerie_swarm cd=6 if_stance=druid_cat_form)
	SpellInfo(faerie_swarm cd=15 glyph=glyph_of_fae_silence if_stance=druid_bear_form)
	SpellAddTargetDebuff(faerie_swarm weakened_armor_debuff=3)
Define(faerie_swarm_talent 7)
Define(feral_fury_buff 48848)
	SpellInfo(feral_fury_buff duration=6)
Define(feral_rage_buff 146874)
	SpellInfo(feral_rage_buff duration=20)
Define(ferocious_bite 22568)
	SpellInfo(ferocious_bite combo=finisher energy=25 physical=1)
	SpellInfo(ferocious_bite buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(ferocious_bite buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellInfo(ferocious_bite damage=FeralFerociousBiteDamage mastery=feral)
	SpellAddBuff(ferocious_bite omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(force_of_nature_caster 33831)
	SpellInfo(force_of_nature_caster gcd=0)
Define(force_of_nature_melee 102703)
	SpellInfo(force_of_nature_melee gcd=0)
Define(force_of_nature_talent 12)
Define(glyph_of_dash 59219)
Define(glyph_of_fae_silence 114237)
Define(glyph_of_might_of_ursoc 116238)
Define(glyph_of_savagery 127540)
Define(glyph_of_skull_bash 116216)
Define(glyph_of_survival_instincts 114223)
Define(healing_touch 5185)
	SpellAddBuff(healing_touch dream_of_cenarius_caster_buff=1 talent=dream_of_cenarius_talent)
	SpellAddBuff(healing_touch predatory_swiftness_buff=0 )
Define(heart_of_the_wild 108292)
	SpellInfo(heart_of_the_wild cd=360)
Define(heart_of_the_wild_talent 16)
Define(hurricane 16914)
	SpellInfo(hurricane canStopChannelling=10 duration=10 haste=spell tick=1)
Define(incarnation 106731)
	SpellInfo(incarnation cd=180)
Define(incarnation_talent 11)
Define(king_of_the_jungle_buff 102543)
	SpellInfo(king_of_the_jungle_buff duration=30)
Define(lunar_eclipse_buff 48518)
Define(maim 22570)
	SpellInfo(maim cd=10 combo=finisher energy=35 physical=1)
	SpellInfo(maim buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(maim buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellAddBuff(maim omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(malfurions_gift 92364)
Define(mangle_cat 33876)
	SpellInfo(mangle_cat combo=1 energy=35 physical=1)
	SpellInfo(mangle_cat critcombo=1 if_spell=primal_fury)
	SpellInfo(mangle_cat buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(mangle_cat buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellInfo(mangle_cat damage=FeralMangleCatDamage mastery=feral)
	SpellAddBuff(mangle_cat omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(mark_of_the_wild 1126)
Define(might_of_ursoc 106922)
	SpellInfo(might_of_ursoc cd=180)
	SpellInfo(might_of_ursoc addcd=120 glyph=glyph_of_might_of_ursoc)
	SpellInfo(might_of_ursoc addcd=-60 itemset=T14_tank itemcount=2)
Define(mighty_bash 5211)
	SpellInfo(mighty_bash cd=50)
Define(mighty_bash_talent 15)
Define(moonfire 8921)
	SpellAddTargetDebuff(moonfire moonfire_debuff=1)
Define(moonfire_debuff 8921)
	SpellInfo(moonfire_debuff duration=14 haste=spell tick=2)
	SpellInfo(moonfire_debuff addduration=2 itemset=T14_caster itemcount=4)
Define(moonkin_form 24858)
Define(natures_grace_buff 16886)
	SpellInfo(natures_grace_buff duration=15)
Define(natures_swiftness 132158)
	SpellInfo(natures_swiftness cd=60)
Define(natures_vigil 124974)
	SpellInfo(natures_vigil cd=90)
Define(natures_vigil_talent 18)
Define(omen_of_clarity 16864)
Define(omen_of_clarity_buff 135700)
	SpellInfo(omen_of_clarity_buff duration=15)
Define(predatory_swiftness_buff 69369)
	SpellInfo(predatory_swiftness_buff duration=8)
Define(prowl 5215)
Define(rake 1822)
	SpellInfo(rake combo=1 energy=35 physical=1)
	SpellInfo(rake critcombo=1 if_spell=primal_fury)
	SpellInfo(rake buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(rake buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellAddBuff(rake omen_of_clarity_buff=0 if_spell=omen_of_clarity)
	SpellAddTargetDebuff(rake rake_debuff=1)
Define(rake_debuff 1822)
	SpellInfo(rake_debuff duration=15 tick=3)
	SpellInfo(rake_debuff damage=FeralRakeTickDamage mastery=feral)
	SpellInfo(rake_debuff lastEstimatedDamage=FeralRakeTickLastDamage mastery=feral)
	SpellDamageBuff(rake_debuff dream_of_cenarius_melee_buff=1.3)
Define(ravage 6785)
	SpellInfo(ravage combo=1 energy=45 physical=1)
	SpellInfo(ravage critcombo=1 if_spell=primal_fury)
	SpellInfo(ravage buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(ravage buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellInfo(ravage damage=FeralRavageDamage mastery=feral)
	SpellAddBuff(ravage omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(renewal 108238)
	SpellInfo(renewal cd=120)
Define(renewal_talent 5)
Define(rip 1079)
	SpellInfo(rip combo=finisher energy=30)
	SpellAddTargetDebuff(rip rip_debuff=1)
	SpellInfo(rip buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(rip buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellAddBuff(rip omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(rip_debuff 1079)
	SpellInfo(rip_debuff duration=16 resetcounter=ripshreds tick=2)
	SpellInfo(rip_debuff addduration=4 itemset=T14_melee itemcount=4)
	SpellInfo(rip_debuff base=14.125 bonuscp=40 bonusapcp=0.0484)
	SpellInfo(rip_debuff damage=FeralRipTickDamage mastery=feral)
	SpellInfo(rip_debuff lastEstimatedDamage=FeralRipTickLastDamage mastery=feral)
	SpellDamageBuff(rip_debuff dream_of_cenarius_damage_buff=1.3)
Define(rune_of_reorigination_buff 139120)
	SpellInfo(rune_of_reorigination_buff duration=10)
Define(savage_roar 52610)
	SpellInfo(savage_roar combo=finisher energy=25 min_combo=1)
	SpellInfo(savage_roar duration=12 adddurationcp=6)
	SpellInfo(savage_roar buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(savage_roar buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellAddBuff(savage_roar savage_roar=1)
	SpellAddBuff(savage_roar omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(savage_roar_glyphed 127538)
	SpellInfo(savage_roar_glyphed combo=finisher energy=25)
	SpellInfo(savage_roar_glyphed duration=12 adddurationcp=6)
	SpellInfo(savage_roar_glyphed buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(savage_roar_glyphed buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellAddBuff(savage_roar_glyphed savage_roar_glyphed=1)
	SpellAddBuff(savage_roar_glyphed omen_of_clarity_buff=0 if_spell=omen_of_clarity)
SpellList(savage_roar_buff savage_roar savage_roar_glyphed)
Define(shred 5221)
	SpellInfo(shred combo=1 energy=40 physical=1)
	SpellInfo(shred critcombo=1 if_spell=primal_fury)
	SpellInfo(shred buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(shred buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellInfo(shred damage=FeralShredDamage mastery=feral)
	SpellAddBuff(shred omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(shooting_stars_buff 93400)
	SpellInfo(shooting_stars_buff duration=12)
Define(skull_bash_cat 80965)
	SpellInfo(skull_bash_cat cd=15)
	SpellInfo(skull_bash_cat addcd=5 glyph=glyph_of_skull_bash)
Define(solar_beam 78675)
	SpellInfo(solar_beam cd=60)
Define(solar_eclipse_buff 48517)
Define(starfall 48505)
	SpellInfo(starfall cd=90)
	SpellAddBuff(starfall starfall_buff=1)
Define(starfall_buff 48505)
	SpellInfo(starfall_buff duration=10)
Define(starfire 2912)
	SpellInfo(starfire eclipse=20)
Define(starsurge 78674)
	SpellInfo(starsurge cd=15 eclipse=20 eclipsedir=1)
	SpellAddBuff(starsurge shooting_stars_buff=0)
Define(sunfire 93402)
	SpellAddTargetDebuff(sunfire sunfire_debuff=1)
Define(sunfire_debuff 93402)
	SpellInfo(sunfire_debuff duration=14 haste=spell tick=2)
	SpellInfo(sunfire addduration=2 itemset=T14_caster itemcount=4)
Define(survival_instincts 61336)
	SpellInfo(survival_instincts cd=180)
	SpellInfo(survival_instincts addcd=-60 glyph=glyph_of_survival_instincts)
	SpellAddBuff(survival_instincts survival_instincts=1)
Define(swipe_cat 62078)
	SpellInfo(swipe_cat combo=1 energy=45 physical=1)
	SpellInfo(swipe_cat buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(swipe_cat buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellInfo(swipe_cat damage=FeralSwipeCatDamage mastery=feral)
	SpellAddBuff(swipe_cat omen_of_clarity_buff=0 if_spell=omen_of_clarity)
Define(symbiosis_mirror_image 110621)
	SpellInfo(symbiosis_mirror_image cd=180)
Define(thrash_cat 106830)
	SpellInfo(thrash_cat energy=50 physical=1)
	SpellInfo(thrash_cat buff_energy_half=berserk_cat_buff if_stance=druid_cat_form)
	SpellInfo(thrash_cat buff_energy_none=omen_of_clarity_buff if_spell=omen_of_clarity)
	SpellInfo(thrash_cat damage=FeralThrashCatDamage mastery=feral)
	SpellAddBuff(thrash_cat omen_of_clarity_buff=0 if_spell=omen_of_clarity)
	SpellAddTargetDebuff(thrash_cat thrash_cat_debuff=1)
Define(thrash_cat_debuff 106830)
	SpellInfo(thrash_cat_debuff duration=15 tick=3 physical=1)
Define(tigers_fury 5217)
	SpellInfo(tigers_fury cd=30 energy=-60)
	SpellAddBuff(tigers_fury tigers_fury_buff=1)
Define(tigers_fury_buff 5217)
	SpellInfo(tigers_fury duration=6)
Define(tranquility 740)
	SpellInfo(tranquility canStopChannelling=4 cd=480 duration=8 haste=spell tick=2)
	SpellInfo(tranquility cd=180 if_spell=malfurions_gift)
Define(typhoon 132469)
	SpellInfo(typhoon cd=30)
Define(typhoon_talent 9)
Define(weakened_armor_debuff 113746)
	SpellInfo(weakened_armor_debuff duration=30)
Define(wild_charge 102401)
	SpellInfo(wild_charge cd=15)
Define(wild_charge_bear 16979)
	SpellInfo(wild_charge_bear cd=15)
Define(wild_charge_cat 49376)
	SpellInfo(wild_charge_cat cd=15)
Define(wild_charge_moonkin 102383)
	SpellInfo(wild_charge_moonkin cd=15)
Define(wild_charge_talent 3)
Define(wild_mushroom_caster 88747)
	SpellInfo(wild_mushroom_caster gcd=1)
Define(wild_mushroom_detonate 88751)
	SpellInfo(wild_mushroom_detonate cd=10 gcd=0)
Define(wrath 5176)
	SpellInfo(wrath eclipse=-15)

AddFunction FaerieFire
{
	if TalentPoints(faerie_swarm_talent) Spell(faerie_swarm)
	if not TalentPoints(faerie_swarm_talent) Spell(faerie_fire)
}

AddFunction SavageRoar
{
    if Glyph(glyph_of_savagery) Spell(savage_roar_glyphed)
    if Glyph(glyph_of_savagery no) and ComboPoints() >0 Spell(savage_roar)
}

AddFunction BalanceInterrupt
{
	if not target.IsFriend() and target.IsInterruptible()
	{
		if not target.Classification(worldboss)
		{
			if TalentPoints(mighty_bash_talent) and target.InRange(mighty_bash) Spell(mighty_bash)
			if TalentPoints(typhoon_talent) Spell(typhoon)
			Spell(solar_beam)
		}
	}
}

AddFunction FeralInterrupt
{
	if not target.IsFriend() and target.IsInterruptible()
	{
		if target.InRange(skull_bash_cat) Spell(skull_bash_cat)
		if not target.Classification(worldboss)
		{
			if TalentPoints(mighty_bash_talent) and target.InRange(mighty_bash) Spell(mighty_bash)
			if TalentPoints(typhoon_talent) and target.InRange(skull_bash_cat) Spell(typhoon)
			if ComboPoints() > 0 and target.InRange(maim) Spell(maim)
		}
	}
}

AddFunction FeralMasteryDamageMultiplier asValue=1 { 1 + MasteryEffect() / 100 }

### Ferocious Bite.
AddFunction FeralFerociousBiteDamage asValue=1
{
	# The "2" at the end is from assuming that FB is always cast at 50 energy, with the extra 25 energy
	# increasing damage by 100%.
	{ 500 + { 762 + 0.196 * AttackPower() } * ComboPoints() } * target.DamageMultiplier(ferocious_bite) * 2
}

### Mangle (cat).
AddFunction FeralMangleCatDamage asValue=1
{
	{ 78 + WeaponDamage() } * 5 * target.DamageMultiplier(mangle_cat)
}

### Rake.
AddFunction FeralRakeTickDamage asValue=1
{
	{ 99 + 0.3 * AttackPower() } * target.DamageMultiplier(rake_debuff) * FeralMasteryDamageMultiplier()
}
AddFunction FeralRakeTickLastDamage asValue=1
{
	{ 99 + 0.3 * target.DebuffAttackPower(rake_debuff) } * target.DebuffDamageMultiplier(rake_debuff) * { 1 + target.DebuffMasteryEffect(rake_debuff) / 100 }
}

### Ravage
AddFunction FeralRavageDamage asValue=1
{
	{ 78 + WeaponDamage() } * 9.5 * target.DamageMultiplier(ravage)
}

### Rip.
AddFunction FeralRipTickDamage asValue=1
{
	{ 136 + { { 384 + 0.05808 * AttackPower() } * ComboPoints() } } * target.DamageMultiplier(rip_debuff) * FeralMasteryDamageMultiplier()
}
AddFunction FeralRipTickLastDamage asValue=1
{
	{ 136 + { { 384 + 0.05808 * target.DebuffAttackPower(rip_debuff) } * target.DebuffComboPoints(rip_debuff) } } * target.DebuffDamageMultiplier(rip_debuff) * { 1 + target.DebuffMasteryEffect(rip_debuff) / 100 }
}

### Shred.
AddFunction FeralShredDamage asValue=1
{
	# The "1.2" at the end is from assuming that Shred is only cast against bleeding targets.
	FeralMangleCatDamage() * 1.2
}

### Swipe (cat)
AddFunction FeralSwipeCatDamage asValue=1
{
	# The "1.2" at the end is from assuming that Swipe is only cast against bleeding targets (usually with Thrash debuff)
	WeaponDamage() * 1.4 * target.DamageMultiplier(swipe_cat) * 1.2
}

### Thrash (cat)
AddFunction FeralThrashCatHitDamage asValue=1
{
	{ 1232 + 0.191 * AttackPower() } * target.DamageMultiplier(thrash_cat) * FeralMasteryDamageMultiplier()
}
]]

	OvaleScripts:RegisterScript("DRUID", name, desc, code, "include")
end