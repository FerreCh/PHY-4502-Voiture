;W_COMP_In
;Comparaison de deux mots codés sur 16 bits sur routine
;19/11/2018

;Déclaration des variables

RES_INF			bit	P3.7
RES_SUP			bit	P3.6				
W1_L				data	7Fh
W1_H				data	7Eh
W2_L				data	7Dh
W2_H				data	7Ch
W_IN				data	P1

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h


itbp:
					

;Programme principal

debut:
					MOV	SP,2Fh
						
		
boucle:			
					MOV	A,W_IN
					RL		A
					RL		A
					ANL	A,#03h			;récupérer W1_H
					MOV	W1_H,A
					
					MOV	A,W_IN
					ANL	A,#30h			;récupérer W1_L
					SWAP	A
					MOV	W1_L,A
					
					MOV	A,W_IN
					RR		A
					RR		A
					ANL	A,#03h			;récupérer W2_H
					MOV	W2_H,A
					
					MOV	A,W_IN
					ANL	A,#03h			;récupérer W2_L
					MOV	W2_L,A
					
					
					MOV	R0,#7Eh
					MOV	R1,#7Ch			;initialisation des données en entrée
				   LCALL W_comp
					MOV	C,F0
					MOV	RES_INF,C		;appel au sous-programme
					CPL	C
					MOV	RES_SUP,C
				
bouclefin:		SJMP	boucle
fin:


;_____________________________________________________________

W_comp:
					PUSH	ACC
					CLR	C
					MOV	A,@R0			;(A)<-(W1_H)-(W2_H)
					SUBB	A,@R1         

siEga: 			JNZ	fsiEga			;Si (A)=0 alors
					INC	R0
					INC	R1
					MOV   A,@R0      		;	(A)<-(W1_L)-(W2-L)
					CLR	C              
					SUBB	A,@R1
fsiEga:                             ;FinSi

    				MOV	F0,C      	;(F0)<-Retenue de la soustraction

					POP	ACC
					RET
					end

