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
                cmp di,0
                jz fin1CH
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
; restaure                                       ;
; ---------------------------------------------- ;

restaurer_1CH PROC NEAR ;;proc?dure pour restaurer l'ancienne routine1CH
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
save_1CH PROC NEAR      ;;proc?dure pour sauvegarder le CS et LIP de l'ancienne routine 
mov ax, 351CH
int 21H
mov ancien_cs, es
mov ancien_ip, bx
ret
save_1CH ENDP
;------------------------------------------------;
 ; ---------------------------------------------- ;
 ; ---------------------------------------------- ;
 
 start: ;; prog principale avec une boucle imbriqu?e pour permettre l'affichage de 20fois *une seconde ?coul?e* on a utilis? di pour cr?er une troisieme boucle pour que le programme continue pendant 5 mins (60sec*5=300sec/20=15fois)
mov ax ,data
mov ds ,ax
mov ax , ma_pile
mov ss , ax
call near ptr affiche3
call near PTR save_1CH
call NEAR PTR derout_1CH
mov di,15
etiq:

           call near ptr affiche2

           mov cx,00fffh
boucle_externe:           
      
            mov si,1CFFh
boucle_interne: 
           dec si
           jnz boucle_interne
           
           loop boucle_externe
           

           dec di
           cmp di,0
           jnz etiq
           call near ptr restaurer_1CH
           
           mov ax,4c00h
           int 21h 

code ENDS
end start