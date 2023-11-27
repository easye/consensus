;;;; TODO package separate as JSON Path utilities
(in-package glacier)

(defun parse-json-path (symbol)
  "Transform a symbol into a list names of json nodes to navigate"
  (rest (split-sequence:split-sequence #\. (string-downcase
                                            (symbol-name symbol)))))

;;  TODO implement array selectors
(defun get-path (jsown path)
  (cond ((symbolp path)
         (get-path jsown
                   (parse-json-path path)))
         ((stringp path)
          (jsown:filter jsown path))
         ((and (consp path)
               (= 1 (length path)))
          (jsown:filter jsown (first path)))
         (t 
          (get-path
           (jsown:filter jsown (first path))
           (rest path)))))

(defun set-path (jsown path value)
  (cond ((symbolp path)
         (set-path jsown
                   (parse-json-path path)
                   value))
        ((stringp path)
         (setf 
          (jsown:filter jsown path)
          value))
        ((and (consp path)
              (= 1 (length path)))
         (setf
          (jsown:filter jsown (first path))
          value))
        (t 
         (set-path
          (jsown:filter jsown (first path))
          (rest path)
          value))))


#|  It would have be nice to use JSOWN:FILTER like this…

(defun set-path (jsown path value)
  (setf
   (jsown:filter jsown (parse-json-path path))
   value)
jsown)

but that doesn't easily work due to JSOWN:FILTER being a macro, so one
can't use CL:REDUCE
|#


