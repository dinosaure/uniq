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

let run_solver _quiet ocfg cfg strict =
  let disambiguate =
    match strict with true -> Uniq_solver.fail_on_ambiguity | false -> prompt
  in
  assert false

open Cmdliner
open Uniq_cli
