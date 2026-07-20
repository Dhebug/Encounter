'use strict';
/*
 * Example Oric automation script for Encounter.
 *
 * Run it from VS Code: the command "Oric: Run Automation Script…" — pick this file. If no
 * debug session is open it STARTS one for you (the F5 equivalent, using the project's
 * oric-debug launch config) and waits until it's live; an already-running session is reused.
 * It drives the LIVE session, so it plays in the Oric Screen View; progress + pass/fail appear
 * in the "Oric Automation" output channel; screenshots land in automation/out/. Stop it with
 * "Oric: Stop Automation Script".
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

const enc = require('./lib/encounter');   // utility helpers live in automation/lib/ (not standalone scripts)

// How the ▶ Run button gets a session — metadata at the TOP, via the object form:
module.exports = {
    session: 'any',            // reuse the running debug session, else launch one
    config: 'Build & Run',     // when launching, use this config (runs, not paused) — no picker prompt
    // Other choices: session 'existing' (utility — run in the CURRENT session, never launch)
    //                session 'fresh'    (always launch a new emulator; confirm a restart if one runs)
    run,                       // the playthrough (defined below — function declarations hoist)
};

async function run(t) {
    t.log('Starting automated playthrough');
    // await t.warp(true);                       // fast-forward the whole run

    // Let the machine boot until an overlay is actually active — right after a cold F5 the
    // module is briefly unknown (null) until the splash stamps itself. (Skip/shorten this if
    // you always start from an already-running session.)
    t.log('module: ' + await t.waitModuleKnown());

    // Get to the game from wherever we started — explicit, one obvious action per overlay.
    // (Modules: Splash, Intro, Game, Outro, King.) Each `if` re-reads t.module() and, after
    // a skip key, waits for the overlay to actually switch before the next check. Edit freely:
    // e.g. to TEST the intro instead of skipping it, replace its branch with intro checks.
    if (await t.module() === 'Splash') 
    { 
        t.log('In Splash -> Exiting');
        await t.warp(true); 
        await t.press('SPACE'); 
        await t.waitModuleChange('Splash'); 
        await t.warp(false);
    }

    if (await t.module() === 'Outro')  
    { 
        t.log('In Outro -> Exiting');
        await t.press('SPACE'); 
        await t.warp(true); 
        await t.waitModuleChange('Outro'); 
        await t.warp(false);
    }

    if (await t.module() === 'Intro')
    {
        t.log('In Intro -> Exiting');
        // Attract mode samples the keyboard only between pages, so a single press can be
        // missed — MASH each key until the game reacts (press(..., {until}) does exactly that,
        // at normal speed so the press isn't collapsed by warp).
        // 1) ESC until the intro acknowledges and starts the game (gGameStarting -> 1).
        await t.press('ESC', { until: async () => (await t.read('gGameStarting', 1))[0] === 1 || (await t.module()) !== 'Intro' });
        // 2) SPACE until the typewriter intro sequence ends and the Game overlay loads.
        await t.press('SPACE', { until: async () => (await t.module()) !== 'Intro' });
    }

    const mod = await t.module();
    if (mod !== 'Game') 
    {
        throw new Error('Game module not active (in ' + mod + ')');
    }
    else
    {
        t.log('In Game -> skipping the presentation');
        await t.warp(true); 
        await t.waitFor('_gStreamCutScene != 0');
        await t.waitFor('_gStreamCutScene == 0');
        await enc.waitLocation(t, 'e_LOC_MARKETPLACE');
        t.log('Marketplace');
        await t.warp(false);
        //await t.runFrames(250)  
        await enc.command(t, 'TAKE BAG');
        //await t.runFrames(250)  
        await enc.command(t, 'DROP NEWSPAPER');
        //await t.runFrames(250)  
        await enc.command(t, 'DROP PLAN');
        //await t.runFrames(250)  
        await enc.command(t, 'N');
        //await t.runFrames(250)  
        await enc.assertLocation(t, 'In the tunnel?', 'e_LOC_DARKTUNNEL');        
        await enc.command(t, 'TAKE DEPOSIT');
        await enc.command(t, 'BAG');
        await enc.command(t, 'N');
        await enc.assertLocation(t, 'In the forest?', 'e_LOC_WOODEDAVENUE');        
        await enc.command(t, 'W');
        await enc.assertLocation(t, 'The old well?', 'e_LOC_WELL');        
        await enc.command(t, 'TAKE ROPE');
        await enc.command(t, 'E');
        await enc.assertLocation(t, 'In the forest?', 'e_LOC_WOODEDAVENUE');        

        /*
        // --- Game is active: the actual test ------------------------------------------------
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
        */
    }

    // Longer parser commands work the same way, e.g.:
    //   await enc.command(t, 'take bag');
    //   await enc.command(t, 'go north');

    t.log('example playthrough complete');
}
