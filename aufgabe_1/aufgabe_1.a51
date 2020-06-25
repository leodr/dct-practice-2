$title(Aufgabe 1)
$debug

CSEG AT 0h
ljmp main

ORG 30h
    main:
		; Port 3 auf Akkumulator uebertragen
		mov a,p3
		
		; Inhalte des Akkumulators umkehren
		xrl a,#11111111b
		
		; Inhalt des Akkumulators in die LEDs an Port 0 schreiben
		mov p0,a
		
		; Endlosschleife erschaffen
		ajmp main
END