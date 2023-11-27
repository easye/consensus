(defsystem glacier
  :version "0.0.2"
  :depends-on (alexandria
               do-urlencode
               jsown
               split-sequence)
  :components ((:module source
                :pathname "./"
                :components ((:file "package")
                             (:file "json-path")
                             (:file "summarize")
                             (:file "plot")
                             (:file "runner")
                             (:file "glacier")))))
                
