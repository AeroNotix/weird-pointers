(defpackage :weird-pointers
  (:use :cl :bordeaux-threads :cffi)
  (:export
   #:save
   #:restore
   #:free))

(in-package :weird-pointers)

(defparameter lock (bordeaux-threads:make-lock))
(defparameter store (make-hash-table))

(defun save (v)
  (when v
    (let ((p (cffi:foreign-alloc :int)))
      (bordeaux-threads:with-lock-held (lock)
        (setf (gethash p store) v)))))

(defun restore (p)
  (when p
    (bordeaux-threads:with-lock-held (lock)
      (gethash p store))))

(defun free (p)
  (when p
    (bordeaux-threads:with-lock-held (lock)
      (remhash p store)
      (cffi:foreign-free p))))
