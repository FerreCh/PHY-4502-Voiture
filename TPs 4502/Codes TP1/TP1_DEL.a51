;Commande DEL
;Deuxieme exercice

;D�claration des variables

BP					bit	P0.0				;bouton poussoir
Aff				bit	P3.0				;DEL

;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h

;Programme principal

debut:
rpt:
attentehaut:	JNB	BP,attentehaut	;Attente BP=1
attentebas:		JB		BP,attentebas	;Attente BP=0
					CPL	Aff				;changer etat DEL
jsq:				SJMP	rpt				;boucler � rpt
fin:				
					end
