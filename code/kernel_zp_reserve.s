; This file must be listed first in each module's OSDKFILE_* list.
;
; Its only purpose is to advance the zero page pointer past the kernel's
; variables so the module's own ZP allocations don't collide with them.
; _KernelZeroPageEnd is provided by Link65 -S (imported from symbols_Kernel).
;
; Note: header.s (the CRT startup) is implicitly prepended by make.bat
; before all user files, so any .text code placed here is dead code:
; the CRT jumps directly to _main and never falls through here.

    .zero

    * = _KernelZeroPageEnd

    .text
