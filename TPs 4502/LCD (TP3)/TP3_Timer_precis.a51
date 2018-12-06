  ;Timer_50ms précis
 ;Faire clignoter une led avec un compteur 16 bits
 ;19/11/18
 
 ;Déclaration des variables

LED				bit	P3.0

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h

;Programme principal
debut:			MOV	TMOD,#01h		;mode timer 16bit
					MOV	TH0,#00h			;Timer à 0
					MOV	TL0,#00h
							

boucle:			
					CLR	TF0				;on remet le flag à 0
					CLR	TR0				;on arrete le timer
					MOV	A,TL0				;										
					ADD	A,#0B7h			;										
					MOV	TL0,A				;									
					MOV	A,TH0				;										
					ADDC	A,#3Ch			;										
					MOV	TH0,A				;										

					SETB	TR0				;démarage du timer
					
attente:			JNB	TF0,attente		;attente du flag
					CPL	LED				;on change l'etat de la LED

					SJMP	boucle
fin:					
					end
