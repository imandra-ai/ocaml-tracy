# OCaml-tracy [![build](https://github.com/AestheticIntegration/ocaml-tracy/actions/workflows/build.yml/badge.svg)](https://github.com/AestheticIntegration/ocaml-tracy/actions/workflows/build.yml)

This repo contains bindings to [Tracy](https://github.com/wolfpld/tracy),
a profiler and trace visualizer. It's licensed, like Tracy, under
BSD-3-Clause.

The bindings are pretty basic and go through the C API, not the C++ one (RAII is
not compatible with having a function call to enter, and one to exit).

It depends on a C++ compiler to build, along with the dependencies
of Tracy-client.

## Feature table

| feature | supported |
|------|---|
| zones | ✔ |
| messages | ✔ |
| plots | ✔ |
| locks | ❌ |
| screenshots | ❌ |
| frames | ❌ |
| gpu | ❌ |
| fibers | ❌ |

In some cases the feature might not provide all options.

## Example

The file `examples/prof1.ml` shows basic instrumentation on a program that computes
the Fibonacci function (yes, not representative) in a loop on 3 threads.
If Tracy is running and is waiting for a connection (press "connect"),
running `dune exec ./examples/prof1.exe` should start tracing
and display something like this: ![tracy screenshot](screen1.png)

## Usage

- the `tracy_client` library contains the bindings and can be
    used directly.
    The Tracy C++ client is vendored and will be
    bundled along with the bindings.

  For example in `prof1.ml`, we start with:

  ```ocaml
  module T = Tracy_client
  T.name_thread (Printf.sprintf "thread_%d" th_n);
  ```

  to name the `n`-th worker thread. Then later we have calls like:

  ```ocaml
  T.with_ ~file:__FILE__ ~line:__LINE__ "inner.fib" @@ fun _sp ->
  T.set_color _sp 0xaa000f;
  (* rest of code in the span _sp *)
  …
  ```

  to create a _span_ in Tracy, with a custom color, and the name `inner.fib`.
  One can also add text and values to the span.
  Alternatively, `Tracy_client.enter` and `Tracy_client.exit` can be used to delimit
  the span manually.

  The client automatically tries to connect to Tracy on startup.

  A pretty convenient helper is:

  ```ocaml
  let (let@) = (@@)
  ```

  to then be able to write spans this way:

  ```ocaml
  let@ _sp = T.with_ ~file:__FILE__ ~line:__LINE__ "inner.fib" in
  T.set_color _sp 0xaa000f;
  (* rest of code in the span _sp *)
  …
  ```

  For example, in a nested loop:

  ```ocaml
  let run n =
    for i=0 to n do
      let@ _sp = T.with_ ~file:__FILE__ ~line:__LINE__ "outer-loop" in
      for j=0 to n do
        let@ _sp = T.with_ ~file:__FILE__ ~line:__LINE__ "inner-loop" in
        (* do actual computation here with [i] and [j] *)
      done
    done
  ```

- The library `tracy-client.trace` turns `tracy-client` into a collector
  for [trace](https://github.com/c-cube/trace), which is a generic tracing
  library.

  In that case, `Tracy_client_trace.setup()` needs to be called at the beginning
  of the program.

## Instrumentation

Using dune and `tracy-ppx`, it should be possible to pick instrumentation at build time.
In your library, add `(instrumentation (backend tracy-client))`.

Then build with:

```
$ dune build --instrument-with tracy-client path/to/your_binary.exe
```

and it will automatically enable tracy-client.

**TODO**: there is currently no way to conditionally add spans
in the instrumentation.
