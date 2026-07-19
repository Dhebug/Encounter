'use strict';
/*
 * Encounter automation helpers — game-specific building blocks shared by every automation
 * script in this folder.
 *
 * Layering: the generic `t` API (osdk-debug's playthrough-core) stays game-agnostic; THIS
 * module knows Encounter's input parser, its locations, etc. Scripts require it:
 *
 *   const enc = require('./encounter');
 *   module.exports = async (t) => {
 *     await enc.waitLocation(t, 'e_LOC_ENTRANCEHALL');
 *     await enc.command(t, 'take bag');
 *     await enc.command(t, 'u');           // climb
 *   };
 *
 * Editing this file takes effect on the NEXT run — the automation runner reloads the whole
 * folder each time, so helpers iterate just like the script.
 */

// Enter a full command at Encounter's text-adventure prompt and return once it's submitted.
// It hides the parser handshake so callers never think about it:
//   1. wait for the input loop to be READY. A fresh prompt pulses gAskQuestion 0->1
//      (ResetInput starts) then 1->0 (prompt drawn, now reading — PAST _WaitReleasedKey, so
//      the first key isn't eaten). We sync on that read-ready edge.
//   2. if no fresh pulse arrives within readyMs, we're already sitting at a ready prompt
//      (nothing will call ResetInput until we type), so just proceed.
//   3. log the command, then type it + Return at the human pace t.type() uses.
// `cmd` is the command text WITHOUT the trailing Return (added here), e.g. 'take bag', 'u'.
async function command(t, cmd, opts = {}) {
    const readyMs = opts.readyMs || 4000;
    t.log('> ' + cmd);
    try {
        await t.waitFor('gAskQuestion != 0', { timeoutMs: readyMs });   // a fresh prompt is appearing
        await t.waitFor('gAskQuestion == 0', { timeoutMs: readyMs });   // ...drawn, input loop now reading
    } catch (_) {
        // No fresh prompt pulse in time → already at a ready prompt. Safe to type as-is.
    }
    await t.type(String(cmd) + '\r');
}

// Wait until the player's current location becomes `loc` (an enum name like
// 'e_LOC_LARGE_STAIRCASE', or a raw value). Thin, readable wrapper over the value-watch.
async function waitLocation(t, loc, opts = {}) {
    return t.waitFor('_gCurrentLocation', loc, opts);
}

// Assert the current location equals `loc` (enum name or value) — for checkpoints.
async function assertLocation(t, label, loc) {
    return t.assertMem(label, '_gCurrentLocation', loc);
}

module.exports = { command, waitLocation, assertLocation };
