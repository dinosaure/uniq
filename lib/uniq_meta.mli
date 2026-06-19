module Assoc : sig
  type t = (string * string list) list
end

module Path : sig
  type t = private string list
  (** Type of [ocamlfind] packages (like [foo.bar]). *)

  val of_string : string -> (t, [> `Msg of string ]) result
  val of_string_exn : string -> t
  val pp : t Fmt.t
  val equal : t -> t -> bool
  val compare : t -> t -> int
  val parent : t -> t option

  module Set : Set.S with type elt = t
  module Map : Map.S with type key = t
end

type t

val pp : t Fmt.t
val parser : Fpath.t -> (t list, [> `Msg of string ]) result

val search :
     roots:Fpath.t list
  -> ?predicates:string list
  -> Path.t
  -> ((Fpath.t * Assoc.t) list, [> `Msg of string ]) result
(** Search the [META] file for the given [path]. *)

val to_artifacts :
  (Fpath.t * Assoc.t) list -> (Uniq_info.t list, [> `Msg of string ]) result
(** Synthesis all artifacts described into the given [META] files into
    {!type:Uniq_info.t} values. *)

val find_providers :
     roots:Fpath.t list
  -> ?predicates:string list
  -> Modname.t list
  -> (Modname.t * Path.t list) list

(**/*)

val ancestors :
     roots:Fpath.t list
  -> ?predicates:string list
  -> Path.t
  -> ((Path.t * Fpath.t * Assoc.t) list, [> `Msg of string ]) result
