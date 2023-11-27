(in-package :glacier)

(defun jsown-template ()
  "Return the json template in jsown format used for each run"
  '(:OBJ
    ("consensus_settings"
     :OBJ
     ("glacier"
      :OBJ
      ("evidence_alpha" . 0.8 )
      ("evidence_alpha_2" . 0.5)
      ("confidence_beta" . 1.0)
      ("look_ahead" . 500)
      ("query" :OBJ
       ("query_size" . 100)
       ("initial_query_size" . 100)
       ("query_multiplier" . 1)
       ("max_multiplier" . 1))))
    ("distribution"
     :OBJ ("yes" . 0.5)  ("no" . 0.5) ("none" . 0))
    ("byzantine_settings"
     :OBJ ("total_size" . 10000)
     ("distribution"
      :OBJ ("honest" . 1) ("infantile" . 0) ("random" . 0) ("omniscient" . 0)))
    ("wards" (:OBJ ("time_to_finality" :OBJ ("ttf_threshold" . 100))))
    ("simulation_style" . "Sync")
    ("network_modifiers" (:OBJ ("random_drop" :OBJ ("drop_rate" . 0))))))

;;; N.b. assumes that all JSON keys are 1) lowercase, and 2) unique
(defun encode-parameters (jsown)
  "Encode the Glacier parameters specfied by the JSOWN settings as a string suitable for use in a filename"
  ;; TODO write the inverse of this function to parse parameters from a filename
  (let* ((key-json-paths
	  (loop :for (json-path _) :on (json-parameters) :by #'cddr
		:collecting json-path))
	 (keys
	   (loop :for key :in key-json-paths
		 :collecting (cons
			      (first (last (parse-json-path key)))
			      key)))
	 (key-values
	   (loop :for (key . path-symbol) :in keys
		 :collecting (cons
			      key
			      (ignore-errors
			       (get-path jsown
					 (parse-json-path path-symbol))))))
	 (string
	   (values
	    (format nil "~{~a ~}"
		    (loop for (key . value) :in key-values
			  :collecting (format nil "~a=~a" key value))))))
    (values
     (do-urlencode:urlencode string :queryp t)
     string)))

(defun decode-parameters (filename)
  (let ((name (pathname-name (pathname filename))))
    (do-urlencode:urldecode name :queryp t)))

;;; unused
(defun json-parameters ()
  `($.consensus_settings.glacier.evidence_alpha
    0.8 ;;4/5
    $.consensus_settings.glacier.evidence_alpha_2
    0.4 ;;2/5
    $.consensus_settings.glacier.confidence_beta
    1 
    $.consensus_settings.glacier.look_ahead
    997
    $.consensus_settings.glacier.query.query_size  ;; difference from initial_query_size ?
    100
    $.consensus_settings.glacier.query.initial_query_size
    100
    $.consensus_settings.glacier.query.query_multiplier
    2
    $.consensus_settings.glacier.query.max_multiplier
    1
    $.byzantine_settings.total_size
    ,(expt 10 4)
    $.byzantine_settings.distribution.honest
    1
    $.distribution.yes
    0.5 ;;1/2
    $.distribution.no
    0.5))

;;; unused
(defun grind ()
  (let* ((template
           (probe-file "~/work/consensus-prototypes/etc/glacier.json"))
         (json
           (alexandria:read-file-into-string template))
         (result
           (jsown:parse json)))
    ;; TODO set the template based on the parameters
    (values
     result
     template)))

