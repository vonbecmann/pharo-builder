;;; conf-builder.scm --- a configuration builder

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (pharo-builder conf-builder)
  #:use-module (oop goops)
  #:use-module (pharo-builder artifacts)
  #:use-module (pharo-builder vm)
  #:export (
	    make-artifact
	    make-repository
	    make-vm
	    )
)

(define (make-artifact name directory-name download-URL)
  "make an artifact named NAME at DIRECTORY-NAME and
   download from DOWNLOAD-URL"
  (define new-artifact
          (make <artifact>
	    #:name name
	    #:directory-name directory-name
	    #:download-from download-URL))
  new-artifact)

(define (make-repository directory-name artifact-list)
  "make a repository with ARTIFACTS-LIST at a DIRECTORY-NAME"
  (define new-repository
    (make <artifacts-repository>
			   #:directory-name directory-name))
  (add-all new-repository artifact-list)
  new-repository
)

(define (make-vm path-to-executable)
  "create a new vm with PATH-TO-EXECUTABLE."
  (define new-vm
    (make <vm> #:path-to-executable path-to-executable))
  new-vm
)
;;; conf-builder.scm ends here
