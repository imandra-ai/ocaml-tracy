
type span = int

external _tracy_enter :
  file:string -> fun_:string -> line:int -> name:string ->
  span = "ml_tracy_enter"
external _tracy_exit : span -> unit = "ml_tracy_exit"
external _tracy_name_thread : string -> unit = "ml_tracy_name_thread"
external _tracy_msg : string -> unit = "ml_tracy_msg"
external _tracy_plot : string -> float -> unit = "ml_tracy_plot"
(* TODO external _tracy_set_plot_unit : string -> float -> unit = "ml_tracy_plot" *)

let enter ~file ~line ?(fun_name="<fun>") ~name () : span =
  _tracy_enter ~file ~fun_:fun_name ~line ~name

let exit = _tracy_exit
let name_thread = _tracy_name_thread
let message = _tracy_msg
let plot = _tracy_plot

let[@inline] with_ ~file ~line ?fun_name ~name () f =
  let _sp = enter ~file ~line ?fun_name ~name () in
  try let x=f() in exit _sp; x
  with e ->
    exit _sp; raise e
