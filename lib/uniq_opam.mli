type unlocked = OpamStateTypes.unlocked
type 'a sw = 'a OpamStateTypes.switch_state

val setup : unit -> unit
val with_switch_state : (unlocked sw -> 'a) -> ('a, [> `Msg of string ]) result
val libdir : sw:'a sw -> OpamPackage.Name.t -> Fpath.t
val depends : sw:'a sw -> OpamPackage.Name.t -> OpamPackage.Name.Set.t
val package_names_of_meta_dirs : sw:'a sw -> Fpath.t list -> string list
