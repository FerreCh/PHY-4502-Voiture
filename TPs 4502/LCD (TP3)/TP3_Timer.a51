 ;Timer_50ms
 ;Faire clignoter une led avec un compteur 16 bits
 ;19/11/18
 
 ;Déclaration des variables

LED				bit	P3.0

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h

;Programme principal
debut:			MOV	TMOD,#01h
							

boucle:			
					MOV	TH0,#3Ch			;réglage sur 50ms
					MOV	TL0,#0AFh
					SETB	TR0				;démarage du timer
					
attente:			JNB	TF0,attente		;attente du flag
					CPL	LED				;on change l'etat de la LED
					CLR	TR0				;on arrete le timer et le flag
					CLR	TF0
					SJMP	boucle
fin:					
					end
