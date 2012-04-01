(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (core oscommand))
(use-modules ((core repository)
		:select (print artifact-ref new-repository-for add-artifact)
		:renamer (symbol-prefix-proc 'repository:)
		))
(use-modules (api))


(define-class <repository-test> (<test-case>)
  )

(define-method (test-repository-print-to-string (self <repository-test>))
  (let* ( 
	 (directory-name ".my-repository")
	 (fmt "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
	 (test-repository
	    (repository:new-repository-for directory-name)
	    )
	 (string-port (open-output-string))
	 (expected (format #f fmt directory-name '())) 
	 )

    (repository:print test-repository string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )

(define-method (test-artifact-ref (self <repository-test>))
  (let* ( 
	 (test-source
	  (source 'pharov10 "PharoV10.sources" "/home/vonbecmann/bin/sources"))
	 (test-artifact (artifact 'pharo-core "http:/download/url" 'pharov10))
	 (test-repository (repository:new-repository-for "directory-name" ))
	 )
    (repository:add-artifact test-repository test-artifact)
    (display test-repository)
    (assert-equal test-artifact (repository:artifact-ref test-repository 'pharo-core))
    )
  )

