(in-package :parquet)

;;; <https://www.arm64.ca/post/reading-parquet-files-java/>

(defun config ()
  (let ((result
          (java:jnew "org.apache.hadoop.conf.Configuration")))
;;    (#"setClassLoader" result (java:get-current-classloader))
    (#"set" result "fs.file.impl" 
            "org.apache.hadoop.fs.LocalFileSystem")
    result))
    

(defun input-file (&key
                   (config
                    (config))
                     (file-url
                      "file:///Users/evenson/var/hawk.local-3884411569-4.out"))
  (let
      ((path
         (java:jnew "org.apache.hadoop.fs.Path" file-url)))
    (#"fromPath" 'HadoopInputFile path config)))

(defun get-parquet-data (&key (input-file (input-file))
                              (config (config)))
                                          
  (let*
      ((reader
         (#"open" 'ParquetFileReader input-file)))
    reader))


#|
 public static Parquet getParquetData(String filePath) throws IOException {
        List<SimpleGroup> simpleGroups = new ArrayList<>();
        ParquetFileReader reader = ParquetFileReader.open(HadoopInputFile.fromPath(new Path(filePath), new Configuration()));
        MessageType schema = reader.getFooter().getFileMetaData().getSchema();
        List<Type> fields = schema.getFields();
        PageReadStore pages;
        while ((pages = reader.readNextRowGroup()) != null) {
            long rows = pages.getRowCount();
            MessageColumnIO columnIO = new ColumnIOFactory().getColumnIO(schema);
            RecordReader recordReader = columnIO.getRecordReader(pages, new GroupRecordConverter(schema));

            for (int i = 0; i < rows; i++) {
                SimpleGroup simpleGroup = (SimpleGroup) recordReader.read();
                simpleGroups.add(simpleGroup);
            }
        }
        reader.close();
        return new Parquet(simpleGroups, fields);
    }
#|

#+nil
(defun test ()
  (#"main" 'org.apache.parquet.cli.Main
           java:+null+))

