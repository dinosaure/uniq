type disambiguate = Modname.t -> Uniq_meta.Path.t list -> Uniq_meta.Path.t

type decider = {
    roots: Fpath.t list
  ; matches: string -> Uniq_meta.Path.t -> bool
  ; policy: Uniq_policy.t
  ; disambiguate: disambiguate
  ; crcs: (string, Uniq_digest.t option) Hashtbl.t
  ; decided: (string, Uniq_meta.Path.t) Hashtbl.t
  ; choices: (string, Uniq_meta.Path.t) Hashtbl.t
  ; mutable committed: Uniq_meta.Path.Set.t
}

(* NOTE(dinosaure): [pkg] exports [mopdname] with the given [crc]? *)
let exports_crc ~roots pkg modname crc =
  let ( let* ) = Result.bind in
  begin
    let* descrs = Uniq_meta.search ~roots pkg in
    let* infos = Uniq_meta.to_artifacts descrs in
    let crc' = List.find_map (fun v -> Uniq_info.crc_of v modname) infos in
    match (crc, crc') with
    | Some a, Some b -> Ok (Digest.equal a b)
    | _ -> Ok false
  end
  |> Result.to_option
  |> Option.value ~default:false
