
type span

val enable : unit -> unit

val enabled : unit -> bool

val enter :
  file:string ->
  line:int ->
  ?fun_name:string ->
  name:string ->
  unit -> span
(** Enter a span.
    @param file the filename, typically you can use [__FILE__]
    @param line the line number in [file], typically you can use [__LINE__]
    @param fun_name if provided, documents the function in which the call occurs
    @param name name for the span. This is what appears in Tracy.
*)
(* TODO: color? *)

val with_ :
  file:string ->
  line:int ->
  ?fun_name:string ->
  name:string ->
  unit -> (unit -> 'a) -> 'a
(** Run function within a span. See {!enter} for more details about the parameters. *)

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
