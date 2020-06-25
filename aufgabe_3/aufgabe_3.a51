$title(Aufgabe 3)
$debug

; Der Prozessor laeuft mit 60.000.000 MHz, also muessen
; um eine Sekunde zu ueberspringen ca. 60.000.000 Zyklen
; ausgefuehrt werden.

; 255 * 255 * 255 = 16.581.375
ITERATOR EQU 255d
	
DSEG AT 40H
	; In diesem Speicher wird die aktuelle Richtung
	; des Systems gespeichert. 1 steht fuer
	; Inkrementieren und 0 fuer Dekrementieren.
	direction: DS 1
		
	; In diesem Speicher wird der aktuelle Zaehler-
	; zustand gespeichert.
	counter: DS 1
		
CSEG AT 0H
ljmp main

ORG 50h
    main:
		ljmp loop

    loop:
		; Anzeigen des aktuellen Counter-standes
		mov P0,counter
		
		; Port 3 in den Akkumulator schrieben
		mov a,P3
		; Bits ausser dem 8. auf 0 setzen.
		ANL a,#10000000b
		
		; Wenn der Taster gedrueckt ist wird die 
		; Richtung geaendert
		jnz toggledirection
		ajmp count
		
	toggledirection:
		; Die aktuelle Richtung in den Akkumulator
		; schreiben
		mov a,direction
		; Das letzte Bit umkehren
		xrl a,#00000001b
		; Zustand des Akkus in direction schreiben
		mov direction,a
		ajmp count
	
	count:
		; Aktuelle Richtung in Akku schreiben
		mov a,direction
		; Wenn Richtung 1 ist > Increment;
		; Wenn Richtung nicht 1 ist > Decrement;
		jnz increment
		ljmp decrement
	
	increment:
		; Counter in Akku schreiben und erhoehen
		mov a,counter
		inc a
		
		; Die ersten 4 Bit auf 0 setzen um 4-Bit 
		; Zaehler-verhalten zu erhalten
		ANL a,#00001111b
		
		; Akkuinhalt wieder in counter schreiben
		mov counter,a
		
		; 1s warten
		ACALL wait
		ACALL wait
		ljmp loop
	
	decrement:
		; Counter in Akku schreiben und erhoehen
		mov a,counter
		dec a
		
		; Die ersten 4 Bit auf 0 setzen um 4-Bit 
		; Zaehler-verhalten zu erhalten
		ANL a,#00FH
		
		; Akkuinhalt wieder in counter schreiben
		mov counter,a
		
		; 1s warten
		ACALL wait
		ACALL wait
		ljmp loop

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