(lang dune 2.6)
(generate_opam_files true)

(name tracy)
(homepage "https://github.com/AestheticIntegration/ocaml-tracy")
(bug_reports "https://github.com/AestheticIntegration/ocaml-tracy/issues")

(package
  (name tracy)
  (license BSD-3-Clause)
  (maintainers "Simon Cruanes")
  (authors "Simon Cruanes")
  (synopsis "Virtual package for the Tracy profiler https://github.com/wolfpld/tracy"))

(package
  (name tracy-client)
  (license BSD-3-Clause)
  (maintainers "Simon Cruanes")
  (authors "Bartosz Taudul" "Simon Cruanes")
  (depends
    (tracy (= :version))
  )
  (synopsis "Actual bindings to the Tracy profiler, implements `tracy`"))
