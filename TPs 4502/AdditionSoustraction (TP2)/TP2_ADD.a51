;W_ADD
;Addition de deux mots cod�s sur 16 bits
;15/11/2018

;D�claration des variables

RES_L				data	00h				
RES_H				data	01h
W1_L				data	7Fh
W1_H				data	7Eh
W2_L				data	7Dh
W2_H				data	7Ch

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h

;Programme principal

debut:
		
boucle:
					MOV	A,W1_L			;(RES_L)<-(W1_L)-(W2_L)
					SUBB	A,W2_L
					MOV	RES_L,A
												;(CARRY)<-retenue de l'addition
					MOV	A,W1_H			;(RES_H)<-(W1_H)-(W2_H)-(CARRY)
					SUBB	A,W2_H
					MOV	RES_H,A
boucle_fin:		SJMP	boucle
fin:
					end
