(lang dune 2.7)
(generate_opam_files true)
(version 0.4)

(name tracy-client)
(homepage "https://github.com/imandra-ai/ocaml-tracy")
(bug_reports "https://github.com/imandra-ai/ocaml-tracy/issues")
(source (github "imandra-ai/ocaml-tracy"))

(package
  (name tracy-client)
  (license BSD-3-Clause)
  (maintainers "Simon Cruanes")
  (authors "Bartosz Taudul" "Simon Cruanes")
  (depends
    (ocaml (>= 4.08))
    (trace (and (>= 0.4) (< 0.6))))
  (synopsis "Client bindings to the Tracy profiler (v0.10)"))
