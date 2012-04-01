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
	 (test-source
	  (source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources"))
	 (name 'artifact-name)
	 (url "download-url")
	 (fmt "artifact ~S download from ~% ~S ~% to directory ~S ~%")
	 (test-artifact
	  (artifact name url 'pharov10))
	 (string-port (open-output-string))
	 (expected (format #f fmt name url (symbol->string name))) 
	 )

    (artifact:print test-artifact string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )
