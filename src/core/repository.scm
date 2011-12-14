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
	    new-repository-for
	    add-all
	    name
	    directory-name
	    artifact-ref
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
		   (hash-to-pair-list (artifacts self))) port)
)

(define (hash-to-pair-list table)
  (hash-map->list cons table)
)

(define (hash-to-artifact-list table)
  (hash-map->list (lambda (key value) value) table)
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
  (hashq-set! (artifacts self) (artifact-name artifact) artifact)
)

(define (add-all self artifact-list)
  (if (not (null? artifact-list))
      (begin
	(add-artifact self (car artifact-list))
	(add-all self (cdr artifact-list)))
   )
)

(define (download-all self)
  (map download (hash-to-artifact-list (artifacts self)))
)

(define (build-repo self)
  (mk-directory (directory-name self))
  (download-all self)
)

(define (remove self)
  (rm-directory (directory-name self))
)

(define (new-repository-for directory)
  (make-repository (make-hash-table) directory)
)

(define (artifact-ref self artifact-name)
  (hashq-ref (artifacts self) artifact-name)
)

;;; repository.scm ends here
