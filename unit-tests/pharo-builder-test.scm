(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (core pharo-builder))


(define-class <pharo-builder-test> (<test-case>)
  )

(define-method (test-pharo-builder-print-to-string (self <pharo-builder-test>))
  (let* ( 
	 (directory-name "a-directory")
	 (user-directory "user-directory")
	 (current-directory "current-directory")
	 (package-directory "4")
	 (current-project '())
	 (fmt "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n package cache directory: ~S \n current ~S \n")
	 (string-port (open-output-string))
	 (expected (format #f fmt 
			   directory-name 
			   user-directory 
			   current-directory 
			   package-directory
			   current-project)) 
	 (test-pharo-builder 
	   (make-pharo-builder
	     directory-name
	     user-directory
	     current-directory
	     package-directory
	     current-project
	     '()
	     (make-hash-table)
	     ))
	     
	 )

    (write test-pharo-builder string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )