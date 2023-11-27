(in-package :glacier)

(defun summarize-all (&key (directory #p"~/var/"))
  "Summarize all data files in DIRECTORY"
  (let ((files (directory (merge-pathnames "*.out" directory)))) ;; *.out changes
    (dolist (file files)
      (format *standard-output* "~&~a~&~a~%" file (summarize file)))
    (format *standard-output* "~&Summarized ~d files." (length files))))

(defun summarize (file)
  (let ((f (detect-serialization file)))
    (unless f
      (error "Failed to detect serialization strategy for ~a" file))
    (funcall f file)))

(defun detect-serialization (file)
  (let ((magic (uiop:run-program `("file" ,(namestring file)) :output :string)))
    (cond
      ((or (search "text" magic)
           (search "JSON" magic))
       'summarize/json/ead4)
      (t nil))))

#| consensus-simulation output format corresponding to commit:

easye/json-last-commit 78ee5add35a3a9a35b61beaaa2081787fea9ead4
Author:     Daniel Sanchez <sanchez.quiros.daniel@gmail.com>
AuthorDate: Tue Sep 6 15:08:35 2022 +0200
Commit:     GitHub <noreply@github.com>
CommitDate: Tue Sep 6 06:08:35 2022 -0700

Parent:     afb7651 Use SmallRng instead of thread_rng for network behaviours (#64)
Merged:     easye/json-last-commit
Contained:  easye/json-last-commit main

Stabilised ward (#65)
|#
(defun summarize/json/ead4 (file)
  "Summarize the contents of json formatted FILE

Result is a list of rounds with each round being undecided, no, and yes votes."
  (let* ((s
           (alexandria:read-file-into-string file))
         (j
           (jsown:parse s))
         (rounds
           (loop :for column :in (get-path j '$.columns)
                 :collecting (get-path column '$.values))))
    (loop :for round :in rounds
          :collecting ;; TODO optimize
          (list 
           (length
            (remove-if-not #'zerop round))
           (length
            (remove-if-not
             (lambda (x) (= 1 x))
             round))
           (length 
            (remove-if-not
             (lambda (x) (= 2 x))
             round))))))



            
