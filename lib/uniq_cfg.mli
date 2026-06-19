type cfg
type src = private Fpath.t
type t = src * cfg

val v : ?env:Bos.OS.Env.t -> unit -> (t, [> `Msg of string ]) result

val from :
     ?env:Bos.OS.Env.t
  -> ?toolchain:string
  -> string
  -> unit
  -> (src * cfg, [> `Msg of string ]) result

module Value : sig
  type _ t

  val string : string t
  val list : ?sep:string -> 'a t -> 'a list t
  val bool : bool t
  val int : int t
  val path : Fpath.t t
end

val get : ?native:bool option -> t -> key:string -> 'a Value.t -> 'a option
