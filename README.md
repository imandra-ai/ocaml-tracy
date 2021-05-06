# OCaml-tracy

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
| locks | × |
| screenshots | × |
| frames | × |
| gpu | × |

In some cases the feature might not provide all options. For example
there is no way of specifying colors for zones yet.
