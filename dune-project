(lang dune 2.7)
(generate_opam_files true)
(version 0.1)

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
    trace)
  (synopsis "Client bindings to the Tracy profiler (v0.9.1)"))

(package
  (name tracy-ppx)
  (license BSD-3-Clause)
  (maintainers "Simon Cruanes")
  (authors "Simon Cruanes")
  (depends
    (ocaml (>= 4.08))
    (tracy-client (= :version))
    ppxlib
  )
  (synopsis "Instrumentation backend for `tracy-client`"))
