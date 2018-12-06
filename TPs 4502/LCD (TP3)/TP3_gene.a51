   ;Gene
 ;Generer signal rectangulaire
 ;19/11/18
 
 ;Déclaration des variables

GENE				bit	P3.0

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	000Bh
					SJMP	itimer0
					org	0030h

;Programme principal
debut:			
					LCALL init
					SETB	TF0				;On active la première interruption
							

boucle:			
									

					SJMP	boucle
fin:

;
;----------------------------------------------------------------------------
;interuption timer 0
itimer0:
					PUSH 	ACC
					
siHaut:			JNB	GENE,sinon
					MOV	R0,#0E7h
					MOV	R1,#0FCh

finsi:			SJMP	fsinon
sinon:			MOV	R0,#3Fh
					MOV	R1,#0FFh

fsinon:
					
					
					CLR	TR0				;on arrete le timer	1
					MOV	A,TL0				;							1			
					ADD	A,R0				;							1			
					MOV	TL0,A				;							1		
					MOV	A,TH0				;							1			
					ADDC	A,R1				;							1			
					MOV	TH0,A				;							1			

					SETB	TR0				;démarage du timer
					CPL	GENE				;on passe d'un état à l'autre
					
					POP ACC
					RETI
					
					
;
;______________________________________________________________
;initialisation

init:
					MOV	IE,#82h
					MOV	TMOD,#01h		;mode timer 16bit
					MOV	TH0,#00h			;Timer à 0
					MOV	TL0,#00h
					RET
					
					
					end
					
