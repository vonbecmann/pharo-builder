;;; vm.scm --- a virtual machine

;;; Commentary:
;; execute an image


;;; History:
;; 

;;; Code:
(define-module (pharo-builder core vm)
   #:use-module (oop goops)
   #:use-module (ice-9 format)
   #:use-module (pharo-builder core oscommand)
   #:export (
	     execute-vm
	     execute-headless-vm
	     <vm>
	     vm-name
	     )
)

(define-class <vm> ()
  (name #:accessor vm-name
	#:init-keyword #:name)
  (path  #:accessor path
	#:init-keyword #:path-to-executable)
)

(define-method (write (self <vm>) port)
  (define fmt "Virtual Machine at ~S ~%")
  (display (format #f
		   fmt
		   (path self)) port)
)

(define-method (execute-vm (self <vm>) image-filename)
  "execute a image and don't wait for response."
  (let* ((cmd (list (path self) image-filename "&")))
    (call-command-list cmd))
)

(define-method (execute-headless-vm (self <vm>) image-filename script-filename)
  "execute a image and don't wait for response."
  (let* ((cmd (list (path self)
		    "-vm-display-null"
		    "-vm-sound-null"
		    image-filename script-filename)))
    (call-command-list cmd))
)

;;; vm.scm ends here
