
type span = int
(* technically, [span] is [(bool,uint32)], but since tracy required 64 bits,
   it always fits *)

external _tracy_enable : unit -> unit = "ml_tracy_enable" [@@noalloc]
external _tracy_enabled : unit -> bool = "ml_tracy_enabled" [@@noalloc]
external _tracy_enter :
  file:string -> fun_:string -> line:int -> name:string ->
  span = "ml_tracy_enter" [@@noalloc]
external _tracy_exit : span -> unit = "ml_tracy_exit" [@@noalloc]
external _tracy_name_thread : string -> unit = "ml_tracy_name_thread"
external _tracy_msg : string -> unit = "ml_tracy_msg" [@@noalloc]
external _tracy_plot : string -> float -> unit = "ml_tracy_plot" [@@noalloc]
(* TODO external _tracy_set_plot_unit : string -> float -> unit = "ml_tracy_plot" *)

let enter ~file ~line ?(fun_name="<fun>") ~name () : span =
  _tracy_enter ~file ~fun_:fun_name ~line ~name

let exit = _tracy_exit
let name_thread = _tracy_name_thread
let message = _tracy_msg
let plot = _tracy_plot
let enable = _tracy_enable
let enabled = _tracy_enabled

let message_f k =
  if enabled() then (
    k (fun fmt -> Format.kasprintf message fmt)
  )

let[@inline] with_ ~file ~line ?fun_name ~name () f =
  let _sp = enter ~file ~line ?fun_name ~name () in
  try let x=f() in exit _sp; x
  with e ->
    exit _sp; raise e
