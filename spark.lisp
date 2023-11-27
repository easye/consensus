(in-package :spark)

#|

String logFile = "YOUR_SPARK_HOME/README.md"; // Should be some file on your system
SparkSession spark = SparkSession.builder().appName("Simple Application").getOrCreate();
Dataset<String> logData = spark.read().textFile(logFile).cache();

|#

(defun test ()
  (let* ((log
           #p"~/tmp/xx.log")
         (spark
           (#"getOrCreate"
            (#"appName"
             (#"builder" 'SparkSession)
             "Simple Application"))))
    spark))
         
            
           
           
    
    
