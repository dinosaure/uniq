## A statically linked program

La plus grosse contrainte d'un unikernel est son interaction avec le système
hôte qui est limité. Ainsi, un unikernel doit principalement se suffir à
lui-même pour fonctionner. Ensuite, quelques interactions très basiques
suffisent pour communiquer avec l'unikernel (via ce qu'on nomme des interfaces
`tap` et des block-devices).

À la différence d'un programme "normal", un unikernel a donc des interactions
limitées avec le système hôte et ne peut requérir de toutes les ressources qu'on
a habituellement accès quand il s'agit de faire une application.

Une ressource subtil mais nécessaire à l'exécution d'un programme "normal" sont
les librairies partagées. Pour l'exemple, un programme OCaml compilé sur un
système GNU/Linux aura nécessaire besoin de la librarie partagé `glibc`. Un
unikernel ne pourrait pas avoir accès à cette librairie. Un unikernel ne peut
"charger" de librairies partagées. Ainsi, et c'est l'objectif de `uniq`, il nous
faut un moyen de qualifié tout les symboles nécessaires à une application afin
de statiquement lier tout ce qui est requis pour l'exécution de notre
application.
