(in-package :orient.base.util)

(defun comma-list (things &key (separator ", ") before after)
  (with-output-to-string (out)
    (when before (princ separator out))
    (loop for (thing . rest) on things
          do (princ thing out)
          when rest do (princ separator out))
    (when after (princ separator out))))


(defun string-split (delimiter string &key (start 0) end )
  (let* ((next-function (typecase delimiter
                          (string
                           (let ((length (length delimiter)))
                             (lambda (start end)
                               (let ((position (search delimiter string :start2 start :end2 end)))
                                 (values position (and position (+ position length)))))))
                          (character
                           (lambda (start end)
                             (let ((position (position delimiter string :start start :end end)))
                               (values position (and position (1+ position))))))))
         (real-end (or end (length string))))
    (loop with next-position = nil and next-start = nil
       do (multiple-value-setq (next-position next-start) (funcall next-function start end))
       collect (subseq string start (or next-position real-end))
       while next-position
       do (setq start next-start)
       when (> start real-end) do (loop-finish))))
