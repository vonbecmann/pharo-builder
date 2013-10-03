(define-module (source-test))
(use-modules (srfi srfi-64))
(use-modules ((core source)
		:select ( print )
		:renamer (symbol-prefix-proc 'source:)
		))
(use-modules (api))

(test-begin "source-test")

(define name 'source-name)
(define filename "PharoV10.source")
(define directory "directory-name")
(define fmt "source ~S named ~S at directory ~S ~%")

(test-equal "source-print-to-string"
	    (format #f fmt name filename directory)
	    (let* (
		   (test-source (source name filename directory))
		   (string-port (open-output-string))
		   )
	      (source:print test-source string-port)
	      (get-output-string string-port)
	      )
)

(test-end)