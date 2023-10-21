data SEGMENT
    msg db "1sec ",130,"coul",130,"e....$"
    compt db 18
    bouc3 db 3
  
    msg2 db 10,13,"**** Debut du quantum de temps logiciel ****$"
msg3 db "deroutement fait....",10,13,10,13,"$"
ANCIEN_CS dw ?
ANCIEN_IP dw ?
data ENDS
; ---------------------------------------------- ;
; ---------------------------------------------- ;
ma_pile SEGMENT STACK                          ;;declaration de la pile
 dw 256 dup(?)
 tos label word
ma_pile ENDS
; ---------------------------------------------- ;
; ---------------------------------------------- ;
code SEGMENT
assume CS:code, DS: data
 ; ---------------------------------------------- ;
; ---------------------------------------------- ;
derout_1CH PROC NEAR                        ;;proc?dure de d?routement de la routine 1CH
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
;;red?finition de la routine 1CH pour qu'elle affiche chaque seconde , une boucle de 18 qui se d?cr?mente et execute laffichage seulement si le compt est ? 0 
new:         
mov ax, seg compt
mov ds , ax
dec compt
jnz finish  
call near ptr affiche      
mov compt,18
fin1CH:
finish :  iret  
; ---------------------------------------------- ;
; ---------------------------------------------- ;
;;proc?dure d'affichage utilis?e dans lint 1CH
affiche PROC NEAR
mov ax, seg data
 mov ds , ax
 mov dx , offset msg
 mov ah , 09h
 int 21h
 ret
 affiche endp



; ---------------------------------------------- ;
; ---------------------------------------------- ;
;;proc?dure d'affichage utilis?e lors du d?but dun quantum de temps
affiche2 PROC NEAR
mov ax, seg data
 mov ds , ax
 mov dx , offset msg2
 mov ah , 09h
 int 21h
 ret
 affiche2 endp

 
; ---------------------------------------------- ;
; ---------------------------------------------- ;
;; proc?dure d'affichage utilis?e au d?but du prog pour afficher le succ?s du d?routement 
affiche3 PROC NEAR
mov ax, seg data
 mov ds , ax
 mov dx , offset msg3
 mov ah , 09h
 int 21h
 ret
 affiche3 endp
; ---------------------------------------------- ;
; ---------------------------------------------- ;
start: ;; utilisation d'une boucle imbriqu?e pour cr?er un quantum de 20 secs , et le etiq : jmp etiq pour reboucler infiniment 
mov ax ,data
mov ds ,ax
mov ax , ma_pile
mov ss , ax
call near ptr affiche3
call NEAR PTR derout_1CH
etiq:

           call near ptr affiche2

           mov cx,00fffh
boucle_externe:           
      
            mov si,1CFFh
boucle_interne: 
           dec si
           jnz boucle_interne
           
           loop boucle_externe
           jmp etiq           
           mov ax,4c00h
           int 21h 

code ENDS
end start