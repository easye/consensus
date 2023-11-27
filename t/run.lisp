(in-package :cl-user)


#+nil
(prove:plan 1)
#+nil
(prove:ok
 (claro:search-parameters)
 "Rust simulation runner is present")

(prove:plan 1)
(prove:ok
 (claro:summarize
  (asdf:system-relative-pathname :glacier "t/eg/hawk.local-3910065047-4.out"))
 "Able to summarize results")


(prove:plan 1)
(prove:ok
 (claro::gnuplot
  (asdf:system-relative-pathname :glacier "t/eg/hawk.local-3910065047-4.out"))
 "Able to generate gnuplot from results")
        

(prove:finalize)
