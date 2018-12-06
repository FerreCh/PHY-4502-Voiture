;W_COMP
;Comparaison de deux mots codés sur 16 bits
;15/11/2018

;Déclaration des variables

RES				bit	P3.7				
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
					CLR	C
					MOV	A,W1_H			;(A)<-(W1_H)-(W2_H)
					SUBB	A,W2_H         

siEga: 			JNZ	fsiEga			;Si (A)=0 alors
					MOV   A,W1_L      	;	(A)<-(W1_L)-(W2-L)
					CLR	C              
					SUBB	A,W2_L
fsiEga:                             ;FinSi

    				MOV	RES,C          ;(Res)<-Retenue de la soustraction

bouclefin:		SJMP	boucle
fin:
					end



