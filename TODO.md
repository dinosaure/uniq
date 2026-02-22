- [ ] faire un `ocamlobjinfo` sur TOUT les fichiers OCaml (de 4.14 à 5.1)
  + la diff n'est pas énorme et concerne surtout le header
- [x] résolution des modules nécessaire pour un module donné (avec `codept`)
  + On peut qualifier les sources selon un répertoire donné
- [ ] Inclure `stdlib.cm{,x}a` dans la résolution à la demande de l'utilisateur
  + [x] Obtenir la configuration d'ocaml pour savoir où est `stdlib.cm{,x}a`
  + [x] Rajouter les options pour include ou pas `stdlib.cm{,x}a`
- [ ] Rajouter une option `-I` qui permet d'include des sources
  + [ ] ces sources peuvent être
    - [ ] un simple fichier (.ml, mli, .cmo, .cmi, .cma, .cmx, .cmxa)
    - [ ] un dossier contenant des sources (dont on doit parcourir les
          sous-dossiers ou non)
    - [ ] un paquet `ocamlfind` dont un fichier est spécifié (dans le fichier
          `META`)
    - [ ] un paquet `opam` et se référer à la structure du `.opam` pour trouver
          le dossier
- [ ] Avoir un outil de recherche des modules
  + [x] La vue `ocamlfind` est implémenté
    * [x] rechercher des modules (des infos) selon un chemin `ocamlfind`
    * [x] montrer les "ascendants" (à la `ocamlfind -r`) d'un chemin
    * [ ] montrer les "descendants" (à la `ocamlfind -r -d`) d'un chemin
  + [ ] Regarder un espace de travail (comme celui de `.opam`) et chercher un
    nom de module et y donner une description
  + [ ] Étendre cet outil de recherche pour les valeurs (sherlocode?)
  + [ ] Il y aurait 4 vues possibles
    * [ ] La vue module, on cherche tout simplement le nom de module
    * [ ] La vue paquet (`META`), on montre tout ce que peut offrir la
      distribution décrite par le `META` file
    * [ ] La vue `opam`, on montre tout ce que peut offrir le paquet `opam`:
      - [ ] Les `META`
      - [ ] Les objets (incluant `*.a` et `*.o`)
- [ ] Savoir comment exclure un module (montrer ses rev dépendances)
- [ ] Inférer la configuration d'OCaml (celui qui est disponible)
- [ ] résolution des symboles (les archives)
- [ ] reproductibilité du fichier objet généré par OCaml via la résolution
- [ ] résolution de l'application des foncteurs par les interfaces requises
- [ ] tutoriel
  + [ ] partir sur une application simple qui affiche du texte avec
        `print_endline`
  + [ ] expliquer comment compiler ce petit projet entant qu'unikernel
    * [ ] expliquer avec `dune`
    * [ ] `ocamlfind`
    * [ ] `ocamlbuild`
    * [ ] `topkg`?
  + [ ] expliquer comment lancer un unikernel
    * [ ] présenter le _tender_ Solo5
  + [ ] Essayer d'ajouter le moyen de savoir l'heure!
    * [ ] Bien expliquer ce qu'est la _toolchain_ OCaml (`ocaml-solo5`)
    * [ ] Expliquer que cette dernière n'inclut pas `unix.cmxa`
    * [ ] Expliquer la problématique des unikernels en général
      - [ ] Bien établir l'idée que unikernelizer une application est difficile
      - [ ] Considérer les idées de services comme, dès le départ, des
        unikernels
      - [ ] Développer une application avec, en tête, l'idée que `unix.cmxa`
        n'est pas disponible (avec tout les implications que cela peut avoir)
