module Src : sig
  type directory = { recurse: bool; location: Fpath.t; exclude: Fpath.t list }

  type t =
    private
    [ `File of Fpath.t | `Sources of directory | `Objects of directory ]

  val pp : t Fmt.t
  val file : Fpath.t -> t
  val sources : ?recurse:bool -> ?exclude:Fpath.t list -> Fpath.t -> t
  val objects : ?recurse:bool -> ?exclude:Fpath.t list -> Fpath.t -> t
end

val qualify_objects : Uniq_info.t list -> Uniq_info.t list

val qualify :
  ?stdlib:bool -> Src.t list -> (Uniq_info.t list, [> `Msg of string ]) result
(** [qualify ?stdlib srcs] returns the OCaml objects that can be inferred based
    on the given {i sources} [srcs] (folders, files, artefacts) and attempts to
    {i qualify} these objects. To qualify an object is, strictly speaking, to
    find all the other objects required so that all references within the object
    can be found amongst the others. An object may therefore not be fully
    qualified, and other sources must therefore be found in order for it to be
    fully qualified.

    It is said that static linking of all these objects is possible once they
    are all fully qualified. This function is therefore the central element of
    our resolution loop (qualify, search for new elements, re-qualify, and so on
    until all artefacts have been fully qualified). *)
