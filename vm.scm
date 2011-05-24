;;; vm.scm --- a Virtual Machine
;;; Code:
(define-module (pharo-builder vm)
   #:use-module (oop goops)
   #:use-module (ice-9 format)
   #:export (make-vm)
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

(define (make-vm path-to-executable)
  (define new-vm 
    (make <VM> #:path-to-executable path-to-executable))
  new-vm
)