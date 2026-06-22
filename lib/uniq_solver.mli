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

type node = {
    dirpath: Fpath.t
  ; objs: Uniq_info.t list
  ; deps: (Uniq_meta.Path.t * [ `CRC | `Name ]) list
}

type graph = node Uniq_meta.Path.Map.t

val solve :
     cfg:Config.t
  -> ?disambiguate:disambiguate
  -> Fpath.t list
  -> (graph, [> `Msg of string ]) result
