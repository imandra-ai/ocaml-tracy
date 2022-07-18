
type span = unit

let enter ?cs_depth:_ ~file:_ ~line:_ ?fun_name:_ ~name:_ () : span = ()

let exit _ = ()
let name_thread _ = ()
let message _ = ()
let plot _ _ = ()
let enable _ = ()
let enabled () = false
let set_color _ _ = ()
let add_value _ _ = ()
let add_text _ _ = ()
let set_app_info _ = ()

let message_f _ = ()
let add_text_f _ _ = ()

let[@inline] with_ ?cs_depth:_ ~file:_ ~line:_ ?fun_name:_ ~name:_ () f = f()
