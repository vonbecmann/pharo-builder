(define-module (pharo-builder tests pharo-builder-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module (pharo-builder pharo-builder)
  )

(define-class <pharo-builder-test> (<test-case>)
  )

(define-method (test-vm (self <pharo-builder-test>))
  (let* ( 
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 )
    (assert-true (record? test-vm))
    )
  )

(define-method (test-artifact (self <pharo-builder-test>))
  (let* ( 
	 (test-artifact 
	  (artifact 
	   "pharo-core"
	   "a-directory" 
	   "http:/download/url"))
	 )
    (assert-true (record? test-artifact))
    )
  )

(define-method (test-project (self <pharo-builder-test>))
  (let* ( 
	 (test-artifact 
	  (artifact 
	   "pharo-core"
	   "a-directory" 
	   "http:/download/url"))
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 (test-project (project "/test-project" test-vm test-artifact))
	 )
    (assert-true (record? test-project))
    )
  )

(define-method (test-repository (self <pharo-builder-test>))
  (let* ( 
	 (test-artifact 
	  (artifact 
	   "pharo-core"
	   "a-directory" 
	   "http:/download/url"))
	 (test-repository (repository "directory-name" (list test-artifact test-artifact)))
	 )
    (assert-true (record? test-repository))
    )
  )