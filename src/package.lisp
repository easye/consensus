(defpackage claro
  (:nicknames :glacier)
  (:use #:cl
        #+nil
        #:java)
  (:export
   #:summarize
   #:summarize-all
   #:run
   #:search-parameters))

#+abcl
(defpackage parquet
  (:use :cl :java)
  (:export
   #:open-parquet
   #:test))

#+abcl
(defpackage arrow
  (:use :cl :java)
  (:export
   #:open-parquet
   #:test))

#+abcl
(defpackage spark
  (:use :cl :java)
  (:export
   #:test))


  

