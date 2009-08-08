; Data that is to reside on disk


; First SSCs

*=$c000

; You can include ssc files here directly with #include.
; If SSC does not use all the bytes up to a page boundary
; you need to include the .dsb 256-(*&255)
; line, so the next SSC does
; start at a sector boundary

ssc_1
;; SSC #1
.byt 1,1,1,1,1,1,1,1,1,1
.dsb 16000,0
.byt 0,1,2,3,4,5,6,7,8,9
end_scc1

.dsb 256-(*&255)


ssc_2
;; SSC #2
.byt 2,2,2,2,2,2,2,2,2,2
.dsb 16000
.byt 0,1,2,3,4,5,6,7,8,9
end_scc2

.dsb 256-(*&255)

ssc_3

;; SSC #3
.byt 2,2,2,2,2,2,2,2,2,2
.dsb 16000
.byt 1,1,2,3,4,5,6,7,8,9
end_scc3

.dsb 256-(*&255)



; Then you can include here the total load



