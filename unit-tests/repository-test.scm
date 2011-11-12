(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (core oscommand))
(use-modules ((core repository)
		:select ( print )
		:renamer (symbol-prefix-proc 'repository:)
		))
(use-modules (pharo-builder))


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


