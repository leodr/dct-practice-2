$title(Aufgabe 4)
$debug
	
; Der Prozessor laeuft mit 60.000.000 MHz, also muessen
; um eine Sekunde zu ueberspringen ca. 60.000.000 Zyklen
; ausgefuehrt werden.

; 255 * 255 * 255 = 16.581.375
ITERATOR EQU 255d

DSEG AT 30H
	; 7 Byte reservieren um ASCII-Codes der
	; 7 verschiedenen Zeichen zu speichern
	field: DS 7
	stack: DS 10

CSEG AT 0H
	ljmp startup

ORG 50H
    startup:
		mov sp,#stack
		CLR EA
		ajmp main

    main:
		; field-Bereich mit ASCII-Codes bestuecken
		ACALL write
		jmp mloop

    mloop:
		; Register 0 auf erste Adressen der field
		; Bereiches zuruecksetzen
		mov r0,#field
		
		; read-Loop aufrufen um Zeichenfolge einmal
		; durchzugehen
		ACALL read
		
		; Endlosschleife
		jmp mloop

    read:
		; 1s warten (jeweils 0,5 Sekunden)
		acall wait
		acall wait
		
		; Inhalt des Zeichensatzes in Port 0 schreiben,
		; auf die der Inhalt von Register 0 gerade
		; zeigt.
		mov p0,@r0
		
		; Wert in Register 0 erhoehren
		INC r0
		
		; Solange Register 0 nicht letztes Feld von field
		; erreicht, wiederholen.
		cjne r0,#037h,read
		RET

    write:
		mov r1,#field
		; ASCII-Darstellung der Zahl 1
		mov @r1,#1d
		INC r1
		
		; ASCII-Darstellung der Zahl 2
		mov @r1,#2d
		INC r1
		
		; ASCII-Darstellung der Zahl 4
		mov @r1,#4d
		INC r1
		
		; ASCII-Darstellung der Zahl 8
		mov @r1,#8d
		INC r1
		
		; ASCII-Darstellung des Buchstaben 'a'
		mov @r1,#97d
		INC r1
		
		; ASCII-Darstellung des Buchstaben 'b'
		mov @r1,#98d
		INC r1
		
		; ASCII-Darstellung des Buchstaben 'c'
		mov @r1,#99d
		RET

	; Jede Schleife laeuft 255 mal, jedes djnz statement
	; benoetigt 2 Zyklen. Also dauert jeder Aufruf von
	; wait ca. 30.000.000 Zyklen (ca. 0,5 Sekunden)
    wait:
        mov r3, ITERATOR
        Wait3:
            mov r2, ITERATOR
            Wait2:
                mov r1, ITERATOR
                Wait1:
                    djnz r1, Wait1
                    djnz r2, Wait2
                    djnz r3, Wait3
    RET

END