module Config : sig
  type t

  val cfg :
       ?stdlib:bool
    -> ?recurse:bool
    -> ?exclude:Fpath.t list
    -> ?ignore:Modname.t list
    -> ?forbid:Modname.t list
    -> ?policy:Uniq_policy.t
    -> Fpath.t list
    -> t
end

type disambiguate = Modname.t -> Uniq_meta.Path.t list -> Uniq_meta.Path.t

exception Ambiguous of Modname.t * Uniq_meta.Path.t list

val fail_on_ambiguity : disambiguate

val solve :
     cfg:Config.t
  -> ?disambiguate:disambiguate
  -> Fpath.t list
  -> (unit, [> `Msg of string ]) result
