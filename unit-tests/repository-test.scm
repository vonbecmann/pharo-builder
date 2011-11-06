(define-module (pharo-builder unit-tests repository-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module (pharo-builder core oscommand)
  #:use-module ((pharo-builder core repository)
		:select ( print )
		:renamer (symbol-prefix-proc 'repository:)
		)
  #:use-module (pharo-builder pharo-builder)
  )

(define-class <repository-test> (<test-case>)
  )

(define-method (test-repository-print-to-string (self <repository-test>))
  (let* ( 
	 (directory-name ".my-repository")
	 (full-path (path-join uwd directory-name))
	 (fmt "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
	 (test-repository
	    (repository directory-name
		   '()))
	 (string-port (open-output-string))
	 (expected (format #f fmt full-path '())) 
	 )

    (repository:print test-repository string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )


