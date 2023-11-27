;;; <https://mailman.common-lisp.net/pipermail/armedbear-devel/2020-July/004074.html>

(defsystem spark
  :defsystem-depends-on (abcl-asdf)
  :depends-on (#:jss #:javaparser)
  :components ((:mvn "org.apache.spark/spark-sql_2.13" :version "3.3.1")
               (:file "package")
               (:file "spark")))
