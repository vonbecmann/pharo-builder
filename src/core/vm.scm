;;; vm.scm --- a virtual machine

;;; Commentary:
;; execute an image

;;; History:
;; 

;;; Code:
(define-module (core vm)
   #:use-module (ice-9 format)
   #:use-module (core oscommand)
   #:export (
	     execute-vm
	     execute-headless-vm
	     make-vm
	     vm-name
	     )
)

(define (print self port)
  (define fmt "~A virtual machine at ~A ~%")
  (display (format #f
		   fmt
		   (vm-name self)
		   (path self)) port)
)

(define fields '(name path))

(define vm
  (make-record-type "vm" fields print)
)

(define make-vm
  (record-constructor vm fields)
)

(define path
  (record-accessor vm 'path)
)

(define vm-name
  (record-accessor vm 'name)
)

(define (execute-vm self image-filename output-filename)
  "execute a image and don't wait for the response.
   std error and output are redirected to OUTPUT-FILENAME"
  (let* ((cmd (list (path self) image-filename ">" output-filename "2>&1" "&")))
    (call-command-list cmd))
)

(define (execute-headless-vm self image-filename script-filename output-filename)
  "execute a image and wait for the response.
   std error and output are redirected to OUTPUT-FILENAME"
  (let* ((cmd (list (path self)
		    "-vm-display-null"
		    "-vm-sound-null"
		    image-filename
		    script-filename
		    ">" output-filename "2>&1")))
    (call-command-list cmd))
)

;;; vm.scm ends here
