(define-module (pharo-builder tests project-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module (pharo-builder core project)
  #:use-module (pharo-builder conf-builder)
  )


(define-class <project-test> (<test-case>)
  )

(define-method (test-write-to-string (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (artifact-name "pharo-core")
	 (fmt "project at ~A based on ~A")
	 (test-artifact 
	  (artifact 
	   artifact-name
	   "a-directory" 
	   "http:/download/url"))
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 (string-port (open-output-string))
	 (test-project (project directory-name test-vm test-artifact))
	 (expected (format #f fmt directory-name artifact-name)) 
	 )

    (write test-project string-port)
    (assert-equal  expected (get-output-string string-port))
    )
  )

(define-method (test-set-up-script-at-project (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (artifact-name "pharo-core")
	 (test-artifact 
	  (artifact 
	   artifact-name
	   "a-directory" 
	   "http:/download/url"))
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 (test-project (project directory-name test-vm test-artifact))
	 (expected "/test-project/set-up.st") 
	 )

    (assert-equal  expected (set-up-script-at test-project))
    )
  )

(define-method (test-write-project-definition-to-string (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (artifact-name "pharo-core")
	 (vm-name "test-vm")
	 (test-artifact 
	  (artifact 
	   artifact-name
	   "a-directory" 
	   "http:/download/url"))
	 (test-vm
	  (vm 
	   vm-name
	   "/path/to/vm"))
	 (test-project (project directory-name test-vm test-artifact))
	 (expected (format #f 
			   "(define current-project \n\t (project \n\t ~S\n\t ~a\n\t ~a\n\t)\n)" 
			   directory-name 
			   "test-vm" 
			   artifact-name)
	    )
	 )
    (assert-equal expected (with-output-to-string (project-definition test-project)))
    )
)
