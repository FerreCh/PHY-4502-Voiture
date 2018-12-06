     ;Gene_lim
 ;Generer signal rectangulaire à rapport variable
 ;22/11/18
 
 ;Déclaration des variables

GENE				bit	P3.0
DOWN				bit	P1.0
UP					bit	P1.1
TUPH				data	7Fh
TUPL				data	7Eh
TDOH				data	7Dh
TDOL				data	7Ch 
cmp				data	7Bh
MODIF				bit	F0


;Table des IT
					org	0000h				;directive assembleur
					SJMP	debut
					org	000Bh
					SJMP	itimer0
					org	0030h

;Programme principal
debut:			
					LCALL init				;Initialisation des valeurs
					SETB	TF0				;On active la première interruption
boucle:			JB		GENE,boucle					                                          
					JNB	MODIF,tempo
					
sid:				JNB	DOWN,fsi       ;début de la boucle exécuté toute les secondes   

					MOV	A,TUPL              
					SUBB	A,#14h               
					MOV	TUPL,A                
					MOV	A,TUPH			;Décrémentation du rapport cyclique
					SUBB	A,#00h                 
					MOV	TUPH,A                  
					MOV	A,TDOL                   
					ADD	A,#14h                    
					MOV	TDOL,A                     
					MOV	A,TDOH                      
					ADDC	A,#00h            
					MOV	TDOH,A
					CLR 	MODIF
					                  
					

fsi:

siu:         	JNB	UP,boucle
				
					MOV	A,TUPL
					ADD	A,#14h
					MOV	TUPL,A
					MOV	A,TUPH
					ADDC	A,#00h
					MOV	TUPH,A
					MOV	A,TDOL			;Incrémentation du rapport cyclique
					SUBB	A,#14h
					MOV	TDOL,A
					MOV	A,TDOH
					SUBB	A,#00h
					MOV	TDOH,A			;fin de la boucle exécuté toute les secondes
					CLR 	MODIF
fsn:							
					
tempo:			MOV	cmp,#13h
					LCALL	timer1s
				
fin:				SJMP	boucle

;
;__________________________________________________________
;interuption timer 0
itimer0:
					PUSH 	ACC
					PUSH	01h				;R1
					PUSH	00h            ;R2
					
siHaut:			JNB	GENE,sinon1
					MOV	R0,TUPL
					MOV	R1,TUPH

finsi:			SJMP	fsinon
sinon1:			MOV	R0,TDOL
					MOV	R1,TDOH

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
					
					POP	00h				;R2
					POP	01h            ;R1
					POP ACC
					RETI
					
					
;
;______________________________________________________________
;initialisation

init:
					MOV	IE,#82h
					MOV	TMOD,#11h		;mode timer 16bit pour les deux timer
					MOV	TUPL,#0E7h
					MOV	TUPH,#0FCh		;Initialisation rapport 80/20
					MOV	TDOL,#3Fh
					MOV	TDOH,#0FFh
					SETB	F0
					RET
					
					
					
					
;
;_______________________________________________________________
;Timer 50ms
timer50:			PUSH	ACC
		
		
					MOV	TH1,#3Ch			;réglage sur 50ms
					MOV	TL1,#0AFh
					SETB	TR1				;démarage du timer
					
attente:			JNB	TF1,attente		;attente du flag
					CLR	TR1				;on arrete le timer et le flag
					CLR	TF1
					
					POP	ACC
						
					RET
					
;___________________________________________________________________
;timer cmp*50ms
timer1s:	
ctimer50:		LCALL	timer50
					DJNZ	cmp,ctimer50
					SETB	MODIF
					RET

					
;___________________________________________________________________
;comparaison

CMP_W:
					PUSH ACC
					CLR	C
					MOV	A,W1_H			;(A)<-(W1_H)-(W2_H)
					SUBB	A,W2_H         

siEga: 			JNZ	fsiEga			;Si (A)=0 alors
					MOV   A,W1_L      	;	(A)<-(W1_L)-(W2-L)
					CLR	C              
					SUBB	A,W2_L
fsiEga:                             ;FinSi

    				MOV	RES,C          ;(Res)<-Retenue de la soustraction


					POP ACC
					RET

					
					end



