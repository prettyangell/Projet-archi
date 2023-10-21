data SEGMENT 
 msg1 db 0ah,0DH,"tache1 en cours d'execution ...", 0ah, 0dh, "$"
 msg2 db "tache2 en cours d'execution ...", 0ah, 0dh, "$"
 msg3 db "tache3 en cours d'execution ...", 0ah, 0dh, "$"
 msg4 db "tache4 en cours d'execution ...   ", 0ah, 0dh, "$" 
 msgderout db "deroutement fait " ,0Ah,0Dh,"$"
 ancien_cs dw ?
 ancien_ip dw ?
 compt dw 2 
 option db 1
data ENDS 
; ---------------------------------------------- ;
; ---------------------------------------------- ;
ma_pile SEGMENT STACK 
 dw 256 dup(?) 
 tos label word 
ma_pile ENDS 
; ---------------------------------------------- ;
; ---------------------------------------------- ;
code SEGMENT 
assume CS:code, DS: data 
 ; ---------------------------------------------- ;
; ---------------------------------------------- ;
derout_1CH PROC NEAR ;;m?me definition que PR1P1
derout: mov ax , seg new 
 mov ds , ax
 mov dx , offset new 
 mov ax , 251CH 
 int 21H 
 ret 
derout_1CH ENDP 

; ---------------------------------------------- ;
; nouveau code de la routine 1CH                 ;
; ---------------------------------------------- ;
new: mov ax, seg compt ;;m?me definition que PR2P1
 mov ds , ax 
 dec compt 
 jnz fin 
 mov compt , 90 
 cmp option,2
    Jz afficher2
 cmp option,3
    Jz afficher3
 cmp option,4
    Jz afficher4
afficher1:
    cmp di,0
    jz fin
    call NEAR PTR affiche  
    inc option
    jmp fin 
afficher2:call NEAR PTR affiche2
    inc option
    jmp fin
afficher3:call NEAR PTR affiche3
    inc option
    jmp fin
afficher4:call NEAR PTR affiche4
    mov option,1
    dec di
fin: iret
; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche PROC NEAR ;;affichage tache1
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg1 
 mov ah , 09h 
 int 21h 
 ret 
 affiche endp



; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche2 PROC NEAR ;;affichage tache2 
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg2 
 mov ah , 09h 
 int 21h 
 ret 
 affiche2 endp

; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche3 PROC NEAR ;;affichage tache3
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg3 
 mov ah , 09h 
 int 21h 
 ret 
 affiche3 endp
 
 ; ---------------------------------------------- ;
; ---------------------------------------------- ;
affichederout PROC NEAR ;;affichage succ?s du d?routement
mov ax, seg data
 mov ds , ax
 mov dx , offset msgderout
 mov ah , 09h
 int 21h
 ret
 affichederout endp

; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche4 PROC NEAR ;;affichage tache4
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg4
 mov ah , 09h 
 int 21h
 ret 
 affiche4 endp

 ; ---------------------------------------------- ;
; restaure                                       ;
; ---------------------------------------------- ;

restaurer_1CH PROC NEAR ;; proc?dure pour restaurer l'ancien CS et IP de la routine 1CH
push ds
mov ds , ancien_cs
mov dx , ancien_ip
mov ax , 251CH
int 21H
pop ds 
ret
restaurer_1CH ENDP 
 ; ---------------------------------------------- ;
; save                                           ;
; ---------------------------------------------- ;
save_1CH PROC NEAR ;; proc?dure pour sauvegarder l'ancien CS et IP de la routine 1CH
mov ax, 351CH
int 21H
mov ancien_cs, es
mov ancien_ip, bx
ret 
save_1CH ENDP
;------------------------------------------------;
; ---------------------------------------------- ;
;; utilisation d'une boucle infinie avec condition di non nul , si di = 0 alors on fait un jmp vers lexterieur de la boucle pour restaurer la routine 1CH et mettre fin au programme ( apr?s 15 affichages des 4 t?ches  15*4*5= 15*20=300sec=5mins)
 
start:
mov ax , ma_pile 
mov ss , ax
mov di,15
call save_1CH 
call NEAR PTR derout_1CH
call affichederout 
boucle:
cmp di ,0
jz restaure
jmp boucle 
restaure : call restaurer_1CH   
mov ax,4c00h
int 21h 
code ENDS 
end start