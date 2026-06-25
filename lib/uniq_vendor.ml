let src = Logs.Src.create "uniq.vendor"

module Log = (val Logs.src_log src : Logs.LOG)
module Info = Uniq_info

let color impls =
  let provider =
    let tbl = Hashtbl.create 0x7ff in
    let fn info =
      let fn (path, _) =
        match Uniq_info.Path.to_list path with
        | [ m ] -> Hashtbl.replace tbl m (Info.location info)
        | _ -> ()
      in
      List.iter fn (Uniq_info.exports info)
    in
    List.iter fn impls; tbl
  in
  let depends_on info =
    let imports =
      List.rev_append
        (Uniq_info.impls_imported info)
        (Uniq_info.intfs_imported info)
    in
    List.filter_map (fun (m, _) -> Hashtbl.find_opt provider m) imports
    |> List.filter (fun k' -> not (Fpath.equal k' (Info.location info)))
    |> List.sort_uniq Fpath.compare
  in
  let tainted =
    let init =
      let fn set info =
        if Uniq_info.has_c_stubs info then
          Fpath.Set.add (Info.location info) set
        else set
      in
      List.fold_left fn Fpath.Set.empty impls
    in
    let step current =
      let fn set info =
        if Fpath.Set.mem (Info.location info) set then set
        else if List.exists (fun d -> Fpath.Set.mem d current) (depends_on info)
        then Fpath.Set.add (Info.location info) set
        else set
      in
      List.fold_left fn current impls
    in
    let rec fix set =
      let set' = step set in
      if Fpath.Set.equal set set' then set else fix set'
    in
    fix init
  in
  let fn info = Fpath.Set.mem (Info.location info) tainted in
  List.filter fn impls
