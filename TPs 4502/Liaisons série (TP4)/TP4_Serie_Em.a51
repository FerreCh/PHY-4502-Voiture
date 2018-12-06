  ;Emission série
 ;29/11/18
 
 ;Déclaration des variables


BP					bit	P0.0
DONNEE			data	P1


;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h
;____________________________________________________________
;Programme principal

debut:			MOV	SCON,#40h
					MOV	PCON,#00h
					MOV	TMOD,#20h
					MOV	TH1,#0E6h
					MOV	TL1,#0E6h
					SETB	TR1				;on enclenche le timer
boucle:        

attentehaut:	JNB	BP,attentehaut	;Attente BP=1
attentebas:		JB		BP,attentebas	;Attente BP=0 -> front descendant
					MOV	A,DONNEE
					ANL	A,#0Fh
					ORL	A,#30h			;conversion en ASCII
					MOV	SBUF,A
att_f_emi:		JNB	TI,att_f_emi	;attente fin émission
					CLR	TI
					

fin:				SJMP	boucle

					end

