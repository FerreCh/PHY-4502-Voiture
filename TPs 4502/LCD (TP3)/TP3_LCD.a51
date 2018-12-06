 ;Gesion écran LCD
 ;27/11/18
 
 ;Déclaration des variables


BF					bit	P2.7
E					bit	P1.7
R_S				bit	P1.5
RW					bit	P1.6
LCD				data	P2


;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	0030h
;____________________________________________________________
;texte à afficher
texteac1:		db		'*** BONJOUR  ***'
					db		00h
texteac2:      db		'*** ISE 2018 ***'
					db		00h

;Programme principal

debut:			MOV	TMOD,#01h		;activation timer
					LCALL	LCD_init

					MOV	DPTR,#texteac1	;on affiche la première ligne
					LCALL	LCD_msg
					MOV	LCD,#0C0h		;adresse seconde ligne
					LCALL	LCD_Code
					MOV	DPTR,#texteac2 ;on affiche la seconde ligne
					LCALL	LCD_msg
boucle:
fin:				SJMP	boucle


;_______________________________________________________________
;LCD_msg
;envoi du message sur l'écran

LCD_msg:			PUSH	ACC
debcar:			MOV	A,#00h
					MOVC	A,@A+DPTR
					JZ		fin_msg			;tant qu'on ne rencontre pas de 0 (fin de ligne)
					MOV	LCD,A
					LCALL	LCD_Data			;on charge les données en programme
					INC	DPTR
					SJMP	debcar	
fin_msg:			POP	ACC
					RET	
					
;______________________________________________________________
;LCD_init
;Initialisation LCD

LCD_init:		PUSH	00h    			;sauvegarde de R0
					MOV	R0,#03h        ;pour répéter
					MOV	LCD,#30h
					CLR	R_S            ;valeurs d'initialisation
					CLR	RW
att_ini:			LCALL	timer50ms
					SETB	E
					CLR	E					;à envoyer 3 fois
					DJNZ	R0,att_ini
					LCALL	LCD_BF
					MOV	LCD,#38h
					LCALL	LCD_Code
					MOV	LCD,#0Ch			;display on
					LCALL	LCD_Code			;réglage des paramètres d'affichage
					MOV	LCD,#01h			;refesh affichage
					LCALL	LCD_Code
					MOV	LCD,#06h			;mode incrémentation
					LCALL	LCD_Code
					POP	00h
					RET


;______________________________________________________________
;LCD_BF
;Attente que l'afficheur ne soit plus occupé

LCD_BF:			MOV	LCD,#0FFh
					CLR	R_S
					SETB	RW
					
att_BF:			CLR	E
					SETB	E
					JB		BF,att_BF
					CLR	E
					RET
;_______________________________________________________________
;LCD_Code
;Envoie des commandes sur LCD

LCD_Code:		CLR	R_S
					CLR	RW
					SETB	E
					CLR	E
					LCALL	LCD_BF
					RET

;_______________________________________________________________
;LCD_Data
;Envoie des données sur LCD

LCD_Data:		SETB	R_S
					CLR	RW
					SETB	E
					CLR	E
					LCALL	LCD_BF
					RET
;_______________________________________________________________
;timer50ms
;timer 50ms

timer50ms:		MOV	TH0,#3Ch			;réglage sur 50ms
					MOV	TL0,#0AFh
					SETB	TR0				;démarage du timer
					
attente:			JNB	TF0,attente		;attente du flag
					CLR	TR0				;on arrete le timer et le flag
					CLR	TF0
					RET					
					
					end

