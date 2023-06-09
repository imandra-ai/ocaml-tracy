(lang dune 2.6)
(generate_opam_files true)
(version 0.1)

(name tracy)
(homepage "https://github.com/imandra-ai/ocaml-tracy")
(bug_reports "https://github.com/imandra-ai/ocaml-tracy/issues")
(source (github "imandra-ai/ocaml-tracy"))

(package
  (name tracy)
  (license BSD-3-Clause)
  (maintainers "Simon Cruanes")
  (authors "Simon Cruanes")
  (depends (ocaml (>= 4.08)))
  (synopsis "Virtual package for the Tracy profiler https://github.com/wolfpld/tracy"))

(package
  (name tracy-client)
  (license BSD-3-Clause)
  (maintainers "Simon Cruanes")
  (authors "Bartosz Taudul" "Simon Cruanes")
  (depends
    (ocaml (>= 4.08))
    (tracy (= :version))
  )
  (synopsis "Actual bindings to the Tracy profiler (v0.9.1), implements `tracy`"))

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
