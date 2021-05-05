
type span

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

val plot : string -> float -> unit
