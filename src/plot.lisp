(in-package :glacier)

(defconstant +filename-record-separator+
  #\-)

(defun gnuplot (file)
  "Generate gnuplot command and data for FILE"
  (let ((data
          (make-pathname :defaults file
                         :type "data"))
        (plot 
          (make-pathname :defaults file
                         :type "gnuplot"))
        (summary
          (summarize file)))
    (with-open-file (out data :direction :output :if-exists :supersede)
      (loop :for (undecided no yes) :in summary
            :doing (format out "~a ~a ~a~%" undecided no yes)))
    (with-open-file (out plot :direction :output :if-exists :supersede)
      (format out "source = '~a'~%" data)
      (format out "set xlabel 'rounds'~%")
      (format out "set ylabel 'node opinions'~%")
      (format out "plot ~
source using 1 with linespoints pointnumber 3 title 'none', ~
source using 2 with linespoints pointnumber 7 title 'no', ~
source using 3 with linespoints pointnumber 11 title 'yes', ~
1/0 title '~a'~%" (gnuplot-legend file)))
    (values
     plot 
     data)))
                         
(defun parameters-for (path)
  (let* ((name
           (pathname-name path))
         (config-base
           (make-pathname :defaults path
                          :name (subseq name 0 (search
                                                (string +filename-record-separator+)
                                                name :from-end t))
                          :type "json"))
         (config
           (alexandria:read-file-into-string config-base))
         (j
           (jsown:parse config)))
    (values
     j
     config-base)))

(defun gnuplot-legend (path)
  (let ((jsown (parameters-for path)))
    (flet ((get-value (key)
             (get-path jsown key)))
      (values
       (format nil "l=~a α_1=~a α_2=~a k=~a"
               (get-value '$.consensus_settings.glacier.look_ahead)
               (get-value '$.consensus_settings.glacier.evidence_alpha)
               (get-value '$.consensus_settings.glacier.evidence_alpha_2)
               (get-value '$.consensus_settings.glacier.query.initial_query_size))
       jsown))))
      
             

   
