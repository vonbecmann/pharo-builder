;;; vm.scm --- a Virtual Machine
;;; Code:
(define-module (pharo-builder vm)
   #:use-module (oop goops)
   #:use-module (ice-9 format)
   #:use-module (pharo-builder oscommand)
   #:export (make-vm execute)
)

;;;
;;; a Virtual Machine
;;;
(define-class <VM> ()
  (path  #:accessor path
	#:init-keyword #:path-to-executable)
)

(define-method (write (obj <VM>) port)
  (define fmt "Virtual Machine at ~S ~%")
  (display (format #f
		   fmt
		   (path obj)) port)
)

(define-method (execute (obj <VM>) image-filename)
  (define cmd (list (path obj) image-filename "&"))
  (call-command-list cmd)
)

(define (make-vm path-to-executable)
  (define new-vm 
    (make <VM> #:path-to-executable path-to-executable))
  new-vm
)