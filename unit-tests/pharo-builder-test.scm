(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (pharo-builder))


(define-class <pharo-builder-test> (<test-case>)
  )

(define-method (test-pharo-builder-print-to-string (self <pharo-builder-test>))
  (let* ( 
	 (directory-name "a-directory")
	 (user-directory "user-directory")
	 (current-directory "current-directory")
	 (package-directory "4")
	 (fmt "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n package cache directory: ~S \n")
	 (string-port (open-output-string))
	 (expected (format #f fmt 
			   directory-name 
			   user-directory 
			   current-directory 
			   package-directory)) 
	 (test-pharo-builder 
	   (make <pharo-builder>
	     #:directory-name directory-name
	     #:user-directory user-directory
	     #:current-directory current-directory
	     #:package-cache-directory package-directory
	     ))
	     
	 )

    (write test-pharo-builder string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )