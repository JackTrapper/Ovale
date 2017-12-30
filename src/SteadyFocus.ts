import { OvaleDebug } from "./Debug";
import { OvaleProfiler } from "./Profiler";
import { Ovale } from "./Ovale";
import { OvaleAura } from "./Aura";
import { OvaleSpellBook } from "./SpellBook";
import { OvaleState } from "./State";
import aceEvent from "@wowts/ace_event-3.0";
import { GetTime } from "@wowts/wow-mock";
import { huge } from "@wowts/math";
import { SpellCast } from "./LastSpell";

export let OvaleSteadyFocus: OvaleSteadyFocusClass;

let INFINITY = huge;
let self_playerGUID = undefined;
let PRE_STEADY_FOCUS = 177667;
let STEADY_FOCUS_TALENT = 10;
let STEADY_FOCUS = 177668;
let STEADY_FOCUS_DURATION = 15;
let STEADY_SHOT = {
    [56641]: "Steady Shot",
    [77767]: "Cobra Shot",
    [163485]: "Focusing Shot"
}
let RANGED_ATTACKS = {
    [2643]: "Multi-Shot",
    [3044]: "Arcane Shot",
    [19434]: "Aimed Shot",
    [19801]: "Tranquilizing Shot",
    [53209]: "Chimaera Shot",
    [53351]: "Kill Shot",
    [109259]: "Powershot",
    [117050]: "Glaive Toss",
    [120360]: "Barrage",
    [120361]: "Barrage",
    [120761]: "Glaive Toss",
    [121414]: "Glaive Toss"
}

class SteadyFocusData {
    start = 0;
    ending = 0;
    duration = INFINITY;
    stacks = 0;
}

let OvaleSteadyFocusBase = OvaleState.RegisterHasState(OvaleDebug.RegisterDebugging(OvaleProfiler.RegisterProfiling(Ovale.NewModule("OvaleSteadyFocus", aceEvent))), SteadyFocusData);

class OvaleSteadyFocusClass extends OvaleSteadyFocusBase {
    hasSteadyFocus = undefined;
    spellName = "Pre-Steady Focus";
    spellId = PRE_STEADY_FOCUS;
    
    OnInitialize() {
        if (Ovale.playerClass == "HUNTER") {
            self_playerGUID = Ovale.playerGUID;
            this.RegisterMessage("Ovale_TalentsChanged");
        }
    }
    OnDisable() {
        if (Ovale.playerClass == "HUNTER") {
            this.UnregisterMessage("Ovale_TalentsChanged");
        }
    }
    UNIT_SPELLCAST_SUCCEEDED(event, unitId, spell, rank, lineId, spellId) {
        if (unitId == "player") {
            this.StartProfiling("OvaleSteadyFocus_UNIT_SPELLCAST_SUCCEEDED");
            if (STEADY_SHOT[spellId]) {
                this.DebugTimestamp("Spell %s (%d) successfully cast.", spell, spellId);
                if (this.current.stacks == 0) {
                    let now = GetTime();
                    this.GainedAura(now);
                }
            } else if (RANGED_ATTACKS[spellId] && this.current.stacks > 0) {
                let now = GetTime();
                this.DebugTimestamp("Spell %s (%d) successfully cast.", spell, spellId);
                this.LostAura(now);
            }
            this.StopProfiling("OvaleSteadyFocus_UNIT_SPELLCAST_SUCCEEDED");
        }
    }
    Ovale_AuraAdded(event, timestamp, target, auraId, caster) {
        if (this.current.stacks > 0 && auraId == STEADY_FOCUS && target == self_playerGUID) {
            this.DebugTimestamp("Gained Steady Focus buff.");
            this.LostAura(timestamp);
        }
    }
    Ovale_TalentsChanged(event) {
        this.hasSteadyFocus = (OvaleSpellBook.GetTalentPoints(STEADY_FOCUS_TALENT) > 0);
        if (this.hasSteadyFocus) {
            this.Debug("Registering event handlers to track Steady Focus.");
            this.RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
            this.RegisterMessage("Ovale_AuraAdded");
            this.RegisterMessage("Ovale_AuraChanged", "Ovale_AuraAdded");
        } else {
            this.Debug("Unregistering event handlers to track Steady Focus.");
            this.UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
            this.UnregisterMessage("Ovale_AuraAdded");
            this.UnregisterMessage("Ovale_AuraChanged");
        }
    }
    GainedAura(atTime) {
        this.StartProfiling("OvaleSteadyFocus_GainedAura");
        this.current.start = atTime;
        this.current.ending = this.current.start + this.current.duration;
        this.current.stacks = this.current.stacks + 1;
        this.Debug("Gaining %s buff at %s.", this.spellName, atTime);
        OvaleAura.GainedAuraOnGUID(self_playerGUID, this.current.start, this.spellId, self_playerGUID, "HELPFUL", undefined, undefined, this.current.stacks, undefined, this.current.duration, this.current.ending, undefined, this.spellName, undefined, undefined, undefined);
        this.StopProfiling("OvaleSteadyFocus_GainedAura");
    }
    LostAura(atTime) {
        this.StartProfiling("OvaleSteadyFocus_LostAura");
        this.current.ending = atTime;
        this.current.stacks = 0;
        this.Debug("Losing %s buff at %s.", this.spellName, atTime);
        OvaleAura.LostAuraOnGUID(self_playerGUID, atTime, this.spellId, self_playerGUID);
        this.StopProfiling("OvaleSteadyFocus_LostAura");
    }
    DebugSteadyFocus() {
        let aura = OvaleAura.GetAuraByGUID(self_playerGUID, this.spellId, "HELPFUL", true, undefined);
        if (aura) {
            this.Print("Player has pre-Steady Focus aura with start=%s, end=%s, stacks=%d.", aura.start, aura.ending, aura.stacks);
        } else {
            this.Print("Player has no pre-Steady Focus aura!");
        }
    }

    CleanState(): void {
    }
    InitializeState(): void {
    }
    ResetState(): void {
    }
    ApplySpellAfterCast(spellId, targetGUID, startCast, endCast, channel, spellcast: SpellCast) {
        if (OvaleSteadyFocus.hasSteadyFocus) {
            OvaleSteadyFocus.StartProfiling("OvaleSteadyFocus_ApplySpellAfterCast");
            if (STEADY_SHOT[spellId]) {
                let aura = OvaleAura.GetAuraByGUID(self_playerGUID, OvaleSteadyFocus.spellId, "HELPFUL", true, endCast);
                if (OvaleAura.IsActiveAura(aura, endCast)) {
                    OvaleAura.RemoveAuraOnGUID(self_playerGUID, OvaleSteadyFocus.spellId, "HELPFUL", true, endCast);
                    aura = OvaleAura.GetAuraByGUID(self_playerGUID, STEADY_FOCUS, "HELPFUL", true, endCast);
                    if (!aura) {
                        aura = OvaleAura.AddAuraToGUID(self_playerGUID, STEADY_FOCUS, self_playerGUID, "HELPFUL", undefined, endCast, undefined, endCast, spellcast);
                    }
                    aura.start = endCast;
                    aura.duration = STEADY_FOCUS_DURATION;
                    aura.ending = endCast + STEADY_FOCUS_DURATION;
                    aura.gain = endCast;
                } else {
                    let ending = endCast + this.current.duration;
                    aura = OvaleAura.AddAuraToGUID(self_playerGUID, OvaleSteadyFocus.spellId, self_playerGUID, "HELPFUL", undefined, endCast, ending, endCast, spellcast);
                    aura.name = OvaleSteadyFocus.spellName;
                }
            } else if (RANGED_ATTACKS[spellId]) {
                OvaleAura.RemoveAuraOnGUID(self_playerGUID, OvaleSteadyFocus.spellId, "HELPFUL", true, endCast);
            }
            OvaleSteadyFocus.StopProfiling("OvaleSteadyFocus_ApplySpellAfterCast");
        }
    }
}

OvaleSteadyFocus = new OvaleSteadyFocusClass();
OvaleState.RegisterState(OvaleSteadyFocus);
