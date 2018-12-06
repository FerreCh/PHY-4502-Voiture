;W_COMP_Rt
;Comparaison de deux mots codés sur 16 bits sur routine
;15/11/2018

;Déclaration des variables

RES_RT			bit	P3.7				
W1_L				data	7Fh
W1_H				data	7Eh
W2_L				data	7Dh
W2_H				data	7Ch

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h

;Programme principal

debut:			MOV	SP,2Fh
		
boucle:			LCALL W_comp
					MOV	C,F0
					MOV	RES_RT,C
				
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

