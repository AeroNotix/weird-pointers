(defpackage :weird-pointers
  (:use :cl :bordeaux-threads :cffi)
  (:export
   #:save
   #:restore
   #:free))

(in-package :weird-pointers)

(defparameter lock (bordeaux-threads:make-lock))
(defparameter store (make-hash-table))
#+(or cmu scl)
(defparameter ptr-int #'sys:sap-int)
#+(or sbcl)
(defparameter ptr-int #'sb-sys:sap-int)

(defun save (v)
  (when v
    (let ((p (cffi:foreign-alloc :int)))
      (bordeaux-threads:with-lock-held (lock)
        (setf (gethash (funcall ptr-int p) store) v))
      p)))

(defun restore (p)
  (when p
    (bordeaux-threads:with-lock-held (lock)
      (gethash (funcall ptr-int p) store))))

(defun free (p)
  (when p
    (bordeaux-threads:with-lock-held (lock)
      (remhash (funcall ptr-int p) store)
      (cffi:foreign-free p))))
