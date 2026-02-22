# Introduction

Uniq est projet permettant d'assister l'utilisateur dans le développement de son
application pour obtenir un binaire "pleinement qualifié": en d'autres termes,
une distribution **statique** de l'application.

En ce sens, Uniq tente de trouver, avec les élèments qu'on lui donne, un moyen
de qualifier toutes les dépendances d'un projet OCaml. Si il y arrive, c'est
qu'il existe un moyen de compiler et distribuer un exécutable statique de votre
application à partir de votre environnement.

## Basic example

Prennons un exemple très simple, un fichier vide qui n'a aucune dépendance. Nous
devrions être capable d'en obtenir un exécutable qui ne requiert, pour
s'exécuter, de absolument rien:
```sh
$ touch foo.ml
$ uniq foo.ml
$ echo $?
0
$ ocamlopt -ccopt -static -nodynlink foo.ml
$ ldd a.out
    not a dynamic executable
```

Uniq ici nous valide le fait qu'il existe un moyen de compiler notre application
statiquement. La seule chose que requiert notre application est ce qu'on nomme
le _runtime caml_. L'option `-ccopt -static` permet de spécifier que l'on
souhaite produire un programme statique. L'option `-nodynlink` nous assure que
`dlopen` (qui permet de charger des librairies dynamiquement) n'est pas
utilisé[^1].

Enfin, on peut vérifier à l'aide de `ldd` que nous avons bien un exécutable
statique qui se suffit à lui-même[^2].

## A static executable

L'exemple ci-dessus est simple mais il nous permet d'introduire l'idée d'un
exécutable statique. Un exécutable statique est un exécutable qui se suffit à
lui même pour s'exécuter. Il ne requiert pas de dépendances externes (ce qu'on
nomme des librairies partagées) qui soient installées sur votre système pour
fonctionner. Vous pourriez transmettre l'exécutable sur un autre ordinateur, si
ils ont le même assembleur et le même système, ce dernier pourrait exécuter le
programme sans installer quoique ce soit. 

L'intérêt d'un exécutable statique est qu'il ne requiert que très peu en ce qui
concerne son contexte d'exécution pour fonctionner.

Cela ne veut pas pour autant dire que l'exécutable est portable. Il requiert
toujours le même système (un exécutable Linux ne pourrait fonctionner sur un
système Windows) dans lequel il a été compilé et contient un assembleur
spécifique que votre ordinateur doit être capable d'interpréter.

On peut remarquer une différence de taille entre un exécutable statique et un
exécutable dynamique:
```sh
$ ocamlopt foo.ml
$ ls -s a.out
1464 a.out
$ ocamlopt -ccopt -static -nodynlink foo.ml
$ ls -s a.out
2784 a.out
```

C'est normal, c'est que notre exécutable statique intègre tout les symboles (et
le code associé) dont il a besoin pour fonctionner.

## L'effectivité d'uniq

Pour un projet donné qui compile, `uniq` devrait être en mesure de tout trouver.
L'objectif, en effet, n'est pas de **compiler** un projet mais bien d'aggréger
toutes les informations.

[^1]: Pour la version 5.1.0, `dlopen` est tout de même lié à votre exécutable
mais ne sera pas utilisé, tout du moins, via OCaml. On note donc un warning à ce
propos de la part de `ld`.

[^2]: Pour un certains systèmes GNU, la `glibc` est lié dynamiquement. On peut
tout de même lier statiquement cette dernière via `-ccopt -lgcc`. Cependant, il
est conseillé de de plutôt utiliser [musl][musl] entant que *libc* que `glibc`
dès qu'il s'agit de produire un exécutable statique.
