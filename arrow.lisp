(in-package :arrow)
#| <https://arrow.apache.org/cookbook/java/dataset.html#query-data-content-for-file>
import org.apache.arrow.dataset.file.FileFormat;
import org.apache.arrow.dataset.file.FileSystemDatasetFactory;
import org.apache.arrow.dataset.jni.NativeMemoryPool;
import org.apache.arrow.dataset.scanner.ScanOptions;
import org.apache.arrow.dataset.scanner.Scanner;
import org.apache.arrow.dataset.source.Dataset;
import org.apache.arrow.dataset.source.DatasetFactory;
import org.apache.arrow.memory.BufferAllocator;
import org.apache.arrow.memory.RootAllocator;
import org.apache.arrow.vector.VectorSchemaRoot;
import org.apache.arrow.vector.ipc.ArrowReader;

String uri = "file:" + System.getProperty("user.dir") + "/thirdpartydeps/parquetfiles/data1.parquet";
ScanOptions options = new ScanOptions(/*batchSize*/ 32768);
try (
    BufferAllocator allocator = new RootAllocator();
    DatasetFactory datasetFactory = new FileSystemDatasetFactory(allocator, NativeMemoryPool.getDefault(), FileFormat.PARQUET, uri);
    Dataset dataset = datasetFactory.finish();
    Scanner scanner = dataset.newScan(options);
    ArrowReader reader = scanner.scanBatches()
) {
    while (reader.loadNextBatch()) {
        try (VectorSchemaRoot root = reader.getVectorSchemaRoot()) {
            System.out.print(root.contentToTSVString());
        }
    }
} catch (Exception e) {
    e.printStackTrace();
}
|#

(defun open-parquet ()
  (let* ((allocator
           (jnew "org.apache.arrow.memory.RootAllocator"))
         (memory
           (#"getDefault" 'org.apache.arrow.dataset.jni.NativeMemoryPool))
         (file-uri
           "file:///Users/evenson/var/hawk.local-3884411569-4.out")
         (dataset-factory 
           (jnew "org.apache.arrow.dataset.file.FileSystemDatasetFactory"
                 allocator
                 memory
                 (jfield "org.apache.arrow.dataset.file.FileFormat" "PARQUET")
                 file-uri))
         (dataset
           (#"finish" dataset-factory))
         (scan-options
           (jnew "org.apache.arrow.dataset.scanner.ScanOptions" 32768)) ;; batchSize in bytes
         (scanner
           (#"newScan" dataset scan-options))
         (reader
           (#"scanBatches" scanner)))
    (values
     reader
     file-uri
     scan-options
     dataset
     dataset-factory)))

(defun test()
  (let ((reader (open-parquet)))
    (loop
      :until (not (#"loadNextBatch" reader))
      :do
         (let ((root
                 (#"getVectorSchemaRoot" reader)))
           (format *standard-output*
                   "~&~a~&"
                   (#"contentToTSVString" root))))))

         
         

    
          
