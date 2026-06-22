module Meta = Uniq_meta
module Info = Uniq_info
module Solver = Uniq_solver

let prompt modname pkgs =
  let pp_pkg_with_idx ppf (idx, pkg) =
    Fmt.pf ppf "  [%d] %a" idx Uniq_meta.Path.pp pkg
  in
  let pkgs_with_idx = List.mapi (fun idx pkg -> (idx, pkg)) pkgs in
  Fmt.pr "@[<v>Module %a is provided by several ocamlfind packages:@,%a@]@."
    Modname.pp modname
    Fmt.(list ~sep:cut pp_pkg_with_idx)
    pkgs_with_idx;
  Fmt.pr "Pick one [0-%d]: %!" (List.length pkgs - 1);
  match input_line stdin with
  | exception End_of_file -> raise (Uniq_solver.Ambiguous (modname, pkgs))
  | line ->
      begin match int_of_string_opt line with
      | Some idx when idx >= 0 && idx < List.length pkgs -> List.nth pkgs idx
      | _ -> raise (Uniq_solver.Ambiguous (modname, pkgs))
      end

let has_c_stubs node = List.exists Uniq_info.has_c_stubs node.Solver.objs

let pp_elt ppf (pkg, dirpath) =
  Fmt.pf ppf "%a(%a)" Meta.Path.pp pkg Fpath.pp dirpath

let pp_node ppf (pkg, { Solver.dirpath; _ }) =
  Fmt.pf ppf "%a(%a)" Meta.Path.pp pkg Fpath.pp dirpath

let run_solver _quiet _cfg0 cfg1 dirs =
  let ( let* ) = Result.bind in
  let* g = Uniq_solver.solve ~cfg:cfg1 ~disambiguate:prompt dirs in
  let pkgs =
    let memo = Hashtbl.create 0x7ff in
    let rec vendor visiting path =
      match Hashtbl.find_opt memo path with
      | Some value -> value
      | None ->
          begin if List.mem path visiting then false
          else
            match Meta.Path.Map.find_opt path g with
            | None -> false
            | Some node ->
                let has_c_stubs = has_c_stubs node in
                let trans =
                  List.exists
                    (fun (pkg, _) -> vendor (path :: visiting) pkg)
                    node.Solver.deps
                in
                Hashtbl.replace memo path (has_c_stubs || trans);
                has_c_stubs || trans
          end
    in
    let fn path node acc =
      if vendor [] path then (path, node.Solver.dirpath) :: acc else acc
    in
    Meta.Path.Map.fold fn g []
  in
  Uniq_opam.with_switch_state @@ fun _sw ->
  Fmt.pr "@[<hov>%a@]\n%!" Fmt.(Dump.list pp_node) (Meta.Path.Map.to_list g);
  Fmt.pr "@[<hov>%a@]\n%!" Fmt.(Dump.list pp_elt) pkgs;
  Ok ()

let run_solver _quiet _cfg0 cfg1 dirs =
  run_solver _quiet _cfg0 cfg1 dirs |> Result.join

open Cmdliner
open Uniq_cli

let without_stdlib =
  let doc = "Do not add the standard library to the list of include sources." in
  Arg.(value & flag & info [ "without-stdlib" ] ~doc)

let recurse =
  let doc = "Include sub-directories." in
  Arg.(value & flag & info [ "r"; "recurse" ] ~doc)

let exclude =
  let doc =
    "Exlude a file, or a directory (and its sub-directories), from resolution."
  in
  let v = path in
  Arg.(value & opt_all v [] & info [ "x"; "exclude" ] ~doc ~docv:"PATH")

let ignore =
  let doc =
    "Do not require a provider for this module (e.g. a generated unit). \
     Without it, a module no package provides is an error. Repeatable or \
     comma-separated."
  in
  let open Arg in
  value & opt_all (list modname) [] & info [ "i"; "ignore" ] ~doc ~docv:"MODULE"

let forbid =
  let doc =
    "Forbid this module: referencing it is an error even if a package provides \
     it. Repeatable or comma-separated."
  in
  let open Arg in
  value & opt_all (list modname) [] & info [ "forbid" ] ~doc ~docv:"MODULE"

let dirs =
  let doc = "The OCaml project directories." in
  Arg.(non_empty & pos_all existing_dirpath [] & info [] ~doc ~docv:"DIRECTORY")

let setup_solver without_stdlib recurse exclude ignore forbid policy roots =
  let ignore = List.concat ignore in
  let forbid = List.concat forbid in
  Uniq_solver.Config.cfg ~stdlib:(not without_stdlib) ~recurse ~exclude ~ignore
    ~forbid ~policy roots

let setup_solver =
  let open Term in
  const setup_solver
  $ without_stdlib
  $ recurse
  $ exclude
  $ ignore
  $ forbid
  $ setup_policy
  $ setup_ocamlfind

let term =
  let open Term in
  const run_solver
  $ setup_logs
  $ setup_ocaml
  $ setup_solver
  $ dirs
  |> term_result

let cmd =
  let doc = "Infer the opam package an OCaml project should vendor." in
  let man = [ `S Manpage.s_description ] in
  let info = Cmd.info "uniq" ~doc ~man in
  Cmd.v info term

let () = Cmd.(exit @@ eval cmd)
