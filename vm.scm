;;; vm.scm --- a Virtual Machine
;;; Code:
(define-module (pharo-builder vm)
   #:use-module (oop goops)
   #:use-module (ice-9 format)
   #:use-module (pharo-builder oscommand)
   #:export (
	     make-vm 
	     execute
	     )
)

;;;
;;; a Virtual Machine
;;;
(define-class <vm> ()
  (path  #:accessor path
	#:init-keyword #:path-to-executable)
)

(define-method (write (obj <vm>) port)
  (define fmt "Virtual Machine at ~S ~%")
  (display (format #f
		   fmt
		   (path obj)) port)
)

(define-method (execute (obj <vm>) image-filename)
  "execute a image and don't wait for response."
  (define cmd (list (path obj) image-filename "&"))
  (call-command-list cmd)
)

(define (make-vm path-to-executable)
  "create a new vm with PATH-TO-EXECUTABLE."
  (define new-vm 
    (make <vm> #:path-to-executable path-to-executable))
  new-vm
)