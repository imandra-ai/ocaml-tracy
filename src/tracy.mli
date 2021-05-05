
type span

val enable : unit -> unit

val enabled : unit -> bool

val enter :
  file:string ->
  line:int ->
  ?fun_name:string ->
  name:string ->
  unit -> span
(** Enter a span *)

val with_ :
  file:string ->
  line:int ->
  ?fun_name:string ->
  name:string ->
  unit -> (unit -> 'a) -> 'a
(** Run function within a span *)

val exit : span -> unit
(** Must be called on the same thread as {!enter} *)

val name_thread : string -> unit
(** Give a name to the current thread *)

val message : string -> unit
(** Send a message *)

val message_f : ((('a, Format.formatter, unit, unit) format4 -> 'a) -> unit) -> unit
(** Send a formatted message.
    Usage: [message_f (fun k -> k "hello %s %d" "world" 42)] *)

val plot : string -> float -> unit
