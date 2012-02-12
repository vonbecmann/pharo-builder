(use-modules (oop goops))
(use-modules (unit-test))
(use-modules ((core artifact)
		:select ( print )
		:renamer (symbol-prefix-proc 'artifact:)
		))
(use-modules (api))


(define-class <artifact-test> (<test-case>)
  )

(define-method (test-artifact-print-to-string (self <artifact-test>))
  (let* ( 
	 (name 'artifact-name)
	 (url "download-url")
	 (fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
	 (test-artifact
	  (artifact
	   name
	   url))
	 (string-port (open-output-string))
	 (expected (format #f fmt name url (symbol->string name))) 
	 )

    (artifact:print test-artifact string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )
