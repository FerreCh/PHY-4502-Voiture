 ;W_COMP_It
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
					org	0003h
					SJMP	itbp
					org	0030h



					

;Programme principal
debut:
					MOV	SP,#2Fh
					MOV	TCON,#01h
					MOV	IE,#81h
					SETB	IE0	

boucle:			

bouclefin:		SJMP	boucle
fin:


;_____________________________________________________________
itbp:				
					PUSH	ACC
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
					LCALL	tempo
					CLR	RES_INF
					CLR	RES_SUP
					POP	ACC
					RETI
;_____________________________________________________________
;comparaison mode 16bits

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

;_____________________________________________________________
;Temporisation de 3 secondes
					
tempo:			PUSH	00h
					PUSH  01h			;gestion de la pile pour R0, R1 et R2
					PUSH  02h
									
					MOV	R0,#17h
Rpt_t0:			MOV	R1,#0FFh
Rpt_t1:			MOV	R2,#0FFh		;temporisation de 3s
Rpt_t2:			DJNZ	R2,Rpt_t2
					DJNZ	R1,Rpt_t1
					DJNZ	R0,Rpt_t0
					
					POP	02h
               POP   01h			;gestion de la pile pour R0, R1 et R2
               POP   00h
               
					RET					
					end


