(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (pharo-builder))


(define-class <pharo-builder-test> (<test-case>)
  )

(define-method (test-vm (self <pharo-builder-test>))
  (let* ( 
	 (test-vm (vm 'test-vm "/path/to/vm"))
	 )
    (assert-true (record? test-vm))
    )
  )

(define-method (test-artifact (self <pharo-builder-test>))
  (let* ( 
	 (test-artifact (artifact 'pharo-core "http:/download/url"))
	 )
    (assert-true (record? test-artifact))
    )
  )


(define-method (test-repository (self <pharo-builder-test>))
  (let* ( 
	 (test-artifact (artifact 'pharo-core "http:/download/url"))
	 (test-repository (repository "directory-name" 
				      (list test-artifact test-artifact)))
	 )
    (assert-true (record? test-repository))
    )
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