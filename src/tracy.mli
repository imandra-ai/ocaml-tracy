
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

val add_text : span -> string -> unit
(** [add_text span s] annotates the span with text [s]. This can
    be called several times on the same span. *)

val add_text_f :
  span ->
  ((('a, Format.formatter, unit, unit) format4 -> 'a) -> unit) -> unit
(** Formatted version of {!add_text}.

    Usage: [add_text_f span (fun k -> k "some %s message! (%d/100)" "formatted" 100)].
*)

val add_value : span -> int64 -> unit
(** [add_value span v] annotates the span with a numeric value (which should
    be unsigned). *)

val set_color : span -> int -> unit
(** [set_color span c] sets the color of the span.

    [c] is an integer that represents a color using a RGB triple
    as follows: [0xRRGGBB]. *)

val with_ :
  file:string ->
  line:int ->
  ?fun_name:string ->
  name:string ->
  unit -> (span -> 'a) -> 'a
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
