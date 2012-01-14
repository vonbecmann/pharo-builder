(use-modules (oop goops))
(use-modules (unit-test))
(use-modules ((core project)
		:select (
			 print
			 set-up-script-at
			 project-definition
			 make-project
			 )
		:renamer (symbol-prefix-proc 'project:)
		))
(use-modules (pharo-builder))


(define-class <project-test> (<test-case>)
  )

(define-method (test-project-print-to-string (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (artifact-name 'pharo-core)
	 (fmt "project at ~A based on ~A")
	 (test-artifact (artifact  artifact-name "http:/download/url"))
	 (test-vm  (vm 'test-vm "/path/to/vm"))
	 (string-port (open-output-string))
	 (test-project (project:make-project directory-name test-vm test-artifact ".package-cache"))
	 (expected (format #f fmt directory-name artifact-name)) 
	 )

    (project:print test-project string-port)
    (assert-equal  expected (get-output-string string-port))
    )
  )

(define-method (test-set-up-script-at-project (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (test-artifact (artifact 'pharo-core "http:/download/url"))
	 (test-vm (vm 'test-vm "/path/to/vm"))
	 (test-project (project:make-project directory-name test-vm test-artifact ".package-cache"))
	 (expected "file:/test-project/set-up.st") 
	 )

    (assert-equal expected (project:set-up-script-at test-project))
    )
  )

(define-method (test-write-project-definition-to-string (self <project-test>))
  (let* ( 
	 (directory-name "/test-project")
	 (artifact-name 'pharo-core)
	 (vm-name 'test-vm)
	 (test-artifact (artifact artifact-name "http:/download/url"))
	 (test-vm (vm vm-name "/path/to/vm"))
	 (test-project (project:make-project directory-name test-vm test-artifact "./package-cache"))
	 (expected (format #f 
			   "(project\n\t ~S\n\t '~a\n\t '~a\n\t)\n" 
			   directory-name 
			   "test-vm" 
			   artifact-name)
	    )
	 )
    (assert-equal expected (with-output-to-string (project:project-definition test-project)))
    )
)

