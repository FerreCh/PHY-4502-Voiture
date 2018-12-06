;Accès données
;Premier exercice

;Déclaration des variables

Val				equ	0A4h				;valeur transferee
Adro_1			data	10h
Adro_2			data	31h
Adrb				bit	31h

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h

;Programme principal

debut:
					MOV	A,#Val			;transfere de Val dans A
					MOV	P0,#Val	      ;transfere de Val dans P0
					MOV	PSW,#00h			;selection de la banque 0
					MOV	R0,#Val			;transfere de Val dans R0 de banque 0
					SETB	RS0				;selection banque 1
					MOV	R0,#Val			;transfere de Val dans R0 de banque 1
					MOV	Adro_1,#Val		;transfere de Val à l'adresse 10h
					MOV	Adro_2,@R1		;transfere le contenu de l'adresse pointé par R1 dans Adro_2
					SETB	Adrb				;(Adrb)<-1
					
fin :				SJMP	fin				;bouclage

end											;directive assembleur
