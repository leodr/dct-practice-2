$title(Aufgabe 2)
$debug
	
; Der Prozessor laeuft mit 60.000.000 MHz, also muessen
; um eine Sekunde zu ueberspringen ca. 60.000.000 Zyklen
; ausgefuehrt werden.

; 255 * 255 * 255 = 16.581.375
ITERATION EQU 255d

CSEG AT 0H
ljmp main

ORG 50h
    main:
		; Port 0 zuruecksetzen
		mov P0,#000H
		
		; Wird dieses Byte in eine Richtung rotiert,
		; wechselt der Status des 1. Bit stetig zwischen
		; 0 und 1.
		mov r5,#10101010b
		ljmp loop

    loop:
		; Da jeder Aufruf von wait ca. 0,5 Sekunden
		; dauert rufen wir wait 2 mal auf, um 1 Sekunde
		; zu warten.
		ACALL wait
		ACALL wait
		
		; Byte vom Register holen und rotieren
		mov a,r5
		RL a
		mov r5,a
		
		; Alle Bit ausser dem letzten auf 0 setzen
		ANL a,#00000001b
		
		; Rotiertes 1. Bit auf Port 0 schreiben
		mov P0,a
		
		; Endlosschleife aufrufen
		ajmp loop

	; Jede Schleife laeuft 255 mal, jedes djnz statement
	; benoetigt 2 Zyklen. Also dauert jeder Aufruf von
	; wait ca. 30.000.000 Zyklen (ca. 0,5 Sekunden)
    wait:
        mov r3, ITERATION
        Wait3:
            mov r2, ITERATION
            Wait2:
                mov r1, ITERATION
                Wait1:
                    djnz r1, Wait1
				djnz r2, Wait2
			djnz r3, Wait3
		RET
END