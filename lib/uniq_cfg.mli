type t

val v : ?env:Bos.OS.Env.t -> unit -> (t, [> `Msg of string ]) result
val from : t -> Fpath.t

module Value : sig
  type _ t

  val string : string t
  val list : ?sep:string -> 'a t -> 'a list t
  val bool : bool t
  val int : int t
  val path : Fpath.t t
end

val get : ?native:bool option -> t -> key:string -> 'a Value.t -> 'a option

val setup : string option Cmdliner.Term.t -> t option Cmdliner.Term.t
(** [setup toolchain] construit le terme de configuration. [toolchain], s'il est
    fourni, fait lire la configuration du compilateur croisé via
    [ocamlfind -toolchain <NAME>] (ex. [solo5], dont la bibliothèque standard ne
    fournit pas [Unix]). *)
