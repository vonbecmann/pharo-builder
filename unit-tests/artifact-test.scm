(define-module (artifact-test))
(use-modules (srfi srfi-64))
(use-modules (api))

(test-begin "artifact-test")

(define name 'artifact-name)
(define url "download-url")
(define fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
(define test-artifact (single-artifact name url))

(test-equal "artifact-print-to-string"
	    (format #f fmt name url (symbol->string name))
	    (let* ((string-port (open-output-string)))    
	      (display test-artifact string-port)
	      (get-output-string string-port)
	      )
	    )

(test-end)
