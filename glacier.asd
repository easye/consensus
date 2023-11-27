(defsystem glacier
  :version "0.0.2"
  :depends-on (alexandria
               do-urlencode
               jsown
               split-sequence)
  :in-order-to ((test-op (test-op glacier/t)))
  :components ((:module source
                :pathname "./src/"
                :components ((:file "package")
                             (:file "json-path")
                             (:file "summarize")
                             (:file "plot")
                             (:file "runner")
                             (:file "glacier")))))
                
(defsystem glacier/t
  :defsystem-depends-on (prove-asdf)
  :depends-on (prove glacier)
  :perform  (test-op :after (o s)
                     (uiop:symbol-call :prove 'run s))
  :components ((:module test
                :pathname "./t/"
                :components ((:test-file "run")))))


