data SEGMENT 
 msg1 db 0ah,0DH,"tache1 en cours d'execution ...", 0ah, 0dh, "$"
 msg2 db "tache2 en cours d'execution ...", 0ah, 0dh, "$"
 msg3 db "tache3 en cours d'execution ...", 0ah, 0dh, "$"
 msg4 db "tache4 en cours d'execution ...   ", 0ah, 0dh, "$" 
 msgderout db "deroutement fait " ,0Ah,0Dh,"$"
 ancien_cs dw ?
 ancien_ip dw ?
 compt dw 90 
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
derout_1CH PROC NEAR  ;;m?me principe que Pr1P1 et Pr1P2
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
new: mov ax, seg compt ;;m?me principe que Pr1P1 et Pr1P2 sauf pour le parametre option , on l'a mis pour diff?rencier entre laffichage de la tache1/2/3/4 , et on incr?mente option jusqua 4 puis on la reintiallise a 1 pour cr?er lordre entre laffichage des taches
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
fin: iret
; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche PROC NEAR ;;afffichage tache1
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg1 
 mov ah , 09h 
 int 21h 
 ret 
 affiche endp



; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche2 PROC NEAR ;;afffichage tache2 
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg2 
 mov ah , 09h 
 int 21h 
 ret 
 affiche2 endp

; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche3 PROC NEAR ;;afffichage tache3
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg3 
 mov ah , 09h 
 int 21h 
 ret 
 affiche3 endp
 
 ; ---------------------------------------------- ;
; ---------------------------------------------- ;
affichederout PROC NEAR ;;afffiche le message du succ?s du d?routement 
mov ax, seg data
 mov ds , ax
 mov dx , offset msgderout
 mov ah , 09h
 int 21h
 ret
 affichederout endp

; ---------------------------------------------- ;
; ---------------------------------------------- ;
affiche4 PROC NEAR ;;afffichage tache4
mov ax, seg data 
 mov ds , ax 
 mov dx , offset msg4
 mov ah , 09h 
 int 21h
 ret 
 affiche4 endp


;------------------------------------------------;
; ---------------------------------------------- ;
 
 
start: ;; utilisation du boucle infinie pour permettre a l'interruption d?tre utilis?e a linfinie
mov ax , ma_pile 
mov ss , ax
call NEAR PTR derout_1CH
call affichederout 
boucle:
jmp boucle  
mov ax,4c00h
int 21h 
code ENDS 
end start