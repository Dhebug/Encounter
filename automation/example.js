'use strict';
/*
 * Example Oric automation script for Encounter.
 *
 * Run it from VS Code: start a debug session (F5), then run the command
 * "Oric: Run Automation Script…" and pick this file. It drives the LIVE session, so it
 * plays in the Oric Screen View; progress + pass/fail appear in the "Oric Automation"
 * output channel; screenshots land in automation/out/. Stop it with "Oric: Stop Automation Script".
 *
 * A script is:  module.exports = async (t) => { ... }
 * Game-specific building blocks live in ./encounter.js (shared by every script here);
 * the generic `t` API (see osdk-debug/test/README-playthrough.md) is game-agnostic:
 *   await t.waitFor(expr)          wait until a VARIABLE HOLDS A VALUE (value-watch), e.g.
 *                                   waitFor('_gCurrentLocation == e_LOC_ENTRANCEHALL') — stops the
 *                                   instant it holds, no matter HOW it was written (STA/INC/DMA/…).
 *   await t.waitSignal(id)         wait for a logpoint/watchpoint tagged [signal:id] to fire
 *   await t.press(key[, hold])     press a letter ('u') / NAME ('RETURN'/'UP'/'CTRL') / code
 *   await t.type('text')           type a string; '\n' (or '\r') submits the line via RETURN
 *   await t.runFrames(50)          let ~1s of game time pass (50 Hz)
 *   t.read / eval / sym / assertMem / warp / screenshot / log   — see the README for the rest
 *
 * USE REAL NAMES, NOT MAGIC NUMBERS — a C global (_gCurrentLocation), an enum constant
 * (e_LOC_ENTRANCEHALL), a '$hex' or a number; all resolved LIVE from the debug symbols, so
 * the script can't drift the way a hand-copied "const LOC = 0x91" eventually does.
 *
 * The Encounter helpers (enc.*) wrap the game's quirks so scripts read like a walkthrough:
 *   await enc.waitLocation(t, 'e_LOC_ENTRANCEHALL')   wait until we're at a location
 *   await enc.command(t, 'take bag')                  enter a parser command (+ Return), waiting for
 *                                                     the prompt to be ready first (see encounter.js)
 *   await enc.assertLocation(t, label, 'e_LOC_...')   checkpoint the current location
 */

const enc = require('./encounter');

module.exports = async (t) => {
    t.log('Starting automated playthrough');
    // await t.warp(true);                       // fast-forward the whole run

    // Wait until the game sets the starting location, verify it, snapshot the screen.
    await enc.waitLocation(t, 'e_LOC_ENTRANCEHALL');
    await enc.assertLocation(t, 'boots into the entrance', 'e_LOC_ENTRANCEHALL');
    t.screenshot('01-entrance');

    // Climb the stairs — one reusable call: it waits for the parser prompt to be ready,
    // logs the command, and types "u" + Return at a human pace (see enc.command).
    await enc.command(t, 'u');
    await enc.waitLocation(t, 'e_LOC_LARGE_STAIRCASE');
    await enc.assertLocation(t, 'the U command climbs to the staircase', 'e_LOC_LARGE_STAIRCASE');
    t.screenshot('02-staircase');

    // The dog attacks — wait for the game-over flag.
    t.log('Waiting for GameOver');
    await t.waitFor('gGameOverCondition != 0');

    // Longer parser commands work the same way, e.g.:
    //   await enc.command(t, 'take bag');
    //   await enc.command(t, 'go north');

    t.log('example playthrough complete');
};
