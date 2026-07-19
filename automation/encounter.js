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

// Read the current input line the parser has accumulated (gInputBuffer / gInputBufferPos).
async function inputLen(t) { return (await t.read('gInputBufferPos', 1))[0]; }
// The current input line as text (for diagnostics).
async function inputText(t) {
    const pos = await inputLen(t);
    if (!pos) return '';
    const buf = await t.read('gInputBuffer', Math.min(pos, 40));
    let s = ''; for (let i = 0; i < buf.length; i++) s += String.fromCharCode(buf[i] || 0);
    return s;
}
async function inputEquals(t, want) {
    const pos = await inputLen(t);
    if (pos !== want.length) return false;
    if (want.length === 0) return true;
    const buf = await t.read('gInputBuffer', want.length);
    for (let i = 0; i < want.length; i++) if (buf[i] !== want.charCodeAt(i)) return false;
    return true;
}
// Backspace until the input line is empty (drop any partial/stray characters). Self-correcting:
// re-checks the length each time, so a dropped Backspace just means another pass.
async function clearInput(t) {
    for (let i = 0; i < 45 && (await inputLen(t)) > 0; i++) await t.press('BACKSPACE');
}

// Enter a full command at Encounter's text-adventure prompt and return once it's submitted.
// It hides the parser handshake AND makes input reliable, so callers never think about either:
//   1. wait for the input loop to be READY — a fresh prompt pulses gAskQuestion 0->1
//      (ResetInput) then 1->0 (drawn, now reading, past _WaitReleasedKey). This waits HOWEVER
//      long the game needs, so a multi-second cut-scene before the prompt (e.g. arriving at the
//      marketplace) is fine; the wait is frame-based so it doesn't count while YOU pause.
//   2. type the command, then VERIFY it actually landed in the input buffer before pressing
//      Return — the keyboard uplink can drop a keystroke (no ack). If the buffer doesn't match,
//      clear and retype (up to opts.retries). This is what stops "> DROP PLAN" logging but not
//      registering.
// `cmd` is the command WITHOUT the trailing Return (added here), e.g. 'take bag', 'u', 'bag'.
// NOTE: assumes a fresh prompt is COMING (the normal case — after a move/cut-scene, or right
// after another command submitted). If called while already sitting idle at a prompt (no new
// ResetInput pulse), pass {timeoutFrames} so it errors rather than hangs.
async function command(t, cmd, opts = {}) {
    t.log('> ' + cmd);
    // Sync on the READ LOOP, not the routine entry. _InputCheckKey is jsr'd EVERY iteration of
    // AskInput's inner loop (right before it renders the input cursor), so a one-shot run-to
    // catches it within a frame or two even when we're ALREADY inside AskInput — which is the
    // normal case at a ready prompt. (runTo '_AskInput' only caught the single entry, so it
    // missed once we were already past it — that's what a delay before the command exposed.)
    // It's past ResetInput/_WaitReleasedKey (no settle/first-key-eaten problem) and it's the
    // same loop for the main prompt AND nested container prompts. Override via opts.readSymbol.
    await t.runTo(opts.readSymbol || '_InputCheckKey', opts);
    // Type, VERIFY it landed in the input buffer, retype if a keystroke dropped, then submit.
    const want = String(cmd).toLowerCase();       // the parser lower-cases input
    const retries = opts.retries || 4;
    for (let attempt = 0; attempt < retries; attempt++) {
        await clearInput(t);                       // start from an empty line (drop a prior partial try)
        for (const ch of want) await t.press(ch);  // type the command — no Return yet
        if (await inputEquals(t, want)) { await t.press('RETURN'); return; }
        // Show what actually landed vs what we wanted — the fastest way to see WHY it failed
        // (wrong prompt? dropped chars? clear not working?).
        t.log('  attempt ' + (attempt + 1) + ': buffer="' + (await inputText(t)) + '" want="' + want + '"');
    }
    throw new Error("enc.command('" + cmd + "'): could not enter it reliably — got \"" + (await inputText(t)) + "\", wanted \"" + want + "\"");
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

// NOTE on module navigation: there's deliberately NO gotoModule/ensureGame helper here.
// Overlay navigation is written out explicitly in each script with plain `if` blocks
// (one obvious action per module: Splash -> SPACE, Intro -> ESC, ...) — see example.js.
// That keeps it transparent and editable, and lets a script TEST a module (splash/intro)
// instead of only skipping it. The generic primitives it uses live on `t`:
//   await t.module()                -> the active overlay name ('Splash'/'Intro'/'Game'/...)
//   await t.press('SPACE')          -> send a key
//   await t.waitModuleChange('Splash')  -> wait until we leave that module

module.exports = { command, waitLocation, assertLocation };
