#|
<dependencies>
    <dependency>
        <groupId>org.apache.parquet</groupId>
        <artifactId>parquet-avro</artifactId>
        <version>1.10.0</version>
    </dependency>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-common</artifactId>
        <version>3.1.0</version>
    </dependency>
</dependencies>
|#
(defsystem parquet
  :defsystem-depends-on (jss abcl-asdf)
  :perform (load-op (o c)
                    (#"setContextClassLoader" (#"currentThread" 'Thread)
                                              (java:get-current-classloader))
                    (call-next-method o c))
  :components ((:module maven
                :components ((:mvn "org.apache.parquet/parquet-avro/1.10.0")
                             (:mvn "org.apache.hadoop/hadoop-common/3.1.4")
                             (:mvn "org.apache.hadoop/hadoop-client-api/3.1.4")))
               (:module package :pathname "./"
                :components ((:file "package")))
               (:module source :pathname "./"
                :depends-on (package maven)
                :components ((:file "parquet")))))

  
