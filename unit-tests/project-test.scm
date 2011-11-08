(define-module (pharo-builder unit-tests project-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module ((pharo-builder core project)
		:select (
			 print
			 set-up-script-at
			 project-definition
			 )
		)
  #:use-module (pharo-builder pharo-builder)
  )


(define-class <project-test> (<test-case>)
  )

(define-method (test-project-print-to-string (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (artifact-name "pharo-core")
	 (fmt "project at ~A based on ~A")
	 (test-artifact 
	  (artifact 
	   artifact-name
	   "http:/download/url"))
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 (string-port (open-output-string))
	 (test-project (project directory-name test-vm test-artifact))
	 (expected (format #f fmt directory-name artifact-name)) 
	 )

    (print test-project string-port)
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
	   "http:/download/url"))
	 (test-vm
	  (vm 
	   vm-name
	   "/path/to/vm"))
	 (test-project (project directory-name test-vm test-artifact))
	 (expected (format #f 
			   "(project\n\t ~S\n\t ~a\n\t ~a\n\t)\n" 
			   directory-name 
			   "test-vm" 
			   artifact-name)
	    )
	 )
    (assert-equal expected (with-output-to-string (project-definition test-project)))
    )
)