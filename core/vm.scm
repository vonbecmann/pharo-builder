;;; vm.scm --- a virtual machine

;;; Commentary:
;; execute an image


;;; History:
;; 

;;; Code:
(define-module (pharo-builder core vm)
   #:use-module (ice-9 format)
   #:use-module (pharo-builder core oscommand)
   #:export (
	     execute-vm
	     execute-headless-vm
	     make-vm
	     vm-name
	     print
	     )
)

(define (print self port)
  (define fmt "~A virtual machine at ~A ~%")
  (display (format #f
		   fmt
		   (vm-name self)
		   (path self)) port)
)

(define vm 
  (make-record-type "vm" '(name path) print)
)

(define make-vm
  (record-constructor vm '(name path))
)

(define path 
  (record-accessor vm 'path)
)

(define vm-name
  (record-accessor vm 'name)
)

(define (execute-vm self image-filename)
  "execute a image and don't wait for response."
  (let* ((cmd (list (path self) image-filename "&")))
    (call-command-list cmd))
)

(define (execute-headless-vm self image-filename script-filename)
  "execute a image and don't wait for response."
  (let* ((cmd (list (path self)
		    "-vm-display-null"
		    "-vm-sound-null"
		    image-filename script-filename)))
    (call-command-list cmd))
)

;;; vm.scm ends here
