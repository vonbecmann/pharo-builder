(define-module (artifact-test))
(use-modules (srfi srfi-64))
(use-modules ((core artifact)
	      :select ( print )
	      :renamer (symbol-prefix-proc 'artifact:)
	      ))
(use-modules (api))

(test-begin "artifact-test")

(define test-source
  (source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources"))
(define name 'artifact-name)
(define url "download-url")
(define fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
(define test-artifact
  (artifact name url 'pharov10))

(test-equal "artifact-print-to-string"
	    (format #f fmt name url (symbol->string name))
	    (let* ((string-port (open-output-string)))    
	      (artifact:print test-artifact string-port)
	      (get-output-string string-port)
	      )
	    )

(test-end)
