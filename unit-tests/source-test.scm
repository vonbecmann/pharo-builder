(use-modules (oop goops))
(use-modules (unit-test))
(use-modules ((core source)
		:select ( print )
		:renamer (symbol-prefix-proc 'source:)
		))
(use-modules (api))


(define-class <source-test> (<test-case>)
  )

(define-method (test-source-print-to-string (self <source-test>))
  (let* ( 
	 (name 'source-name)
	 (filename "PharoV10.source")
	 (directory "directory-name")
	 (fmt "source ~S named ~S at directory ~S ~%")
	 (test-source (source name filename directory))
	 (string-port (open-output-string))
	 (expected (format #f fmt name filename directory)) 
	 )

    (source:print test-source string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )
