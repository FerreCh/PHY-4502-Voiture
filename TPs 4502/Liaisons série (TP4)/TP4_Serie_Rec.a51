   ;R�ception s�rie
 ;29/11/18
 
 ;D�claration des variables


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
;Programme principal

debut:			MOV	SCON,#50h
					MOV	PCON,#00h
					MOV	TMOD,#21h
					MOV	TH1,#0E6h
					MOV	TL1,#0E6h
					SETB	TR1				;on enclenche le timer 1
					LCALL	LCD_init
boucle:        

att_deb_rec:	JB		RI,att_deb_rec	;d�tection d'une donn�e re�ue
att_f_rec:		JNB	RI,att_f_rec	;attente fin r�ception
					CLR	RI
					
					MOV	A,SBUF
               CJNE	A,#0Dh,continue
               SJMP	boucle
continue:      
					MOV	LCD,A				
					LCALL	LCD_Data
					

fin:				SJMP	boucle

;_______________________________________________________________
;LCD_msg
;envoi du message sur l'�cran

LCD_msg:			PUSH	ACC
debcar:			MOV	A,#00h
					MOVC	A,@A+DPTR
					JZ		fin_msg			;tant qu'on ne rencontre pas de 0 (fin de ligne)
					MOV	LCD,A
					LCALL	LCD_Data			;on charge les donn�es en programme
					INC	DPTR
					SJMP	debcar	
fin_msg:			POP	ACC
					RET	

										
;______________________________________________________________
;LCD_init
;Initialisation LCD

LCD_init:		PUSH	00h    			;sauvegarde de R0
					MOV	R0,#03h        ;pour r�p�ter
					MOV	LCD,#30h
					CLR	R_S            ;valeurs d'initialisation
					CLR	RW
att_ini:			LCALL	timer50ms
					SETB	E
					CLR	E					;� envoyer 3 fois
					DJNZ	R0,att_ini
					LCALL	LCD_BF
					MOV	LCD,#38h
					LCALL	LCD_Code
					MOV	LCD,#0Ch			;display on
					LCALL	LCD_Code			;r�glage des param�tres d'affichage
					MOV	LCD,#01h			;refesh affichage
					LCALL	LCD_Code
					MOV	LCD,#06h			;mode incr�mentation
					LCALL	LCD_Code
					POP	00h
					RET


;______________________________________________________________
;LCD_BF
;Attente que l'afficheur ne soit plus occup�

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
;Envoie des donn�es sur LCD

LCD_Data:		SETB	R_S
					CLR	RW
					SETB	E
					CLR	E
					LCALL	LCD_BF
					RET
;_______________________________________________________________
;timer50ms
;timer 50ms

timer50ms:		MOV	TH0,#3Ch			;r�glage sur 50ms
					MOV	TL0,#0AFh
					SETB	TR0				;d�marage du timer
					
attente:			JNB	TF0,attente		;attente du flag
					CLR	TR0				;on arrete le timer et le flag
					CLR	TF0
					RET					
					
					end

