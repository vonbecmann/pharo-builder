;;; repository.scm --- A repository of artifacts

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (core repository)
  #:use-module (ice-9 format)
  #:use-module (core oscommand)
  #:use-module (core artifact)
  #:export (
	    build-repo
	    remove
	    download-all
	    add-artifact
	    make-repository
	    add-all
	    name
	    directory-name
	    )
)

;;
;; an Artifacts Repository
;;
(define (print self port)
  (define fmt
    "Repository at directory ~S ~% with artifacts: ~% ~S ~% ")
  (display (format #f
		   fmt
		   (directory-name self)
		   (artifacts self)) port)
)

(define fields '(artifacts directory-name))

(define repository 
  (make-record-type "repository" 
		    fields
		    print)
)

(define make-repository
  (record-constructor repository 
		      fields
		      )
)

(define artifacts
  (record-accessor repository 'artifacts)
)

(define set-artifacts
  (record-modifier repository 'artifacts)
)

(define directory-name
  (record-accessor repository 'directory-name)
)

(define (add-artifact self artifact)
  (set-repository artifact self)
  (set-artifacts self (append (artifacts self) (list artifact)))
)

(define (add-all self artifact-list)
  (if (not (null? artifact-list))
      (begin
	(add-artifact self (car artifact-list))
	(add-all self (cdr artifact-list)))
   )
)

(define (download-all self)
  (map download (artifacts self))
)

(define (build-repo self)
  (mk-directory (directory-name self))
  (download-all self)
)

(define (remove self)
  (rm-directory (directory-name self))
)

;;; repository.scm ends here
