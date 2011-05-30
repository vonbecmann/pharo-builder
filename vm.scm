;;; vm.scm --- a virtual machine

;;; Commentary:
;; execute an image


;;; History:
;; 

;;; Code:
(define-module (pharo-builder vm)
   #:use-module (oop goops)
   #:use-module (ice-9 format)
   #:use-module (pharo-builder oscommand)
   #:export (
	     execute
	     <vm>
	     )
)

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
  (let* ((cmd (list (path obj) image-filename "&")))
    (call-command-list cmd))
)

;;; vm.scm ends here
