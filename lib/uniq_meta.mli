module Assoc : sig
  type t = (string * string list) list
end

module Path : sig
  type t = private string list

  val of_string : string -> (t, [> `Msg of string ]) result
  val of_string_exn : string -> t
  val pp : t Fmt.t
end

type t

val pp : t Fmt.t
val parser : Fpath.t -> (t list, [> `Msg of string ]) result

val search :
     roots:Fpath.t list
  -> ?predicates:string list
  -> Path.t
  -> ((Fpath.t * Assoc.t) list, [> `Msg of string ]) result

val ancestors :
     roots:Fpath.t list
  -> ?predicates:string list
  -> Path.t
  -> ((Path.t * Fpath.t * Assoc.t) list, [> `Msg of string ]) result

val to_artifacts :
  (Fpath.t * Assoc.t) list -> (Uniq_info.t list, [> `Msg of string ]) result

val find_providers :
     roots:Fpath.t list
  -> ?predicates:string list
  -> Modname.t list
  -> (Modname.t * Path.t list) list
(** [find_providers ~roots modules] retourne pour chaque module de [modules] la
    liste des paquets ocamlfind qui fournissent un fichier [.cmi] correspondant,
    en scannant les fichiers META dans [roots]. *)

val setup : Fpath.t list Cmdliner.Term.t
