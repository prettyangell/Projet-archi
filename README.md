# Projet-archi
## programme 1 partie 1 : 


les procédures d’affichage font appel à la routine 9h de l’int 21h , 
la procédure de déroutement fait appel à la routine 251CH de l’int 21H , pour reconfigurer la routine 1CH à notre guise , 
dans le programme main , nous avons utilisé une boucle imbriqué au sein d’une boucle infinie , 
nous n’avons pas mis d’interruption pour terminer le programme , car la boucle est infinie 


## Programme 1 partie 2 : 


les procédures d’affichage sont les mêmes que le programme 1 partie 1 , 
 on a rajouté une condition à la procédure 1CH , pour que la procédure ne s’enclenche pas après les 5 minutes ,  il a suffit de mettre une condition pour que di ne soit pas égal à 0 quand il y’a un affichage du message « 1 sec écoulée... »,

pour le programme main , nous avons enlevé la boucle infinie , nous avons laissé les deux boucles ,et nous avons introduit une boucle avec condition ( di!=0 est la condition pour que la boucle marche ) , nous avons aussi introduit la routine 4C00H de l’interruption 21h , pour mettre fin au programme après que les 5 minutes soient écoulées 


## Programme 2 partie 1 : 


pour le déroutement et l’affichage , le principe est le même que pour les deux programmes précédents , pour la routine 1CH , nous avons mis des conditions en utilisant la variable option , 
ainsi quand option est à 1 , on incrémente option et on affiche le message «  tache 1 en cours ... » , 
puis il y’a un temps d’attente de 5 secondes pour rappeler la routine d’interruption , avec la option=2 pour afficher le deuxième message , etc , 
une fois arrivé à option=4 , nous affichons le message «  tache 4 en cours ... » puis on réinitialise option à la valeur 1 , pour créer une pseudo boucle , 
pour le temps d’attente de 5 secondes , il est défini par la variable compt ,  car la routine boucle 18 fois / secondes , donc on met option à  90 pour qu’il prenne 5 secondes entre chaque affichage 



## Programme 2 partie 2 : 
nous avons utilisé les mêmes procédures que le programme 2 partie  1 , sauf qu’on a ajouté une une condition dans la routine 1CH , ( di différent de 0 pour executer l’affichage ) ainsi qu’une décrémentation de di  quand on affiche le message de la tache 4 , ( on aura consommé 20 secondes , c’est pour ça qu’on a initialisé di à 15 ( pour les 300 secondes)), nous avons aussi ajouté une condition sur di dans le programme main  pour sortir de la boucle une fois les 15 affichages de 4 routines fait, ainsi on sort de la boucle infinie vers la routine d’interruption de fin de programme 4C00H de l’interruption 21H 
