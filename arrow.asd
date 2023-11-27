(defsystem arrow
  :defsystem-depends-on (abcl-asdf)
  :depends-on (jss)
  :components ((:module maven
                :components ((:mvn "org.apache.arrow/arrow-dataset/11.0.0")
                             (:mvn "org.apache.arrow/flight-core/11.0.0")))
               (:module package :pathname "./"
                :components ((:file "package")))
               (:module source :pathname "./"
                :depends-on (package maven)
                :components ((:file "arrow")))))


  
