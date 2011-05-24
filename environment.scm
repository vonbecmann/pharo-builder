(define-module (pharo-builder environment)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:export (project)
)

;;;
;;; a project
;;;
(define-class <Project> ()
  (directory-name #:accessor directory-name
		  #:init-keyword #:directory-name)
  (vm #:accessor vm
      #:init-keyword #:vm)
  (artifact #:accessor artifact
      #:init-keyword #:artifact)

)

(define (project directory-name vm artifact)
  (define new-project 
    (make <Project> #:directory directory-name
	            #:vm vm
		    #:artifact artifact))
  new-project
)

